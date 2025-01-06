-- AFK Kick Time Limit (in seconds)
SecondsUntilKick = 600
KickWarning = true
local PlayerPed, PrevPos, CurrentPos  = nil, nil, nil
local Time = SecondsUntilKick

Citizen.CreateThread(function()
    while true do
        Wait(1000)

        PlayerPed = GetPlayerPed(-1)
        if PlayerPed then
            CurrentPos = GetEntityCoords(PlayerPed, true)

            if CurrentPos == PrevPos then
                if Time > 0 then
                    if KickWarning and Time == math.ceil(SecondsUntilKick / 4) then
                        TriggerEvent("chatMessage", "ATTENZIONE", { 255, 0, 0 }, "^1📐Sarai Espulso per inattività 'tra  " .. Time .. " secondi📐")
                    end

                    Time = Time - 1
                else
                    TriggerServerEvent("bpt_afk")
                end
            else
                Time = SecondsUntilKick
            end

            PrevPos = CurrentPos
        end
    end
end)
