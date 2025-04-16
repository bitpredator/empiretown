local SecondsUntilKick = 600 -- Tempo in secondi prima del kick
local KickWarningTime = math.ceil(SecondsUntilKick / 4) -- Momento dell'avviso
local TimeLeft = SecondsUntilKick
local PrevPos = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Controllo ogni secondo

        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) then
            local currentPos = GetEntityCoords(playerPed, true)

            if PrevPos and #(currentPos - PrevPos) < 0.1 then
                -- Il giocatore è fermo
                if TimeLeft > 0 then
                    if TimeLeft == KickWarningTime then
                        TriggerEvent("chatMessage", "⚠️ ATTENZIONE", {255, 0, 0}, "^1Verrai espulso per inattività tra " .. TimeLeft .. " secondi!")
                    end

                    TimeLeft = TimeLeft - 1
                else
                    TriggerServerEvent("es_extended:kickAFK") -- Assicurati di gestire questo evento lato server
                end
            else
                -- Il giocatore si è mosso, resettiamo il timer
                TimeLeft = SecondsUntilKick
            end

            PrevPos = currentPos
        end
    end
end)
