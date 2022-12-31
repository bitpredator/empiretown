local HasAlreadyEnteredMarker, IsInShopMenu = false, false
local CurrentAction, CurrentActionMsg, LastZone, currentDisplayVehicle, CurrentVehicleData
local CurrentActionData, Vehicles, Categories = {}, {}, {}
local VehiclesByModel = {}
local vehiclesByCategory = {}

function getVehicleFromModel(model)
	return VehiclesByModel[model]
end

function PlayerManagement()
	if not Config.EnablePlayerManagement then
		return
	end

	if ESX.PlayerData.job.name ~= 'cardealer' then
		Config.Zones.ShopEntering.Type = -1
		Config.Zones.BossActions.Type  = -1
		Config.Zones.ResellVehicle.Type = -1
		return
	end
	Config.Zones.ShopEntering.Type = 1

	if ESX.PlayerData.job.grade_name == 'boss' then
		Config.Zones.BossActions.Type = 1
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	PlayerManagement()
	TriggerServerEvent("esx_vehicleshop:getVehiclesAndCategories")
end)

RegisterNetEvent('esx_vehicleshop:updateVehiclesAndCategories', function(vehicles, categories, vehiclesByModel)
	Vehicles = vehicles
	Categories = categories

	VehiclesByModel = vehiclesByModel

	table.sort(Vehicles, function(a, b)
		return a.name < b.name
	end)

	for _, vehicle in ipairs(Vehicles) do
		if IsModelInCdimage(joaat(vehicle.model)) then
			local category = vehicle.category

			if not vehiclesByCategory[category] then
				vehiclesByCategory[category] = {}
			end

			table.insert(vehiclesByCategory[category], vehicle)
		else
			print(('[^3WARNING^7] Ignoring vehicle ^5%s^7 due to invalid Model'):format(vehicle.model))
		end
	end
end)

RegisterNetEvent('esx:setJob', PlayerManagement)

