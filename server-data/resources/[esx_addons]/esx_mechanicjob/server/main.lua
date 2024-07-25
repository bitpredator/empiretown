if Config.MaxInService ~= -1 then
    TriggerEvent("esx_service:activateService", "mechanic", Config.MaxInService)
end

TriggerEvent("esx_society:registerSociety", "mechanic", "mechanic", "society_mechanic", "society_mechanic", "society_mechanic", { type = "private" })

RegisterServerEvent("esx_mechanicjob:onNPCJobMissionCompleted")
AddEventHandler("esx_mechanicjob:onNPCJobMissionCompleted", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)

    if xPlayer.job.grade >= 3 then
        total = total * 2
    end

    TriggerEvent("bpt_addonaccount:getSharedAccount", "society_mechanic", function(account)
        account.addMoney(total)
    end)

    TriggerClientEvent("esx:showNotification", source, TranslateCap("your_comp_earned") .. total)
end)

ESX.RegisterUsableItem("fixkit", function(source)
    local _ = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("fixkit", 1)

    TriggerClientEvent("esx_mechanicjob:onfixkit", source)
    TriggerClientEvent("esx:showNotification", source, TranslateCap("you_used_repair_kit"))
end)

RegisterServerEvent("esx_mechanicjob:getStockItem")
AddEventHandler("esx_mechanicjob:getStockItem", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_mechanic", function(inventory)
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
            xPlayer.showNotification(TranslateCap("invalid_quantity"))
        end
    end)
end)

ESX.RegisterServerCallback("esx_mechanicjob:getStockItems", function(_, cb)
    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_mechanic", function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent("esx_mechanicjob:putStockItems")
AddEventHandler("esx_mechanicjob:putStockItems", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_mechanic", function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            xPlayer.showNotification(TranslateCap("invalid_quantity"))
        end

        xPlayer.showNotification(TranslateCap("have_deposited", count, item.label))
    end)
end)

ESX.RegisterServerCallback("esx_mechanicjob:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    cb({ items = items })
end)
