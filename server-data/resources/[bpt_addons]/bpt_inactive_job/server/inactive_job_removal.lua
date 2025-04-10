local ESX = exports["es_extended"]:getSharedObject()
local MySQL = exports["oxmysql"]

if not ESX then
    print("^1[Errore] ESX non è stato inizializzato correttamente.^0")
end

if not MySQL then
    print("^1[Errore] oxmysql non è stato inizializzato correttamente.^0")
end

local PLAY_TIME_LIMIT = 4 * 60 * 60 -- 4 ore in secondi
local ONE_WEEK_IN_SECONDS = 7 * 24 * 60 * 60 -- 7 giorni in secondi

-- Controllo inattività ogni ora
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000) -- 1 ora

        if not ESX then
            print("^1[Errore] ESX non disponibile, salto controllo inattività.^0")
            return
        end

        MySQL.query("SELECT identifier, UNIX_TIMESTAMP(last_login) AS last_login, play_time FROM users WHERE identifier LIKE 'char%'", {}, function(result)
            if result and #result > 0 then
                local currentTime = os.time()

                for _, row in ipairs(result) do
                    local identifier = row.identifier
                    local lastLogin = tonumber(row.last_login)
                    local playTime = tonumber(row.play_time) or 0 -- Tempo di gioco accumulato in secondi

                    if lastLogin then
                        local inactivityDuration = currentTime - lastLogin

                        -- Se il giocatore non ha accumulato almeno 4 ore di gioco in una settimana
                        if inactivityDuration >= ONE_WEEK_IN_SECONDS and playTime < PLAY_TIME_LIMIT then
                            print("^3[Rimozione lavoro] Il giocatore con identifier:", identifier, "non ha giocato abbastanza, viene impostato come disoccupato.^0")

                            MySQL.update("UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = ?", { identifier })
                        end
                    end
                end
            else
                print("^3[Nessun risultato] Nessun giocatore trovato nel database.^0")
            end
        end)
    end
end)

-- Aggiornamento della data di accesso e del tempo di gioco
AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    if not MySQL then
        print("^1[Errore] MySQL non disponibile, non posso aggiornare last_login e play_time.^0")
        return
    end

    local identifier = xPlayer.identifier
    if not identifier or identifier == "" then
        print("^1[Errore] Identifier non valido per il giocatore.^0")
        return
    end

    print("^2[Aggiornamento] last_login per:", identifier, os.date("%Y-%m-%d %H:%M:%S"))

    -- Aggiornamento della data di ultimo accesso
    MySQL.update("UPDATE users SET last_login = NOW() WHERE identifier = ?", { identifier })

    -- Aggiungi il tempo di gioco accumulato
    local currentTime = os.time()
    local playTime = xPlayer.get("play_time") or 0
    local elapsedTime = currentTime - xPlayer.get("last_login_time")

    -- Incrementa il tempo di gioco
    playTime = playTime + elapsedTime
    xPlayer.set("play_time", playTime)

    -- Aggiornamento del tempo di gioco nel database
    MySQL.update("UPDATE users SET play_time = ? WHERE identifier = ?", { playTime, identifier })
end)
