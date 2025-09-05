---@diagnostic disable: undefined-global

-- 🔧 Funzione per "clampare" la durabilità
local function clampDurability(val)
    if type(val) ~= "number" then
        return Config.RodMaxDurability
    end
    if val < 0 then
        return 0
    end
    if val > Config.RodMaxDurability then
        return Config.RodMaxDurability
    end
    return math.floor(val)
end

-- 🔧 Recupera la canna del player con metadata normalizzato
local function getRodEntry(src)
    local rods = exports.ox_inventory:Search(src, "slots", Config.RodItem)
    if not rods or #rods == 0 then
        return nil
    end

    local rod = rods[1]
    rod.metadata = rod.metadata or {}

    local current = clampDurability(tonumber(rod.metadata.durability) or Config.RodMaxDurability)
    if not rod.metadata.durability or rod.metadata.durability ~= current then
        rod.metadata.durability = current
        exports.ox_inventory:SetMetadata(src, rod.slot, rod.metadata)
    end

    return rod
end

-- 🎣 Evento principale
RegisterNetEvent("ox_fishing:giveFish", function(waterHeight)
    local src = source

    -- 🪱 Controllo esca
    if exports.ox_inventory:Search(src, "count", Config.BaitItem) <= 0 then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_nobait"),
            type = "error",
        })
        return
    end

    -- 🎣 Controllo canna
    local rod = getRodEntry(src)
    if not rod then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("fishing_norod"),
            type = "error",
        })
        return
    end

    -- Consuma esca
    exports.ox_inventory:RemoveItem(src, Config.BaitItem, 1)

    -- 🔧 Aggiorna durabilità
    local current = clampDurability(tonumber(rod.metadata.durability) or Config.RodMaxDurability)
    local newDur = clampDurability(current - (Config.RodDegradePerCatch or 1))

    if newDur <= 0 then
        exports.ox_inventory:RemoveItem(src, Config.RodItem, 1, nil, rod.slot) -- canna rotta
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("rod_broken"),
            type = "error",
        })
        return
    else
        rod.metadata.durability = newDur
        exports.ox_inventory:SetMetadata(src, rod.slot, rod.metadata)

        TriggerClientEvent("ox_lib:notify", src, {
            title = "Pesca",
            description = TranslateCap("rod_durability", newDur, Config.RodMaxDurability),
            type = "inform",
        })
    end

    -- 🌊 Profondità acqua
    local depth = tonumber(waterHeight) or 1.0
    local multiplier = 1.0
    for _, v in ipairs(Config.DepthChances) do
        if depth <= v.depth then
            multiplier = v.multiplier
            break
        end
    end

    -- 🎲 Calcolo probabilità pesce
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

    -- 🐟 Aggiungi pesce o errore
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
