ESX = exports["es_extended"]:getSharedObject()

local function notify(msg)
    ESX.ShowNotification(msg)
end

-- Calcola zona d'acqua
local function getWaterLevelType()
    local coords = GetEntityCoords(PlayerPedId())
    local foundWater, waterHeight = GetWaterHeight(coords.x, coords.y, coords.z)
    if not foundWater then
        return "low"
    end
    if waterHeight > 5.0 then
        return "high"
    elseif waterHeight > 1.5 then
        return "medium"
    else
        return "low"
    end
end

-- Registra i punti pesca con ox_target
CreateThread(function()
    for i, zone in ipairs(Config.FishingZones) do
        exports.ox_target:addBoxZone({
            coords = zone.coords,
            size = vec3(2, 2, 2),
            rotation = 0.0,
            debug = false,
            options = {
                {
                    label = TranslateCap(zone.name), -- Traduzione dinamica
                    icon = zone.icon or "fa-solid fa-fish",
                    onSelect = function()
                        TriggerEvent("fishing:start")
                    end,
                },
            },
        })
    end
end)

-- Evento pesca
RegisterNetEvent("fishing:start", function()
    ESX.TriggerServerCallback("fishing:canFish", function(canFish, msg)
        if not canFish then
            notify(msg)
            return
        end

        notify(TranslateCap("start_fishing"))
        TaskStartScenarioInPlace(PlayerPedId(), "world_human_stand_fishing", 0, true)

        Wait(8000)
        ClearPedTasks(PlayerPedId())

        local zone = getWaterLevelType()
        TriggerServerEvent("fishing:rewardFish", zone)
    end)
end)

-- Crea i blip sulla mappa per ogni zona di pesca
CreateThread(function()
    for i, zone in ipairs(Config.FishingZones) do
        local blip = AddBlipForCoord(zone.coords)
        SetBlipSprite(blip, 68) -- Icona del blip (68 = pesce)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3) -- Colore verde acqua
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U(zone.name)) -- Usa la traduzione
        EndTextCommandSetBlipName(blip)
    end
end)
