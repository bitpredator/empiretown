local playersProcessingCannabis = {}
local outofbound = true
local alive = true

local function ValidatePickupCannabis(src)
    local ECoords = Config.CircleZones.WeedField.coords
    local PCoords = GetEntityCoords(GetPlayerPed(src))
    local Dist = #(PCoords - ECoords)
    if Dist <= 90 then
        return true
    end
end

local function ValidateProcessCannabis(src)
    local ECoords = Config.CircleZones.WeedProcessing.coords
    local PCoords = GetEntityCoords(GetPlayerPed(src))
    local Dist = #(PCoords - ECoords)
    if Dist <= 5 then
        return true
    end
end

local function FoundExploiter(src, reason)
    -- ADD YOUR BAN EVENT HERE UNTIL THEN IT WILL ONLY KICK THE PLAYER --
    DropPlayer(src, reason)
end

RegisterServerEvent("bpt_drugs:sellDrug")
AddEventHandler("bpt_drugs:sellDrug", function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.DrugDealerItems[itemName]
    local xItem = xPlayer.getInventoryItem(itemName)

    -- If this fails its 99% a mod-menu, the variables client sided are setup to provide the exact right arguments
    if type(amount) ~= "number" or type(itemName) ~= "string" then
        print(("bpt_drugs: %s attempted to sell with invalid input type!"):format(xPlayer.identifier))
        FoundExploiter(xPlayer.source, "SellDrugs Event Trigger")
        return
    end
    if not price then
        print(("bpt_drugs: %s attempted to sell an invalid drug!"):format(xPlayer.identifier))
        return
    end
    if amount < 0 then
        print(("bpt_drugs: %s attempted to sell an minus amount!"):format(xPlayer.identifier))
        return
    end
    if xItem == nil or xItem.count < amount then
        xPlayer.showNotification(TranslateCap("dealer_notenough"))
        return
    end

    price = ESX.Math.Round(price * amount)

    if Config.GiveBlack then
        xPlayer.addAccountMoney("black_money", price, "Drugs Sold")
    else
        xPlayer.addMoney(price, "Drugs Sold")
    end

    xPlayer.removeInventoryItem(xItem.name, amount)
    xPlayer.showNotification(TranslateCap("dealer_sold", amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

RegisterServerEvent("bpt_drugs:pickedUpCannabis")
AddEventHandler("bpt_drugs:pickedUpCannabis", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local cime = math.random(5, 10)
    if ValidatePickupCannabis(src) then
        if xPlayer.canCarryItem("cannabis", cime) then
            xPlayer.addInventoryItem("cannabis", cime)
        else
            xPlayer.showNotification(TranslateCap("weed_inventoryfull"))
        end
    else
        FoundExploiter(src, "Event Trigger")
    end
end)

ESX.RegisterServerCallback("bpt_drugs:canPickUp", function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.canCarryItem(item, 1))
end)

RegisterServerEvent("bpt_drugs:outofbound")
AddEventHandler("bpt_drugs:outofbound", function()
    outofbound = true
end)

ESX.RegisterServerCallback("bpt_drugs:cannabis_count", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xCannabis = xPlayer.getInventoryItem("cannabis").count
    cb(xCannabis)
end)

RegisterServerEvent("bpt_drugs:processCannabis")
AddEventHandler("bpt_drugs:processCannabis", function()
    if not playersProcessingCannabis[source] then
        local source = source
        if ValidateProcessCannabis(source) then
            local xPlayer = ESX.GetPlayerFromId(source)
            local xCannabis = xPlayer.getInventoryItem("cannabis")
            if xCannabis.count >= 3 then
            else
                xPlayer.showNotification(TranslateCap("weed_processingenough"))
                TriggerEvent("bpt_drugs:cancelProcessing")
            end
        else
            FoundExploiter(source, "Event Trigger")
        end
    else
        print(("bpt_drugs: %s attempted to exploit weed processing!"):format(GetPlayerIdentifiers(source)[1]))
    end
end)

function CancelProcessing(playerId)
    if playersProcessingCannabis[playerId] then
        ESX.ClearTimeout(playersProcessingCannabis[playerId])
        playersProcessingCannabis[playerId] = nil
    end
end

RegisterServerEvent("bpt_drugs:cancelProcessing")
AddEventHandler("bpt_drugs:cancelProcessing", function()
    CancelProcessing(source)
end)

AddEventHandler("esx:playerDropped", function(playerId, reason)
    CancelProcessing(playerId)
end)

RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
    CancelProcessing(source)
end)
