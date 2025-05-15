local mining = false

-- Inizializza i punti mining con ox_target
CreateThread(function()
    for i, spot in pairs(Config.MiningSpots) do
        exports.ox_target:addBoxZone({
            coords = spot.coords,
            size = vec3(2, 2, 2),
            rotation = spot.heading,
            debug = false,
            options = {
                {
                    name = 'mine_spot_' .. i,
                    icon = 'fas fa-hammer',
                    label = 'Scava con il martello pneumatico',
                    onSelect = function()
                        if not mining then
                            StartMining(spot.coords)
                        end
                    end
                }
            }
        })
    end
end)

-- Funzione mining
 function StartMining()
    local playerPed = PlayerPedId()
    mining = true

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CONST_DRILL", 0, true)
    FreezeEntityPosition(playerPed, true)

    Wait(8000)

    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    -- Pulizia
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    TriggerServerEvent("empire_miner:giveItems")
    mining = false
end

-- Blip in mappa
CreateThread(function()
    local blip = AddBlipForCoord(2950.5, 2796.3, 40.0)
    SetBlipSprite(blip, 318)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zona Mineraria")
    EndTextCommandSetBlipName(blip)
end)
