local lastPlayerSuccess = {}

if Config.MaxInService ~= -1 then
    TriggerEvent('esx_service:activateService', 'dustman', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'dustman', _U('dustman_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'dustman', 'Dustman', 'society_dustman', 'society_dustman', 'society_dustman', {
    type = 'public'
})

ESX.RegisterServerCallback("bpt_dustmanjob:SpawnVehicle", function(source, cb, model , props)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "dustman" then 
        print(('[^3WARNING^7] Player ^5%s^7 attempted to Exploit Vehicle Spawing!!'):format(source))
        return
    end
    local SpawnPoint = vector3(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z)
    ESX.OneSync.SpawnVehicle(joaat(model), SpawnPoint, Config.Zones.VehicleSpawnPoint.Heading, props, function(vehicle)
        local vehicle = NetworkGetEntityFromNetworkId(vehicle)
        while GetVehicleNumberPlateText(vehicle) ~= props.plate do
            Wait(0)
        end
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)
    cb()
end)

RegisterNetEvent('bpt_dustmanjob:getStockItem')
AddEventHandler('bpt_dustmanjob:getStockItem', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'dustman' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_dustman', function(inventory)
            if item == nil then
				print("ERROR: Player get inventory item is value nil! Current item name: "..itemName)
				return
			end

            -- is there enough in the society?
            if count > 0 and item.count >= count then
                -- can the player carry the said amount of x item?
                if xPlayer.canCarryItem(itemName, count) then
                    inventory.removeItem(itemName, count)
                    xPlayer.addInventoryItem(itemName, count)
                    xPlayer.showNotification(_U('have_withdrawn', count, item.label))
                else
                    xPlayer.showNotification(_U('player_cannot_hold'))
                end
            else
                xPlayer.showNotification(_U('quantity_invalid'))
            end
        end)
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_dustmanjob:getStockItem^7 (cheating)'):format(source))
    end
end)

ESX.RegisterServerCallback('bpt_dustmanjob:getStockItems', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_dustman', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent('bpt_dustmanjob:putStockItems')
AddEventHandler('bpt_dustmanjob:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
		
    if xPlayer.job.name == 'dustman' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_dustman', function(inventory)
            local item = inventory.getItem(itemName)

            if sourceItem.count >= count and count > 0 then
                xPlayer.removeInventoryItem(itemName, count)
                inventory.addItem(itemName, count)
                xPlayer.showNotification(_U('have_deposited', count, item.label))
            else
                xPlayer.showNotification(_U('quantity_invalid'))
            end
        end)
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_dustmanjob:putStockItems^7 (cheating)'):format(source))
    end
end)

ESX.RegisterServerCallback('bpt_dustmanjob:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    local minItems = xPlayer.getInventory(true)
	cb(next(minItems) ~= nil and items or false)
end)