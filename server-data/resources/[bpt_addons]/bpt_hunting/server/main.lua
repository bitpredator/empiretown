ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("bpt_hunting:getPelt")
AddEventHandler("bpt_hunting:getPelt", function(item, p_name)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem(item, 10)
    TriggerClientEvent("esx:showNotification", source, TranslateCap("you_collected") .. p_name)
end)
