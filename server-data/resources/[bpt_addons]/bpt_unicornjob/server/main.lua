---@diagnostic disable: undefined-global
-- Registrazione società
TriggerEvent("bpt_society:registerSociety", "unicorn", "Unicorn", "society_unicorn", "society_unicorn", "society_unicorn", {
    type = "public",
})

if Config.MaxInService ~= -1 then
    TriggerEvent("esx_service:activateService", "unicorn", Config.MaxInService)
end

-- ======= SAFE BILLING WRAPPER =======
-- Client -> TriggerServerEvent("bpt_unicornjob:requestBill", targetServerId, "society_unicorn", "Unicorn", amount)
RegisterServerEvent("bpt_unicornjob:requestBill")
AddEventHandler("bpt_unicornjob:requestBill", function(targetServerId, society, label, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(targetServerId)

    if not xPlayer then
        print(("[Billing] Invalid source player (%s) tried to request a bill"):format(tostring(src)))
        return
    end

    if not target then
        print(("[Billing] %s tried to send bill to invalid player (%s)"):format(src, tostring(targetServerId)))
        return
    end

    if not amount or tonumber(amount) <= 0 then
        print(("[Billing] Invalid amount (%s) from %s"):format(tostring(amount), src))
        return
    end

    -- Chiediamo al client mittente di inviare l'evento ufficiale esx_billing (così la 'source' in esx_billing sarà corretta)
    TriggerClientEvent("bpt_unicornjob:doSendBill", src, targetServerId, society, label, tonumber(amount))
end)
-- ======= END BILLING WRAPPER =======

-- Spawn veicolo (sigillato con controlli)
ESX.RegisterServerCallback("bpt_unicornjob:SpawnVehicle", function(source, cb, model, props)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        print(("[^1ERROR^7] Invalid player (%s) tried to spawn a vehicle"):format(tostring(source)))
        cb(false)
        return
    end

    if xPlayer.job.name ~= "unicorn" then
        print(("[^3WARNING^7] Player ^5%s^7 attempted to Exploit Vehicle Spawning!!"):format(source))
        cb(false)
        return
    end

    local SpawnPoint = vector3(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z)
    ESX.OneSync.SpawnVehicle(joaat(model), SpawnPoint, Config.Zones.VehicleSpawnPoint.Heading, props, function(netId)
        local vehicle = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(vehicle) then
            TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
        end
    end)
    cb(true)
end)

-- Prelievo stock
RegisterNetEvent("bpt_unicornjob:getStockItem")
AddEventHandler("bpt_unicornjob:getStockItem", function(itemName, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    if xPlayer.job and xPlayer.job.name == "unicorn" then
        TriggerEvent("bpt_addoninventory:getSharedInventory", "society_unicorn", function(inventory)
            local item = inventory.getItem(itemName)

            if count > 0 and item.count >= count then
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
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_unicornjob:getStockItem^7 (cheating)"):format(src))
    end
end)

-- Lista stock
ESX.RegisterServerCallback("bpt_unicornjob:getStockItems", function(_, cb)
    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_unicorn", function(inventory)
        cb(inventory.items)
    end)
end)

-- Deposito stock
RegisterNetEvent("bpt_unicornjob:putStockItems")
AddEventHandler("bpt_unicornjob:putStockItems", function(itemName, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local sourceItem = xPlayer.getInventoryItem(itemName)

    if xPlayer.job and xPlayer.job.name == "unicorn" then
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
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_unicornjob:putStockItems^7 (cheating)"):format(src))
    end
end)
