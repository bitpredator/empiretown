local lastPlayerSuccess = {}

if Config.MaxInService ~= -1 then
    TriggerEvent("esx_service:activateService", "taxi", Config.MaxInService)
end

TriggerEvent("esx_phone:registerNumber", "taxi", TranslateCap("taxi_client"), true, true)
TriggerEvent("esx_society:registerSociety", "taxi", "Taxi", "society_taxi", "society_taxi", "society_taxi", {
    type = "public",
})

RegisterNetEvent("bpt_taxijob:success")
AddEventHandler("bpt_taxijob:success", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local timeNow = os.clock()

    if xPlayer.job.name == "taxi" then
        if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
            lastPlayerSuccess[source] = timeNow

            math.randomseed(os.time())
            local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)

            if xPlayer.job.grade >= 3 then
                total = total * 2
            end

            TriggerEvent("bpt_addonaccount:getSharedAccount", "society_taxi", function(account)
                if account then
                    local playerMoney = ESX.Math.Round(total / 100 * 30)
                    local societyMoney = ESX.Math.Round(total / 100 * 70)

                    xPlayer.addMoney(playerMoney, "Taxi Fair")
                    account.addMoney(societyMoney)

                    xPlayer.showNotification(TranslateCap("comp_earned", societyMoney, playerMoney))
                else
                    xPlayer.addMoney(total, "Taxi Fair")
                    xPlayer.showNotification(TranslateCap("have_earned", total))
                end
            end)
        end
    else
        print(("[^3WARNING^7] Player ^5%s^7 attempted to ^5bpt_taxijob:success^7 (cheating)"):format(source))
    end
end)

ESX.RegisterServerCallback("bpt_taxijob:SpawnVehicle", function(source, cb, model, props)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "taxi" then
        print(("[^3WARNING^7] Player ^5%s^7 attempted to Exploit Vehicle Spawing!!"):format(source))
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

RegisterNetEvent("bpt_taxijob:getStockItem")
AddEventHandler("bpt_taxijob:getStockItem", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "taxi" then
        TriggerEvent("esx_addoninventory:getSharedInventory", "society_taxi", function(inventory)
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
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_taxijob:getStockItem^7 (cheating)"):format(source))
    end
end)

ESX.RegisterServerCallback("bpt_taxijob:getStockItems", function(source, cb)
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_taxi", function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent("bpt_taxijob:putStockItems")
AddEventHandler("bpt_taxijob:putStockItems", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    if xPlayer.job.name == "taxi" then
        TriggerEvent("esx_addoninventory:getSharedInventory", "society_taxi", function(inventory)
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
        print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_taxijob:putStockItems^7 (cheating)"):format(source))
    end
end)

ESX.RegisterServerCallback("bpt_taxijob:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    cb({
        items = items,
    })
end)
