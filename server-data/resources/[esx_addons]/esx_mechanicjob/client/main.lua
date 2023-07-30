local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable  = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'), "error")
	else
		TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
	end
end

function OpenMechanicActionsMenu()
	local elements = {
		{unselectable = true, icon = "fas fa-gear", title = _U('mechanic')},
		{icon = "fas fa-car",   title = _U('vehicle_list'),   value = 'vehicle_list'},
		{icon = "fas fa-shirt", title = _U('work_wear'),      value = 'cloakroom'},
		{icon = "fas fa-shirt", title = _U('civ_wear'),       value = 'cloakroom2'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		elements[#elements+1] = {
			icon = 'fas fa-boss',
			title = _U('boss_actions'),
			value = 'boss_actions'
		}
	end

	ESX.OpenContext("right", elements, function(_,element)
		if element.value == 'vehicle_list' then
			if Config.EnableSocietyOwnedVehicles then
				local elements2 = {
					{unselectable = true, icon = "fas fa-car", title = _U('service_vehicle')}
				}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						elements2[#elements2+1] = {
							icon = 'fas fa-car',
							title = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						}
					end

					ESX.OpenContext("right", elements2, function()
						ESX.CloseContext()
						local vehicleProps = element.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
					end)
				end, 'mechanic')
			else
				local elements2 = {
					{unselectable = true, icon = "fas fa-car", title = _U('service_vehicle')},
					{icon = "fas fa-truck", title = _U('flat_bed'),  value = 'flatbed'},
					{icon = "fas fa-truck", title = _U('tow_truck'), value = 'towtruck2'}
				}

				if Config.EnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'experimente') then
					elements2[#elements2+1] = {
						icon = 'fas fa-truck',
						title = 'Slamvan',
						value = 'slamvan3'
					}
				end

				ESX.OpenContext("right", elements2, function(_,element2)
					if Config.MaxInService == -1 then
						ESX.CloseContext()
						ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.CloseContext()
								ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mechanic')
					end
				end)
			end
		elseif element.value == 'cloakroom' then
			ESX.CloseContext()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif element.value == 'cloakroom2' then
			ESX.CloseContext()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif Config.OxInventory and (element.value == 'put_stock' or element.value == 'get_stock') then
			exports.ox_inventory:openInventory('stash', 'society_mechanic')
		elseif element.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(_, menu)
				menu.close()
			end)
		end
	end, function()
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMechanicHarvestMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{unselectable = true, icon = "fas fa-gear", title = "Mechanic Harvest Menu"},
			{icon = "fas fa-gear", title = _U('gas_can'), value = 'gaz_bottle'},
			{icon = "fas fa-gear", title = _U('repair_tools'), value = 'fix_tool'},
			{icon = "fas fa-gear", title = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.OpenContext("right", elements, function(_,element)
			if element.value == 'gaz_bottle' then
				TriggerServerEvent('esx_mechanicjob:startHarvest')
			elseif element.value == 'fix_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest2')
			elseif element.value == 'caro_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest3')
			end
		end, function()
			CurrentAction     = 'mechanic_harvest_menu'
			CurrentActionMsg  = _U('harvest_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMobileMechanicActionsMenu()
	local elements = {
		{unselectable = true, icon = "fas fa-gear", title = _U('mechanic')},
		{icon = "fas fa-gear", title = _U('billing'),       value = 'billing'},
		{icon = "fas fa-gear", title = _U('hijack'),        value = 'hijack_vehicle'},
		{icon = "fas fa-gear", title = _U('repair'),        value = 'fix_vehicle'},
		{icon = "fas fa-gear", title = _U('clean'),         value = 'clean_vehicle'},
		{icon = "fas fa-gear", title = _U('imp_veh'),       value = 'del_vehicle'},
		{icon = "fas fa-gear", title = _U('flat_bed'),      value = 'dep_vehicle'},
		{icon = "fas fa-gear", title = _U('place_objects'), value = 'object_spawner'}
	}

	ESX.OpenContext("right", elements, function(menu,element)
		if isBusy then return end

		if element.value == "billing" then
			local elements2 = {
				{unselectable = true, icon = "fas fa-scroll", title = element.title},
				{title = "Amount", input = true, inputType = "number", inputMin = 1, inputMax = 250000, inputPlaceholder = "Amount to bill.."},
				{icon = "fas fa-check-double", title = "Confirm", value = "confirm"}
			}

			ESX.OpenContext("right", elements2, function(menu2,element2)
				local amount = tonumber(menu2.eles[2].inputValue)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'), "error")
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'), "error")
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end)
		elseif element.value == "hijack_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				CreateThread(function()
					Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_unlocked'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif element.value == "fix_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				CreateThread(function()
					Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_repaired'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif element.value == "clean_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				CreateThread(function()
					Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif element.value == "del_vehicle" then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		elseif element.value == "dep_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = `flatbed`
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(_U('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(_U('please_drop_off'))
										Config.Zones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(_U('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(_U('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(_U('not_right_veh'))
							end

						else
							ESX.ShowNotification(_U('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(_U('veh_det_succ'))
				end
			else
				ESX.ShowNotification(_U('imp_flatbed'))
			end
		elseif element.value == "object_spawner" then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			local elements2 = {
				{unselectable= true, icon = "fas fa-object", title = _U('objects')},
				{icon = "fas fa-object", title = _U('roadcone'), value = 'prop_roadcone02a'},
				{icon = "fas fa-object", title = _U('toolbox'),  value = 'prop_toolchest_01'}
			}

			ESX.OpenContext("right", elements2, function(menuObj,elementObj)
				local model   = elementObj.value
				local coords  = GetEntityCoords(playerPed)
				local forward = GetEntityForwardVector(playerPed)
				local x, y, z = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				elseif model == 'prop_toolchest_01' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end)
		end
	end)
end

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			CreateThread(function()
				Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			CreateThread(function()
				Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function()
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Pop NPC mission vehicle when inside area
CreateThread(function()
	while true do
		local Sleep = 1500

		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			Sleep = 0
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCSpawnDistance then
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			Sleep = 500
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCNextToDistance then
				Sleep = 0
				ESX.ShowNotification(_U('please_tow'))
				NPCHasBeenNextToTowable = true
			end
		end
	Wait(Sleep)
	end
end)

-- Create Blips
CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
CreateThread(function()
	while true do
		local Sleep = 2000

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			Sleep = 500
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true

			for _,v in pairs(Config.Zones) do
				if v.Type ~= -1 and #(coords - v.Pos) < Config.DrawDistance then
					Sleep = 0
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, true, nil, nil, false)
					letSleep = false
				end
			end
		end
	Wait(Sleep)
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		local Sleep = 500

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(#(coords - v.Pos) < v.Size.x) then
					Sleep = 0
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
			end
		end
	Wait(Sleep)
	end
end)

CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
		Wait(500)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, joaat(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = #(coords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
CreateThread(function()
	while true do
	local sleep = 500
		if CurrentAction then
			sleep = 0
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				if CurrentAction == 'mechanic_actions_menu' then
					OpenMechanicActionsMenu()
				elseif CurrentAction == 'mechanic_harvest_menu' then
					OpenMechanicHarvestMenu()
				elseif CurrentAction == 'delete_vehicle' then
			if Config.EnableSocietyOwnedVehicles then

				local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
				TriggerServerEvent('esx_society:putVehicleInGarage', 'mechanic', vehicleProps)
			else
				local entityModel = GetEntityModel(CurrentActionData.vehicle)

				if entityModel == `flatbed` or	entityModel == `towtruck2` or entityModel == `slamvan3` then
					TriggerServerEvent('esx_service:disableService', 'mechanic')
				end
			end
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	elseif CurrentAction == 'remove_entity' then
		DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			 end
		 end
		Wait(sleep)
	end
end)
RegisterCommand('mechanicMenu', function()
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			OpenMobileMechanicActionsMenu()
		end
end, false)



RegisterCommand('mechanicjob', function()
	local playerPed = PlayerPedId()
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if NPCOnJob then
				if GetGameTimer() - NPCLastCancel > 5 * 60000 then
					StopNPCJob(true)
					NPCLastCancel = GetGameTimer()
				else
					ESX.ShowNotification(_U('wait_five'), "error")
				end
			else
				if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `flatbed`) then
					StartNPCJob()
				else
					ESX.ShowNotification(_U('must_in_flatbed'), "error")
				end
			end
		end
end, false)

RegisterKeyMapping('mechanicMenu', 'Open Mechanic Menu', 'keyboard', 'F6')
RegisterKeyMapping('mechanicjob', 'Togggle NPC Job', 'keyboard', 'F6')

AddEventHandler('esx:onPlayerDeath', function() isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function() isDead = false end)
