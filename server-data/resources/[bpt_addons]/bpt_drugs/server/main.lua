local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('bpt_drugs:pickedUpCannabis')
AddEventHandler('bpt_drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local cime = math.random(1,10)

	if xPlayer.canCarryItem('cannabis', cime) then
		xPlayer.addInventoryItem('cannabis', cime)
	else
		xPlayer.showNotification(_U('weed_inventoryfull'))
	end
end)

ESX.RegisterServerCallback('bpt_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

RegisterServerEvent('bpt_drugs:outofbound')
AddEventHandler('bpt_drugs:outofbound', function()
	outofbound = true
end)

ESX.RegisterServerCallback('bpt_drugs:cannabis_count', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xCannabis = xPlayer.getInventoryItem('cannabis').count
	cb(xCannabis)
end)
