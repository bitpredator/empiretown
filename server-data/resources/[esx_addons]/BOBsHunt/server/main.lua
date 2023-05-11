ESX = nil

ESX = exports["es_extended"]:getSharedObject(), function(response)
    ESX = response
end

RegisterServerEvent('esx_bobhunt:getPelt')
AddEventHandler('esx_bobhunt:getPelt', function(item, p_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addInventoryItem(item, 10)
	TriggerClientEvent('esx:showNotification', source, _U('you_collected') .. p_name)
end)
