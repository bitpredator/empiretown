local speedLimit = 60.0 -- Velocità limite in mph
local fineAmount = 200.0 -- Importo della multa

local speedCameras = {
    { x = 264.356049, y = -618.171448, z = 42.254272 }, -- Autovelox Ospedale
}

local showBar = false -- Variabile per mostrare/nascondere la barra di avviso

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()

        -- Verifica se il giocatore è in un veicolo
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 2.23694 -- Convertiamo da m/s a mph

            -- Verifica se il veicolo è in movimento
            if speed > 0.5 then
                showBar = false -- Resettiamo lo stato della barra

                for _, camera in ipairs(speedCameras) do
                    local playerPos = GetEntityCoords(playerPed)
                    local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, camera.x, camera.y, camera.z)

                    -- Se il giocatore è vicino all'autovelox (distanza inferiore a 50 metri)
                    if distance < 50.0 then
                        -- Mostriamo la barra visiva
                        showBar = true

                        if speed > speedLimit then
                            -- Aggiungi un print per verificare che l'evento venga inviato
                            print("Multa: Velocità superiore al limite, invio multa al server")
                            local playerId = GetPlayerServerId(PlayerId())
                            local playerName = GetPlayerName(PlayerId())
                            TriggerServerEvent("autovelox:recordFine", playerId, playerName, fineAmount, "Superato il limite di velocità", "Posizione: " .. playerPos.x .. ", " .. playerPos.y .. ", " .. playerPos.z)
                        end
                    end
                end
            end
        end
    end
end)

-- Funzione per disegnare la barra di avviso
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if showBar then
            -- Impostiamo la barra come rossa se il giocatore sta andando troppo veloce
            DrawRect(0.5, 0.05, 1.0, 0.05, 255, 0, 0, 255) -- Barra rossa per avviso
            SetTextFont(0)
            SetTextProportional(true)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString("🚨 Autovelox nelle vicinanze! 🚨")
            DrawText(0.5 - 0.2, 0.05 - 0.015)
        end
    end
end)
