TriggerEvent("esx_society:registerSociety", "ballas", "ballas", "society_ballas", "society_ballas", "society_ballas", {
	type = "public",
})

ESX.RegisterServerCallback("bpt_ballasjob:getPlayerInventory", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items,
	})
end)

RegisterNetEvent("bpt_ballasjob:getStockItem")
AddEventHandler("bpt_ballasjob:getStockItem", function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "ballas" then
		TriggerEvent("esx_addoninventory:getSharedInventory", "society_ballas", function(inventory)
			local item = inventory.getItem(itemName)

			-- is there enough in the society?
			if count > 0 and item.count >= count then
				-- can the player carry the said amount of x item?
				if xPlayer.canCarryItem(itemName, count) then
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
					xPlayer.showNotification(TranslateCap("have_withdrawn", count, item.label))
				else
					xPlayer.showNotification(TranslateCap("player_cannot_hold"))
				end
			else
				xPlayer.showNotification(TranslateCap("quantity_invalid"))
			end
		end)
	else
		print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_ballasjob:getStockItem^7 (cheating)"):format(source))
	end
end)

ESX.RegisterServerCallback("bpt_ballasjob:getStockItems", function(_, cb)
	TriggerEvent("esx_addoninventory:getSharedInventory", "society_ballas", function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent("bpt_ballasjob:putStockItems")
AddEventHandler("bpt_ballasjob:putStockItems", function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if xPlayer.job.name == "ballas" then
		TriggerEvent("esx_addoninventory:getSharedInventory", "society_ballas", function(inventory)
			local item = inventory.getItem(itemName)

			if sourceItem.count >= count and count > 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				xPlayer.showNotification(TranslateCap("have_deposited", count, item.label))
			else
				xPlayer.showNotification(TranslateCap("quantity_invalid"))
			end
		end)
	else
		print(("[^3WARNING^7] Player ^5%s^7 attempted ^5bpt_ballasjob:putStockItems^7 (cheating)"):format(source))
	end
end)
