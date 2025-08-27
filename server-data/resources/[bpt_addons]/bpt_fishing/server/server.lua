RegisterNetEvent("ox_fishing:giveFish", function(waterHeight)
    local src = source

    -- Check esca
    if exports.ox_inventory:Search(src, "count", Config.BaitItem) <= 0 then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_nobait"),
            type = "error",
        })
        return
    end

    -- Check canna
    if exports.ox_inventory:Search(src, "count", Config.RodItem) <= 0 then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_norod"),
            type = "error",
        })
        return
    end

    -- Consuma esca
    exports.ox_inventory:RemoveItem(src, Config.BaitItem, 1)

    -- Fix valore waterHeight
    local depth = tonumber(waterHeight) or 1.0
    local multiplier = 1.0
    for _, v in ipairs(Config.DepthChances) do
        if depth <= v.depth then
            multiplier = v.multiplier
            break
        end
    end

    -- Calcolo probabilità
    local roll = math.random(1, 100)
    local sum, selectedFish = 0, nil
    for _, fish in ipairs(Config.FishTypes) do
        local adjustedChance = math.floor(fish.chance * multiplier)
        sum = sum + adjustedChance
        if roll <= sum then
            selectedFish = fish
            break
        end
    end

    if selectedFish then
        exports.ox_inventory:AddItem(src, selectedFish.item, 1)
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_catch", selectedFish.label),
            type = "success",
        })
    else
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_fail"),
            type = "error",
        })
    end
end)
