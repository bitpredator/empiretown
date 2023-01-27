ESX = nil

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('wasabi_mining:checkPick', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("wasabi_mining:mineRock")
AddEventHandler("wasabi_mining:mineRock", function(distance)
    if distance ~= nil then
        if distance <= 3 then
            local awardItem = Config.Rocks[math.random(#Config.Rocks)]
            local xPlayer = ESX.GetPlayerFromId(source)
            local awardItemLabel = ESX.GetItemLabel(awardItem)
            if Config.OldESX then
                local limitItem = xPlayer.getInventoryItem(awardItem)
                if limitItem.limit == -1 or (limitItem.count + 1) <= limitItem.limit then
                    xPlayer.addInventoryItem(awardItem, 1)
                    TriggerClientEvent('wasabi_mining:notify', source, Language['rewarded']..' '..awardItemLabel)
                else
                    TriggerClientEvent('wasabi_mining:notify', source, Language['cantcarry']..' '..awardItemLabel)
                end
            else
                if xPlayer.canCarryItem(awardItem, 1) then
                    xPlayer.addInventoryItem(awardItem, 1)
                    TriggerClientEvent('wasabi_mining:notify', source, Language['rewarded']..' '..awardItemLabel)
                else
                    TriggerClientEvent('wasabi_mining:notify', source, Language['cantcarry']..' '..awardItemLabel)
                end
            end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            TriggerClientEvent('wasabi_mining:alertStaff', source)
            if Config.DiscordCheatLogs then
                sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just mined rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
            end
            Wait(2000)
            xPlayer.kick(Language['kicked'])
        end
    else
        TriggerClientEvent('wasabi_mining:alertStaff', source)
        if Config.DiscordCheatLogs then
            sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** just mined rocks and failed the distance check!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick(Language['kicked'])
    end
end)


RegisterServerEvent('wasabi_mining:axeBroke')
AddEventHandler('wasabi_mining:axeBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem('pickaxe')
    if xItem.count >= 1 then
        xPlayer.removeInventoryItem('pickaxe', 1)
    else
        if Config.DiscordCheatLogs then
            sendToDiscord("Wasabi Mining","**"..GetPlayerName(source).."** broke a pickaxe without having one in inventory!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick(Language['kicked'])
    end
end)
