local fishing = false

-- Controlla acqua
local function IsPlayerNearWater()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local hit, waterHeight = TestProbeAgainstWater(coords.x, coords.y, coords.z + 1.0, coords.x, coords.y, coords.z - 5.0)

    if hit then
        return true, waterHeight or coords.z
    else
        return false, coords.z
    end
end

-- Avvio pesca
local function StartFishing()
    if fishing then
        return
    end
    local ped = PlayerPedId()

    -- Check acqua
    local nearWater, waterHeight = IsPlayerNearWater()
    if not nearWater then
        lib.notify({ title = "Pesca", description = TranslateCap("fishing_nowater"), type = "error" })
        return
    end

    -- Check canna
    if exports.ox_inventory:Search("count", Config.RodItem) <= 0 then
        lib.notify({ title = "Pesca", description = TranslateCap("fishing_norod"), type = "error" })
        return
    end

    fishing = true
    lib.notify({ title = "Pesca", description = TranslateCap("fishing_start"), type = "inform" })

    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)

    local waitTime = math.random(Config.MinWait, Config.MaxWait)
    SetTimeout(waitTime, function()
        if fishing then
            ClearPedTasks(ped)
            fishing = false

            -- Skill check
            local success = lib.skillCheck({ "easy", "easy", "easy" })
            if success then
                TriggerServerEvent("ox_fishing:giveFish", waterHeight)
            else
                lib.notify({ title = "Pesca", description = TranslateCap("fishing_fail"), type = "error" })
            end
        end
    end)
end

-- Inizializza i target zone
CreateThread(function()
    for _, zone in pairs(Config.FishingZones) do
        exports.ox_target:addSphereZone({
            coords = zone.coords,
            radius = zone.radius,
            debug = false,
            options = {
                {
                    name = "fishing:" .. zone.name,
                    label = TranslateCap("fishing_start"),
                    icon = "fas fa-fish",
                    onSelect = function()
                        StartFishing()
                    end,
                },
            },
        })
    end
end)

-- Aggiunta blip pesca
CreateThread(function()
    for _, zone in pairs(Config.FishingZones) do
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, 68) -- 🐟 icona pesce
        SetBlipScale(blip, 0.8) -- dimensione
        SetBlipColour(blip, 3) -- blu
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona di pesca")
        EndTextCommandSetBlipName(blip)
    end
end)
