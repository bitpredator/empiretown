ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("npc:cotton:giveItem", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local inventory = xPlayer.inventory
	local count = 0
	for i = 1, #inventory do
		if inventory[i].name == Config.item_name1 and inventory[i].count > 0 then
			count = inventory[i].count
		end
	end
	
	if count < Config.CottonMaxCount then
		xPlayer.addInventoryItem(Config.item_name1, 1)
		cb(true)
	else
		cb(false)
	end
end)