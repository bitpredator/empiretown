local snowAltitudeThreshold = 300.0 -- Height in meters above which snow is permanent
local lastWeather = "CLEAR"

-- Function to change the weather slowly
function ChangeWeather(weather)
    lastWeather = weather
    SetWeatherTypeOvertimePersist(weather, 600.0)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)

    -- Applying special effects
    if weather == "RAIN" or weather == "THUNDER" then
        SetRainFxIntensity(1.0)
        StartAudioScene("RAIN_SCENE")
        TriggerEvent("weatherEffects:startThunder")
    elseif weather == "XMAS" then
        SetWeatherTypeNow("XMAS")
    elseif weather == "FOGGY" then
        SetOverrideWeather("FOGGY")
    else
        SetOverrideWeather("CLEAR")
        SetWeatherTypeNowPersist("CLEAR")
    end
end

-- Check and apply snow in the mountains
function CheckAndApplyMountainWeather()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local altitude = playerCoords.z

    if altitude > snowAltitudeThreshold then
        SetWeatherTypeNow("XMAS")
    end
end

-- Get weather from server
RegisterNetEvent("syncWeatherAndTimeClient")
AddEventHandler("syncWeatherAndTimeClient", function(weather)
    ChangeWeather(weather)
    CheckAndApplyMountainWeather()
end)

-- Sync the weather every minute
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        TriggerServerEvent("syncWeatherAndTimeServer")
    end
end)

-- Random lightning effect
RegisterNetEvent("weatherEffects:startThunder")
AddEventHandler("weatherEffects:startThunder", function()
    Citizen.CreateThread(function()
        while lastWeather == "THUNDER" do
            Citizen.Wait(math.random(30000, 60000))
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            ForceLightningFlashAtCoords(coords.x + math.random(-100, 100), coords.y + math.random(-100, 100), coords.z + 10.0)
        end
    end)
end)
