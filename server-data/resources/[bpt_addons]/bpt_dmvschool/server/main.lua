ESX.RegisterServerCallback("bpt_dmvschool:canYouPay", function(source, cb, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Config.Prices[type] then
        xPlayer.removeMoney(Config.Prices[type], "DMV Purchase")
        TriggerClientEvent("esx:showNotification", source, TranslateCap("you_paid", Config.Prices[type]))
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("esx:playerLoaded", function(source)
    TriggerEvent("esx_license:getLicenses", source, function(licenses)
        TriggerClientEvent("bpt_dmvschool:loadLicenses", source, licenses)
    end)
end)

RegisterNetEvent("bpt_dmvschool:addLicense")
AddEventHandler("bpt_dmvschool:addLicense", function(type)
    local source = source

    TriggerEvent("esx_license:addLicense", source, type, function()
        TriggerEvent("esx_license:getLicenses", source, function(licenses)
            TriggerClientEvent("bpt_dmvschool:loadLicenses", source, licenses)
        end)
    end)
end)
