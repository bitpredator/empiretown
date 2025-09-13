TriggerEvent("bpt_society:registerSociety", "unicorn", "Unicorn", "society_unicorn", "society_unicorn", "society_unicorn", {
    type = "public",
})

if Config.MaxInService ~= -1 then
    TriggerEvent("esx_service:activateService", "unicorn", Config.MaxInService)
end

RegisterServerEvent("esx_billing:sendBill")
AddEventHandler("esx_billing:sendBill", function(playerId, society, label, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(playerId)

    if not target then
        print(("[Billing] %s tried to send bill to invalid player (%s)"):format(src, tostring(playerId)))
        return
    end

    if amount <= 0 then
        print(("[Billing] Invalid amount (%s) from %s"):format(amount, src))
        return
    end

    TriggerEvent("esx_billing:sendBill", playerId, society, label, amount, xPlayer.identifier)
end)

ESX.RegisterServerCallback("bpt_unicornjob:SpawnVehicle", function(source, cb, model, props)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "unicorn" then
        print(("[^3WARNING^7] Player ^5%s^7 attempted to Exploit Vehicle Spawing!!"):format(source))
        return
    end
    local SpawnPoint = vector3(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z)
    ESX.OneSync.SpawnVehicle(joaat(model), SpawnPoint, Config.Zones.VehicleSpawnPoint.Heading, props, function()
        local vehicle = NetworkGetEntityFromNetworkId()
        while GetVehicleNumberPlateText(vehicle) ~= props.plate do
            Wait(0)
        end
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)
    cb()
end)

RegisterNetEvent("bpt_unicornjob:getStockItem")
AddEventHandler("bpt_unicornjob:getStockItem", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "unicorn" then
        TriggerEvent("bpt_addoninventory:getSharedInventory", "society_unicorn", function(inventory)
            local item = inventory.getItem(itemName)

            -- is there enough in the society?
            if count > 0 and item.count >= count then
                -- can the player carry the said amount of x item?
                if xPlayer.canCarryItem(itemName, count) then
                    inventory.removeItem(itemName, count)
                    xPlayer.addInventoryItem(itemName, count)
                    xPlayer.showNotification(TranslateCap("have_withdrawn", count, item.label))
                else
                    xPlayer.showNotification(TranslateCap("player_cannot_hold"))
                end
            else
                xPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        end)
    else
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_unicornjob:getStockItem^7 (cheating)"):format(source))
    end
end)

ESX.RegisterServerCallback("bpt_unicornjob:getStockItems", function(_, cb)
    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_unicorn", function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent("bpt_unicornjob:putStockItems")
AddEventHandler("bpt_unicornjob:putStockItems", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    if xPlayer.job.name == "unicorn" then
        TriggerEvent("bpt_addoninventory:getSharedInventory", "society_unicorn", function(inventory)
            local item = inventory.getItem(itemName)

            if sourceItem.count >= count and count > 0 then
                xPlayer.removeInventoryItem(itemName, count)
                inventory.addItem(itemName, count)
                xPlayer.showNotification(TranslateCap("have_deposited", count, item.label))
            else
                xPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        end)
    else
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_unicornjob:putStockItems^7 (cheating)"):format(source))
    end
end)
