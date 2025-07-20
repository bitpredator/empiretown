-- InteractionSound by Scott - Improved Version
-- Description: Play sounds locally, globally, or within a distance on clients.

local standardVolumeOutput = 0.3
local hasPlayerLoaded = false

CreateThread(function()
    Wait(15000)
    hasPlayerLoaded = true
end)

--- Utility: Clamp volume to 0.1 - 1.0
local function sanitizeVolume(vol)
    vol = tonumber(vol) or standardVolumeOutput
    return math.max(0.1, math.min(1.0, vol))
end

-- Play sound only on local client
RegisterNetEvent("InteractSound_CL:PlayOnOne", function(soundFile, soundVolume)
    if not hasPlayerLoaded then return end

    SendNUIMessage({
        transactionType = "playSound",
        transactionFile = soundFile,
        transactionVolume = sanitizeVolume(soundVolume),
    })
end)

-- Play sound on all clients
RegisterNetEvent("InteractSound_CL:PlayOnAll", function(soundFile, soundVolume)
    if not hasPlayerLoaded then return end

    SendNUIMessage({
        transactionType = "playSound",
        transactionFile = soundFile,
        transactionVolume = sanitizeVolume(soundVolume),
    })
end)

-- Play sound only if within specified distance
RegisterNetEvent("InteractSound_CL:PlayWithinDistance", function(originCoords, maxDistance, soundFile, soundVolume)
    if not hasPlayerLoaded then return end

    local myCoords = GetEntityCoords(PlayerPedId())
    local distance = #(myCoords - originCoords)

    if distance < maxDistance then
        SendNUIMessage({
            transactionType = "playSound",
            transactionFile = soundFile,
            transactionVolume = sanitizeVolume(soundVolume),
        })
    end
end)
