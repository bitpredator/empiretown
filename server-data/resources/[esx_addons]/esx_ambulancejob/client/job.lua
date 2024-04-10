local CurrentAction, CurrentActionMsg, CurrentActionData = nil, "", {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy, deadPlayers, deadPlayerBlips, isOnDuty, vehicle = false, {}, {}, false, {}
isInShopMenu = false

function OpenAmbulanceActionsMenu()
	local elements = {
		{ unselectable = true, icon = "fas fa-shirt", title = "Ambulance Actions" },
		{ icon = "fas fa-shirt", title = TranslateCap("cloakroom"), value = "cloakroom" },
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == "boss" then
		elements[#elements + 1] = {
			icon = "fas fa-ambulance",
			title = TranslateCap("boss_actions"),
			value = "boss_actions",
		}
	end

	ESX.OpenContext("right", elements, function(_, element)
		if element.value == "cloakroom" then
			OpenCloakroomMenu()
		elseif element.value == "boss_actions" then
			TriggerEvent("esx_society:openBossMenu", "ambulance", function(_, menu)
				menu.close()
			end, { wash = false })
		end
	end)
end

function OpenMobileAmbulanceActionsMenu()
	local elements = {
		{ unselectable = true, icon = "fas fa-ambulance", title = TranslateCap("ambulance") },
		{ icon = "fas fa-ambulance", title = TranslateCap("ems_menu"), value = "citizen_interaction" },
	}

	ESX.OpenContext("right", elements, function(_, element)
		if element.value == "citizen_interaction" then
			local elements2 = {
				{ unselectable = true, icon = "fas fa-ambulance", title = element.title },
				{ icon = "fas fa-syringe", title = TranslateCap("ems_menu_revive"), value = "revive" },
				{ icon = "fas fa-bandage", title = TranslateCap("ems_menu_small"), value = "small" },
				{ icon = "fas fa-bandage", title = TranslateCap("ems_menu_big"), value = "big" },
				{ icon = "fas fa-car", title = TranslateCap("ems_menu_putincar"), value = "put_in_vehicle" },
				{ icon = "fas fa-syringe", title = TranslateCap("ems_menu_search"), value = "search" },
				{ icon = "fas fa-syringe", title = TranslateCap("billing"), value = "billing" },
			}

			ESX.OpenContext("right", elements2, function(_, element2)
				if isBusy then
					return
				end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if element2.value == "search" then
					TriggerServerEvent("esx_ambulancejob:svsearch")
				elseif closestPlayer == -1 or closestDistance > 1.0 then
					ESX.ShowNotification(TranslateCap("no_players"))
				else
					if element2.value == "revive" then
						revivePlayer(closestPlayer)
					elseif element2.value == "small" then
						ESX.TriggerServerCallback("esx_ambulancejob:getItemAmount", function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									ESX.ShowNotification(TranslateCap("heal_inprogress"))
									TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
									Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent("esx_ambulancejob:removeItem", "bandage")
									TriggerServerEvent(
										"esx_ambulancejob:heal",
										GetPlayerServerId(closestPlayer),
										"small"
									)
									ESX.ShowNotification(TranslateCap("heal_complete", GetPlayerName(closestPlayer)))
									isBusy = false
								else
									ESX.ShowNotification(TranslateCap("player_not_conscious"))
								end
							else
								ESX.ShowNotification(TranslateCap("not_enough_bandage"))
							end
						end, "bandage")
					elseif element2.value == "big" then
						ESX.TriggerServerCallback("esx_ambulancejob:getItemAmount", function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									ESX.ShowNotification(TranslateCap("heal_inprogress"))
									TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
									Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent("esx_ambulancejob:removeItem", "medikit")
									TriggerServerEvent("esx_ambulancejob:heal", GetPlayerServerId(closestPlayer), "big")
									ESX.ShowNotification(TranslateCap("heal_complete", GetPlayerName(closestPlayer)))
									isBusy = false
								else
									ESX.ShowNotification(TranslateCap("player_not_conscious"))
								end
							else
								ESX.ShowNotification(TranslateCap("not_enough_medikit"))
							end
						end, "medikit")
					elseif element2.value == "put_in_vehicle" then
						TriggerServerEvent("esx_ambulancejob:putInVehicle", GetPlayerServerId(closestPlayer))
					end
				end
			end)
		end
	end)
end

-- billing
local billing

if billing == "billing" then
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "billing", {
		title = TranslateCap("invoice_amount"),
	}, function(data, menu)
		local amount = tonumber(data.value)
		if amount == nil then
			ESX.ShowNotification(TranslateCap("amount_invalid"))
		else
			menu.close()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(TranslateCap("no_players_near"))
			else
				TriggerServerEvent(
					"esx_billing:sendBill",
					GetPlayerServerId(closestPlayer),
					"society_ambulance",
					"Ambulance",
					amount
				)
				ESX.ShowNotification(TranslateCap("billing_sent"))
			end
		end
	end, function(_, menu)
		menu.close()
	end)
end
-- end billing

function revivePlayer(closestPlayer)
	isBusy = true

	ESX.TriggerServerCallback("esx_ambulancejob:getItemAmount", function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)

			if IsPedDeadOrDying(closestPlayerPed, 1) then
				local playerPed = PlayerPedId()
				local lib, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"
				ESX.ShowNotification(TranslateCap("revive_inprogress"))

				for _ = 1, 15 do
					Wait(900)

					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end

				TriggerServerEvent("esx_ambulancejob:removeItem", "medikit")
				TriggerServerEvent("esx_ambulancejob:revive", GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification(TranslateCap("player_notTranslateCapnconscious"))
			end
		else
			ESX.ShowNotification(TranslateCap("not_enough_medikit"))
		end
		isBusy = false
	end, "medikit")
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
CreateThread(function()
	while true do
		Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

			for hospitalNum, hospital in pairs(Config.Hospitals) do
				-- Ambulance Actions
				for k, v in ipairs(hospital.AmbulanceActions) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(
							Config.Marker.type,
							v,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							Config.Marker.x,
							Config.Marker.y,
							Config.Marker.z,
							Config.Marker.r,
							Config.Marker.g,
							Config.Marker.b,
							Config.Marker.a,
							false,
							false,
							2,
							Config.Marker.rotate,
							nil,
							nil,
							false
						)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum =
								true, hospitalNum, "AmbulanceActions", k
						end
					end
				end

				-- Vehicle Spawners
				for k, v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(
							v.Marker.type,
							v.Spawner,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							v.Marker.x,
							v.Marker.y,
							v.Marker.z,
							v.Marker.r,
							v.Marker.g,
							v.Marker.b,
							v.Marker.a,
							false,
							false,
							2,
							v.Marker.rotate,
							nil,
							nil,
							false
						)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, "Vehicles", k
						end
					end
				end

				-- Helicopter Spawners
				for k, v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(
							v.Marker.type,
							v.Spawner,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							0.0,
							v.Marker.x,
							v.Marker.y,
							v.Marker.z,
							v.Marker.r,
							v.Marker.g,
							v.Marker.b,
							v.Marker.a,
							false,
							false,
							2,
							v.Marker.rotate,
							nil,
							nil,
							false
						)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum =
								true, hospitalNum, "Helicopters", k
						end
					end
				end
			end

			-- Logic for exiting & entering markers
			if
				isInMarker and not HasAlreadyEnteredMarker
				or (
					isInMarker
					and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				)
			then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil)
					and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent("esx_ambulancejob:hasExitedMarker", LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum =
					true, currentHospital, currentPart, currentPartNum

				TriggerEvent("esx_ambulancejob:hasEnteredMarker", currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent("esx_ambulancejob:hasExitedMarker", LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Wait(500)
			end
		else
			Wait(500)
		end
	end
end)

-- Fast travels
CreateThread(function()
	while true do
		Wait(0)
		local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

		for _, hospital in pairs(Config.Hospitals) do
			-- Fast Travels
			for _, v in ipairs(hospital.FastTravels) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(
						v.Marker.type,
						v.From,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						v.Marker.x,
						v.Marker.y,
						v.Marker.z,
						v.Marker.r,
						v.Marker.g,
						v.Marker.b,
						v.Marker.a,
						false,
						false,
						2,
						v.Marker.rotate,
						nil,
						nil,
						false
					)
					letSleep = false

					if distance < v.Marker.x then
						FastTravel(v.To.coords, v.To.heading)
					end
				end
			end
		end

		if letSleep then
			Wait(500)
		end
	end
end)

AddEventHandler("esx_ambulancejob:hasEnteredMarker", function(hospital, part, partNum)
	if part == "AmbulanceActions" then
		CurrentAction = part
		CurrentActionMsg = TranslateCap("actions_prompt")
		CurrentActionData = {}
	elseif part == "Vehicles" then
		CurrentAction = part
		CurrentActionMsg = TranslateCap("garage_prompt")
		CurrentActionData = { hospital = hospital, partNum = partNum }
	elseif part == "Helicopters" then
		CurrentAction = part
		CurrentActionMsg = TranslateCap("helicopter_prompt")
		CurrentActionData = { hospital = hospital, partNum = partNum }
	end
end)

AddEventHandler("esx_ambulancejob:hasExitedMarker", function()
	if not isInShopMenu then
		ESX.CloseContext()
	end

	CurrentAction = nil
end)

-- Key Controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == "AmbulanceActions" then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == "Vehicles" then
					OpenVehicleSpawnerMenu("car", CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == "Helicopters" then
					OpenVehicleSpawnerMenu(
						"helicopter",
						CurrentActionData.hospital,
						CurrentAction,
						CurrentActionData.partNum
					)
				end

				CurrentAction = nil
			end
		elseif ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" and not isDead then
			if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent("esx_ambulancejob:putInVehicle")
AddEventHandler("esx_ambulancejob:putInVehicle", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		vehicle = ESX.Game.GetClosestVehicle(coords)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i = maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenu()
	local elements = {
		{ unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom") },
		{ icon = "fas fa-shirt", title = TranslateCap("ems_clothes_civil"), value = "citizen_wear" },
		{ icon = "fas fa-shirt", title = TranslateCap("ems_clothes_ems"), value = "ambulance_wear" },
	}

	ESX.OpenContext("right", elements, function(_, element)
		if element.value == "citizen_wear" then
			ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
				TriggerEvent("skinchanger:loadSkin", skin)
				isOnDuty = false

				for playerId, v in pairs(deadPlayerBlips) do
					RemoveBlip(v)
					deadPlayerBlips[playerId] = nil
				end
			end)
		elseif element.value == "ambulance_wear" then
			ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_male)
				else
					TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_female)
				end

				isOnDuty = true
				TriggerEvent("esx_ambulancejob:setDeadPlayers", deadPlayers)
			end)
		end
	end)
end

RegisterNetEvent("esx_ambulancejob:heal")
AddEventHandler("esx_ambulancejob:heal", function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == "small" then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == "big" then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(TranslateCap("healed"))
	end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	if isOnDuty and job ~= "ambulance" then
		for playerId, v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		isOnDuty = false
	end
end)

RegisterNetEvent("esx_ambulancejob:setDeadPlayers")
AddEventHandler("esx_ambulancejob:setDeadPlayers", function(_deadPlayers)
	deadPlayers = _deadPlayers

	if isOnDuty then
		for playerId, v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		for playerId, status in pairs(deadPlayers) do
			if status == "distress" then
				local player = GetPlayerFromServerId(playerId)
				local playerPed = GetPlayerPed(player)
				local blip = AddBlipForEntity(playerPed)

				SetBlipSprite(blip, 303)
				SetBlipColour(blip, 1)
				SetBlipFlashes(blip, true)
				SetBlipCategory(blip, 7)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(TranslateCap("blip_dead"))
				EndTextCommandSetBlipName(blip)

				deadPlayerBlips[playerId] = blip
			end
		end
	end
end)
