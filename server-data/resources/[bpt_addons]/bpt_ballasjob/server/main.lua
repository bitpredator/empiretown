local lastPlayerSuccess = {}

TriggerEvent('esx_society:registerSociety', 'ballas', 'ballas', 'society_ballas', 'society_ballas', 'society_ballas', {
    type = 'public'
})

RegisterNetEvent('bpt_ballasjob:success')
AddEventHandler('bpt_ballasjob:success', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local timeNow = os.clock()

    if xPlayer.job.name == 'ballas' then
        if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
            lastPlayerSuccess[source] = timeNow

            if xPlayer.job.grade >= 3 then
                total = total * 2
            end

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas', function(account)
                if account then
                    local playerMoney = ESX.Math.Round(total / 100 * 30)
                    local societyMoney = ESX.Math.Round(total / 100 * 70)

                    xPlayer.addMoney(playerMoney, "Ballas Fair")
                    account.addMoney(societyMoney)

                    xPlayer.showNotification(_U('comp_earned', societyMoney, playerMoney))
                else
                    xPlayer.addMoney(total, "Ballas Fair")
                    xPlayer.showNotification(_U('have_earned', total))
                end
            end)
        end
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted to ^5bpt_ballasjob:success^7 (cheating)'):format(source))
    end
end)

RegisterNetEvent('bpt_ballasjob:getStockItem')
AddEventHandler('bpt_ballasjob:getStockItem', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'ballas' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
            local item = inventory.getItem(itemName)

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
        print(('[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_ballasjob:getStockItem^7 (cheating)'):format(source))
    end
end)

ESX.RegisterServerCallback('bpt_ballasjob:getStockItems', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent('bpt_ballasjob:putStockItems')
AddEventHandler('bpt_ballasjob:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'ballas' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
            local item = inventory.getItem(itemName)

            if item.count > 0 then
                xPlayer.removeInventoryItem(itemName, count)
                inventory.addItem(itemName, count)
                xPlayer.showNotification(_U('have_deposited', count, item.label))
            else
                xPlayer.showNotification(_U('quantity_invalid'))
            end
        end)
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_ballasjob:putStockItems^7 (cheating)'):format(source))
    end
end)

ESX.RegisterServerCallback('bpt_ballasjob:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    cb({
        items = items
    })
end)
