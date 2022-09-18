ESX = nil

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("npc:cotton:giveItem", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local inventory = xPlayer.inventory
	local count = 0
	
	if count < Config.CottonMaxCount then
		xPlayer.addInventoryItem(Config.item_name, 1)
		cb(true)
	else
		cb(false)
	end
end)