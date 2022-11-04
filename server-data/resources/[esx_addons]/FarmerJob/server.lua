if cfg.esxLegacy == false then
    ESX = nil
    ESX = exports["es_extended"]:getSharedObject()
end

RegisterNetEvent("apple:getapple")
AddEventHandler("apple:getapple", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.canCarryItem("apple", 1) then
        xPlayer.addInventoryItem("apple", 1)
    else
        TriggerClientEvent('esx:showNotification', source, cfg.translation['limit'])
    end
end)
