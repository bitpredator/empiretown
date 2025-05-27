ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("custom_drugs:sellItems", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local total = 0
    local sold = false

    for itemName, itemData in pairs(Config.SellItems) do
        local count = xPlayer.getInventoryItem(itemName).count
        if count > 0 then
            local basePrice = itemData.price * count
            local bonus = getPoliceBonus()
            local finalPrice = math.floor(basePrice * (1 + bonus))
            xPlayer.removeInventoryItem(itemName, count)
            xPlayer.addAccountMoney("black_money", finalPrice)
            TriggerClientEvent("esx:showNotification", source, ("Hai venduto %dx %s per $%s [Bonus: %d%%]"):format(count, itemName, finalPrice, bonus * 100))
            total = total + finalPrice
            sold = true
        end
    end

    if not sold then
        TriggerClientEvent("esx:showNotification", source, "Non hai nulla da vendere!")
    end
end)

function getPoliceBonus()
    local policeCount = 0
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and Config.PoliceJobs[xPlayer.job.name] then
            policeCount += 1
        end
    end
    return policeCount * Config.PoliceBonusPerUnit
end
