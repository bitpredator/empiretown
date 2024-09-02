local function FoundExploiter(src, reason)
    -- ADD YOUR BAN EVENT HERE UNTIL THEN IT WILL ONLY KICK THE PLAYER --
    DropPlayer(src, reason)
end

RegisterServerEvent("bpt_pointsell:sell")
AddEventHandler("bpt_pointsell:sell", function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.DealerItems[itemName]
    local xItem = xPlayer.getInventoryItem(itemName)

    -- If this fails its 99% a mod-menu, the variables client sided are setup to provide the exact right arguments
    if type(amount) ~= "number" or type(itemName) ~= "string" then
        print(("bpt_pointsell: %s attempted to sell with invalid input type!"):format(xPlayer.identifier))
        FoundExploiter(xPlayer.source, "Sell Event Trigger")
        return
    end
    if not price then
        print(("bpt_pointsell: %s attempted to sell an invalid!"):format(xPlayer.identifier))
        return
    end
    if amount < 0 then
        print(("bpt_pointsell: %s attempted to sell an minus amount!"):format(xPlayer.identifier))
        return
    end
    if xItem == nil or xItem.count < amount then
        xPlayer.showNotification(TranslateCap("dealer_notenough"))
        return
    end

    price = ESX.Math.Round(price * amount)

    if Config.GiveBlack then
        xPlayer.addAccountMoney("black_money", price, "Sell Sold")
    else
        xPlayer.addMoney(price, "Sell Sold")
    end

    xPlayer.removeInventoryItem(xItem.name, amount)
    xPlayer.showNotification(TranslateCap("dealer_sold", amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

ESX.RegisterServerCallback("bpt_pointsell:canPickUp", function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.canCarryItem(item, 1))
end)
