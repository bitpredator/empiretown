local ESX = exports["es_extended"]:getSharedObject()
local MySQL = exports.oxmysql

local PLAY_TIME_LIMIT = 4 * 60 * 60 -- 4 ore
local ONE_WEEK_IN_SECONDS = 7 * 24 * 60 * 60

local playerLoginTimes = {}

-- Controllo inattività ogni ora
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000)

        MySQL:query("SELECT identifier, UNIX_TIMESTAMP(last_login) AS last_login, play_time FROM users WHERE identifier LIKE 'char%'", {}, function(result)
            if result and #result > 0 then
                local currentTime = os.time()

                for _, row in ipairs(result) do
                    local identifier = row.identifier
                    local lastLogin = tonumber(row.last_login)
                    local playTime = tonumber(row.play_time) or 0

                    if lastLogin then
                        local inactivityDuration = currentTime - lastLogin

                        if inactivityDuration >= ONE_WEEK_IN_SECONDS and playTime < PLAY_TIME_LIMIT then
                            print("^3[Rimozione lavoro] Il giocatore con identifier:", identifier, "non ha giocato abbastanza, viene impostato come disoccupato.^0")
                            MySQL:update("UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = ?", { identifier })
                        end
                    end
                end
            end
        end)
    end
end)

-- Quando un player entra, salviamo il tempo di accesso
AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    local identifier = xPlayer.identifier
    if not identifier then
        return
    end

    local now = os.time()
    playerLoginTimes[identifier] = now

    print("^2[Aggiornamento] last_login per:", identifier, os.date("%Y-%m-%d %H:%M:%S"))

    MySQL:update("UPDATE users SET last_login = NOW() WHERE identifier = ?", { identifier })
end)

-- Quando il player esce, aggiorniamo il tempo di gioco nel DB
AddEventHandler("playerDropped", function(reason)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return
    end

    local identifier = xPlayer.identifier
    if not identifier then
        return
    end

    local loginTime = playerLoginTimes[identifier]
    if not loginTime then
        return
    end

    local now = os.time()
    local sessionPlayTime = now - loginTime

    MySQL:query("SELECT play_time FROM users WHERE identifier = ?", { identifier }, function(result)
        if result and result[1] then
            local totalTime = (tonumber(result[1].play_time) or 0) + sessionPlayTime
            MySQL:update("UPDATE users SET play_time = ? WHERE identifier = ?", { totalTime, identifier })
            print("^2[PlayTime Aggiornato] " .. identifier .. " => " .. totalTime .. " secondi^0")
        end
    end)

    playerLoginTimes[identifier] = nil -- Pulisci la memoria
end)
