local flyDetectionCounter = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local playerHealth = GetEntityHealth(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local playerId = GetPlayerServerId(PlayerId())

        -- HEALTH HACK DETECTION
        if playerHealth > Config.MaxHealth then
            TriggerServerEvent('anticheat:checkAdmin', playerId, 'Health Hacking')
        end

        -- BLACKLISTED VEHICLES
        if vehicle ~= 0 and VehicleBlacklist then
            local vehicleModel = GetEntityModel(vehicle)
            for _, blacklistedVehicle in ipairs(VehicleBlacklist or {}) do
                if vehicleModel == GetHashKey(blacklistedVehicle) then
                    DeleteEntity(vehicle)
                    TriggerServerEvent('anticheat:banPlayer', 'Using Blacklisted Vehicle')
                    break
                end
            end
        end

        -- FLY / NOCLIP DETECTION
        if not IsPedInAnyVehicle(playerPed, false)
        and not IsPedFalling(playerPed)
        and not IsPedRagdoll(playerPed)
        and not IsPedClimbing(playerPed)
        and not IsPedSwimming(playerPed)
        and not IsPedInParachuteFreeFall(playerPed)
        and not IsPedJumpingOutOfVehicle(playerPed) then

            local isInAir = not IsPedOnGround(playerPed)
            if isInAir then
                flyDetectionCounter = flyDetectionCounter + 1
                if flyDetectionCounter > 5 then
                    TriggerServerEvent('anticheat:checkAdmin', playerId, 'Fly/NoClip Detection')
                    flyDetectionCounter = 0
                end
            else
                flyDetectionCounter = 0
            end
        end

        -- INVISIBILITY DETECTION
        if not IsEntityVisible(playerPed) and not IsPlayerAceAllowed(PlayerId(), "anticheat.bypass") then
            TriggerServerEvent('anticheat:checkAdmin', playerId, 'Invisibility Detected')
        end
    end
end)
