Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local playerHealth = GetEntityHealth(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local playerId = GetPlayerServerId(PlayerId())

        if playerHealth > Config.MaxHealth then
            TriggerServerEvent('anticheat:checkAdmin', playerId, 'Health Hacking')
        end

        if vehicle ~= 0 then
            local vehicleModel = GetEntityModel(vehicle)
            for _, blacklistedVehicle in ipairs(VehicleBlacklist) do
                if vehicleModel == GetHashKey(blacklistedVehicle) then
                    DeleteEntity(vehicle)
                    TriggerServerEvent('anticheat:banPlayer', 'Using Blacklisted Vehicle')
                    break
                end
            end
        end
    end
end)