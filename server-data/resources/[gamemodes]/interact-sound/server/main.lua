--========================================================--
-- Interaction Sounds by Scott (Improved)
-- Version: v0.0.2
-- File: server/main.lua
--
-- Enables server to trigger 3D and 2D sounds on specific
-- players, all players, or those within a defined radius.
--========================================================--

local MAX_SOUND_DISTANCE = 300.0

-- Utilità per validare input e prevenire abusi
local function isValidVolume(volume)
    return type(volume) == "number" and volume >= 0.1 and volume <= 1.0
end

-- Play sound only on a specific client (by Net ID)
RegisterNetEvent("InteractSound_SV:PlayOnOne", function(clientNetId, soundFile, soundVolume)
    if clientNetId and soundFile then
        TriggerClientEvent("InteractSound_CL:PlayOnOne", clientNetId, soundFile, soundVolume or 0.5)
    end
end)

-- Play sound on the source (sender) of the event
RegisterNetEvent("InteractSound_SV:PlayOnSource", function(soundFile, soundVolume)
    local src = source
    if soundFile then
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, soundFile, soundVolume or 0.5)
    end
end)

-- Play sound on all connected clients
RegisterNetEvent("InteractSound_SV:PlayOnAll", function(soundFile, soundVolume)
    if soundFile then
        TriggerClientEvent("InteractSound_CL:PlayOnAll", -1, soundFile, soundVolume or 0.5)
    end
end)

-- Play sound only on clients within a specified radius
RegisterNetEvent("InteractSound_SV:PlayWithinDistance", function(maxDistance, soundFile, soundVolume)
    local src = source
    if not soundFile then
        return
    end

    if type(maxDistance) ~= "number" or maxDistance <= 0 then
        print(("[InteractSound] Invalid maxDistance from %s"):format(GetPlayerName(src)))
        return
    end

    if maxDistance > MAX_SOUND_DISTANCE then
        print(("[InteractSound] [^3WARNING^7] %s attempted to use a distance > %s"):format(GetPlayerName(src), MAX_SOUND_DISTANCE))
        return
    end

    local coords = GetEntityCoords(GetPlayerPed(src))
    if GetConvar("onesync_enableInfinity", "false") == "true" then
        TriggerClientEvent("InteractSound_CL:PlayWithinDistanceOS", -1, coords, maxDistance, soundFile, soundVolume or 0.5)
    else
        TriggerClientEvent("InteractSound_CL:PlayWithinDistance", -1, coords, maxDistance, soundFile, soundVolume or 0.5)
    end
end)