function DeleteDisplayVehicleInsideShop()
	local attempt = 0

	if currentDisplayVehicle and DoesEntityExist(currentDisplayVehicle) then
		while DoesEntityExist(currentDisplayVehicle) and not NetworkHasControlOfEntity(currentDisplayVehicle) and attempt < 100 do
			Wait(100)
			NetworkRequestControlOfEntity(currentDisplayVehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(currentDisplayVehicle) and NetworkHasControlOfEntity(currentDisplayVehicle) then
			ESX.Game.DeleteVehicle(currentDisplayVehicle)
		end
	end
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for k, v in ipairs(vehicles) do
			local returnPrice = ESX.Math.Round(v.price * 0.75)
			local vehicleLabel = getVehicleFromModel(v.vehicle).label

			table.insert(elements, {
				label = ('%s [<span style="color:orange;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(returnPrice))),
				value = v.vehicle
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_provider_menu', {
			title    = _U('return_provider_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_vehicleshop:returnProvider', data.current.value)

			Wait(300)
			menu.close()
			ReturnVehicleProvider()
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StartShopRestriction()
	CreateThread(function()
		while IsInShopMenu do
			Wait(0)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

function OpenShopMenu()
	if #Vehicles == 0 then
		print('[^3ERROR^7] Vehicleshop has ^50^7 vehicles, please add some!')
		return
	end

	IsInShopMenu = true

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos)

	local elements           = {}
	local firstVehicleData   = nil

	for i=1, #Categories, 1 do
		local category         = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local options          = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(options, ('%s <span style="color:green;">%s</span>'):format(vehicle.name, _U('generic_shopitem', ESX.Math.GroupDigits(vehicle.price))))
		end

		table.sort(options)

		table.insert(elements, {
			name    = category.name,
			label   = category.label,
			value   = 0,
			type    = 'slider',
			max     = #Categories[i],
			options = options
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('car_dealer'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			align = 'top-left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				if Config.EnablePlayerManagement then
					ESX.TriggerServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(success)
						if success then
							IsInShopMenu = false
							DeleteDisplayVehicleInsideShop()

							CurrentAction     = 'shop_menu'
							CurrentActionMsg  = _U('shop_menu')
							CurrentActionData = {}

							local playerPed = PlayerPedId()
							FreezeEntityPosition(playerPed, false)
							SetEntityVisible(playerPed, true)
							SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

							menu2.close()
							menu.close()
							ESX.ShowNotification(_U('vehicle_purchased'))
						else
							ESX.ShowNotification(_U('broke_company'))
						end
					end, vehicleData.model)
				else
					local generatedPlate = GeneratePlate()

					ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(success)
						if success then
							IsInShopMenu = false
							menu2.close()
							menu.close()
							DeleteDisplayVehicleInsideShop()
							FreezeEntityPosition(playerPed, false)
							SetEntityVisible(playerPed, true)
						else
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end, vehicleData.model, generatedPlate)
				end
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		DeleteDisplayVehicleInsideShop()
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

		IsInShopMenu = false
	end, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()

		DeleteDisplayVehicleInsideShop()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
			currentDisplayVehicle = vehicle
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(vehicleData.model)
		end)
	end)

	DeleteDisplayVehicleInsideShop()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
		currentDisplayVehicle = vehicle
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(firstVehicleData.model)
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

function OpenResellerMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller', {
		title    = _U('car_dealer'),
		align    = 'top-left',
		elements = {
			{label = _U('buy_vehicle'),                    value = 'buy_vehicle'},
			{label = _U('pop_vehicle'),                    value = 'pop_vehicle'},
			{label = _U('depop_vehicle'),                  value = 'depop_vehicle'},
			{label = _U('return_provider'),                value = 'return_provider'},
			{label = _U('create_bill'),                    value = 'create_bill'},
			{label = _U('get_rented_vehicles'),            value = 'get_rented_vehicles'},
			{label = _U('set_vehicle_owner_sell'),         value = 'set_vehicle_owner_sell'},
			{label = _U('set_vehicle_owner_rent'),         value = 'set_vehicle_owner_rent'}
	}}, function(data, menu)
		local action = data.current.value

		if Config.OxInventory and (action == 'put_stock' or action == 'get_stock') then
			exports.ox_inventory:openInventory('stash', 'society_cardealer')
		elseif action == 'buy_vehicle' then
			OpenShopMenu()
		elseif action == 'pop_vehicle' then
			OpenPopVehicleMenu()
		elseif action == 'depop_vehicle' then
			if currentDisplayVehicle then
				DeleteDisplayVehicleInsideShop()
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		elseif action == 'return_provider' then
			ReturnVehicleProvider()
		elseif action == 'create_bill' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer ~= -1 and closestDistance < 3 then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_sell_amount', {
					title = _U('invoice_amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu2.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_U('no_players'))
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_cardealer', _U('car_dealer'), tonumber(data2.value))
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				ESX.ShowNotification(_U('no_players'))
			end
		elseif action == 'get_rented_vehicles' then
			OpenRentedVehiclesMenu()
		elseif action == 'set_vehicle_owner_sell' then
			if currentDisplayVehicle then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDistance < 3 then
					local newPlate = GeneratePlate()
					local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
					vehicleProps.plate = newPlate
					SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
					TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps, CurrentVehicleData.model, CurrentVehicleData.name)
					currentDisplayVehicle = nil
				else
					ESX.ShowNotification(_U('no_players'))
				end
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		elseif action == 'set_vehicle_owner_rent' then
			if currentDisplayVehicle then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDistance < 3 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_rent_amount', {
						title = _U('rental_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if not amount then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer ~= -1 and closestDistance < 3 then
								local newPlate = 'RENT' .. string.upper(ESX.GetRandomString(4))
								local model = CurrentVehicleData.model
								SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
								TriggerServerEvent('esx_vehicleshop:rentVehicle', model, newPlate, amount, GetPlayerServerId(closestPlayer))
								currentDisplayVehicle = nil
							else
								ESX.ShowNotification(_U('no_players'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification(_U('no_players'))
				end
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'reseller_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

function OpenPopVehicleMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for k,v in ipairs(vehicles) do
			local vehicleLabel = getVehicleFromModel(v.vehicle).label

			table.insert(elements, {
				label = ('%s [<span style="color:green;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(v.price))),
				value = v.vehicle
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'commercial_vehicles', {
			title    = _U('vehicle_dealer'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local model = data.current.value
			DeleteDisplayVehicleInsideShop()

			ESX.Game.SpawnVehicle(model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
				currentDisplayVehicle = vehicle

				for i=1, #Vehicles, 1 do
					if model == Vehicles[i].model then
						CurrentVehicleData = Vehicles[i]
						break
					end
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenRentedVehiclesMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getRentedVehicles', function(vehicles)
		local elements = {}

		for k,v in ipairs(vehicles) do
			local vehicleLabel = getVehicleFromModel(v.name).label

			table.insert(elements, {
				label = ('%s: %s - <span style="color:orange;">%s</span>'):format(v.playerName, vehicleLabel, v.plate),
				value = v.name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rented_vehicles', {
			title    = _U('rent_vehicle'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller',{
		title    = _U('dealer_boss'),
		align    = 'top-left',
		elements = {
			{label = _U('boss_actions'), value = 'boss_actions'},
			{label = _U('boss_sold'), value = 'sold_vehicles'}
	}}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'cardealer', function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'sold_vehicles' then

			ESX.TriggerServerCallback('esx_vehicleshop:getSoldVehicles', function(customers)
				local elements = {
					head = { _U('customer_client'), _U('customer_model'), _U('customer_plate'), _U('customer_soldby'), _U('customer_date') },
					rows = {}
				}

				for i=1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].client,
							customers[i].model,
							customers[i].plate,
							customers[i].soldby,
							customers[i].date
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

function hasEnteredMarker(zone)
	if zone == 'ShopEntering' then
		if not Config.EnablePlayerManagement then
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('shop_menu')
			CurrentActionData = {}
		end
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'cardealer' then
			CurrentAction     = 'reseller_menu'
			CurrentActionMsg  = _U('shop_menu')
			CurrentActionData = {}
		end
	elseif zone == 'GiveBackVehicle' and Config.EnablePlayerManagement then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			CurrentAction     = 'give_back_vehicle'
			CurrentActionMsg  = _U('vehicle_menu')
			CurrentActionData = {vehicle = vehicle}
		end
	elseif zone == 'ResellVehicle' then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if joaat(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end

				if vehicleData then
					resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
					model = GetEntityModel(vehicle)
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

					CurrentAction     = 'resell_vehicle'
					CurrentActionMsg  = _U('sell_menu', vehicleData.name, ESX.Math.GroupDigits(resellPrice))

					CurrentActionData = {
						vehicle = vehicle,
						label = vehicleData.name,
						price = resellPrice,
						model = model,
						plate = plate
					}
				else
					ESX.ShowNotification(_U('invalid_vehicle'))
				end
			end
		end

	elseif zone == 'BossActions' and Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'cardealer' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end
end

function hasExitedMarker(zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end
	ESX.HideUI()
	CurrentAction = nil
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
		end

		DeleteDisplayVehicleInsideShop()
	end
end)

-- Create Blips
if Config.Blip.show then
	CreateThread(function()
		local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos)

		SetBlipSprite (blip, Config.Blip.Sprite)
		SetBlipDisplay(blip, Config.Blip.Display)
		SetBlipScale  (blip, Config.Blip.Scale)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('car_dealer'))
		EndTextCommandSetBlipName(blip)
	end)
end

-- Enter / Exit marker events & Draw Markers
CreateThread(function()
	while true do
		Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < Config.DrawDistance then
				letSleep = false

				if v.Type ~= -1 then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			LastZone = currentZone
			hasEnteredMarker(currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			hasExitedMarker(LastZone)
		end

		if letSleep then
			Wait(500)
		end
	end
end)

-- Key controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction then
			ESX.TextUI(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					if Config.LicenseEnable then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDriversLicense)
							if hasDriversLicense then
								OpenShopMenu()
							else
								ESX.ShowNotification(_U('license_missing'))
							end
						end, GetPlayerServerId(PlayerId()), 'drive')
					else
						OpenShopMenu()
					end
				elseif CurrentAction == 'reseller_menu' then
					OpenResellerMenu()
				elseif CurrentAction == 'give_back_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:giveBackVehicle', function(isRentedVehicle)
						if isRentedVehicle then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('delivered'))
						else
							ESX.ShowNotification(_U('not_rental'))
						end
					end, ESX.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle)))
				elseif CurrentAction == 'resell_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
						if vehicleSold then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('vehicle_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
						else
							ESX.ShowNotification(_U('not_yours'))
						end
					end, CurrentActionData.plate, CurrentActionData.model)
				elseif CurrentAction == 'boss_actions_menu' then
					OpenBossActionsMenu()
				end
				ESX.HideUI()
				CurrentAction = nil
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	PinInteriorInMemory(interiorID)
	ActivateInteriorEntitySet(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

if ESX.PlayerLoaded then PlayerManagement() end