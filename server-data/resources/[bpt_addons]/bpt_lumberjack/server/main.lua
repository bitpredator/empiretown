ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('bpt_woodcutter:pickedUpWood')
AddEventHandler('bpt_woodcutter:pickedUpWood', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('wood')

	if xItem.weight ~= -1 and (xItem.count + 1) > xItem.weight then
		TriggerClientEvent('esx:showNotification', _U('wood_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 3)
	end
end)

ESX.RegisterServerCallback('bpt_woodcutter:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.weight ~= -1 and xItem.count >= xItem.weight then
		cb(false)
	else
		cb(true)
	end
end)