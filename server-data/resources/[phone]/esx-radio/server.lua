CreateThread(function()
	for channel, jobs in pairs(Config.RestrictedChannels) do
		exports["pma-voice"]:addChannelCheck(channel, function(source)
			return jobs[Player(source).state.job.name]
		end)
	end
end)

if Config.Item.Require then
	ESX.RegisterUsableItem(Config.Item.name, function(source)
		TriggerClientEvent("esx-radio:use", source)
	end)

	ESX.RegisterServerCallback("esx-radio:server:GetItem", function(source, cb, item)
		local xPlayer = ESX.GetPlayerFromId(source)
		local RadioItem = xPlayer.getInventoryItem(Config.Item.name).count
		cb(RadioItem >= 1)
	end)
end
