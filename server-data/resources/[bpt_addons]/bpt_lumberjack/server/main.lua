ESX = nil
local playersProcessingWood = {}
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

RegisterServerEvent('bpt_woodcutter:processWood')
AddEventHandler('bpt_woodcutter:processWood', function()
	if not playersProcessingWood[source] then
		local _source = source

		playersProcessingWood[_source] = ESX.SetTimeout(Config.Delays.WoodProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xWood, xChoppedwood = xPlayer.getInventoryItem('wood'), xPlayer.getInventoryItem('choppedwood')

			if xChoppedwood.weight ~= -1 and (xChoppedwood.count + 1) >= xChoppedwood.weight then
				TriggerClientEvent('esx:showNotification', _source, _U('wood_processingfull'))
			elseif xWood.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('wood_processingenough'))
			else
				xPlayer.removeInventoryItem('wood', 5)
				xPlayer.addInventoryItem('choppedwood', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('wood_processed'))
			end

			playersProcessingWood[_source] = nil
		end)
	else
	end
end)

function CancelProcessing(playerID)
	if playersProcessingWood[playerID] then
		ESX.ClearTimeout(playersProcessingWood[playerID])
		playersProcessingWood[playerID] = nil
	end
end

RegisterServerEvent('bpt_woodcutter:cancelProcessing')
AddEventHandler('bpt_woodcutter:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	CancelProcessing(source)
end)