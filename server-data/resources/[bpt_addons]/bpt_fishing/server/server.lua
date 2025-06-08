ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("fishing:canFish", function(source, cb)
    local hasRod = exports.ox_inventory:Search(source, "count", Config.RequiredItems.Rod) > 0
    local hasBait = exports.ox_inventory:Search(source, "count", Config.RequiredItems.Bait) > 0

    if not hasRod then
        cb(false, TranslateCap("no_rod"))
        return
    elseif not hasBait then
        cb(false, TranslateCap("no_bait"))
        return
    end

    cb(true)
end)

RegisterNetEvent("fishing:rewardFish", function(zone)
    local src = source
    exports.ox_inventory:RemoveItem(src, Config.RequiredItems.Bait, 1)

    local factor = Config.WaterZones[zone] or 1.0
    local totalChance = math.random(1, 100)

    local accumulated = 0
    for _, fish in ipairs(Config.FishList) do
        accumulated = accumulated + (fish.chance * factor)
        if totalChance <= accumulated then
            exports.ox_inventory:AddItem(src, fish.name, 1)
            TriggerClientEvent("esx:showNotification", src, TranslateCap("got_fish", fish.name))
            return
        end
    end

    exports.ox_inventory:AddItem(src, "plastic_bag", 1)
    TriggerClientEvent("esx:showNotification", src, TranslateCap("got_trash"))
end)
