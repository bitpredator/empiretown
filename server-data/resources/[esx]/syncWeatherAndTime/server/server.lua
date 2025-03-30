local weatherTypes = { "CLEAR", "CLOUDS", "FOGGY", "RAIN", "THUNDER", "XMAS" }
local currentWeather = "CLEAR"

-- The weather changes every hour
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000) -- 1 real hour

        if math.random(1, 100) <= 30 then
            currentWeather = "RAIN"
        elseif math.random(1, 100) <= 10 then
            currentWeather = "THUNDER"
        elseif math.random(1, 100) <= 15 then
            currentWeather = "FOGGY"
        else
            currentWeather = weatherTypes[math.random(1, #weatherTypes)]
        end

        TriggerClientEvent("syncWeatherAndTimeClient", -1, currentWeather)
    end
end)

-- Sync weather with new players
RegisterNetEvent("syncWeatherAndTimeServer")
AddEventHandler("syncWeatherAndTimeServer", function()
    local src = source
    TriggerClientEvent("syncWeatherAndTimeClient", src, currentWeather)
end)
