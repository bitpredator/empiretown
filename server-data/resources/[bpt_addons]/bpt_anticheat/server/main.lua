ESX = exports["es_extended"]:getSharedObject()

local json = json or require("json")

-- Funzione per ottenere la lista dei file JSON nella cartella specificata
local function getJSONFiles(directory)
    local files = {}
    local resourceName = GetCurrentResourceName()
    local metadataCount = GetNumResourceMetadata(resourceName, "files") or 0

    for i = 0, metadataCount - 1 do
        local filePath = GetResourceMetadata(resourceName, "files", i)
        if filePath and string.match(filePath, directory .. "/.+%.json") then
            table.insert(files, filePath)
        end
    end

    return files
end

-- Funzione per caricare tutti i file JSON da una cartella
local function loadJSONFiles(directory)
    local data = {}
    local files = getJSONFiles(directory)

    for _, file in ipairs(files) do
        local rawData = LoadResourceFile(GetCurrentResourceName(), file)
        if rawData then
            local decodedData = json.decode(rawData)
            if decodedData then
                data[file] = decodedData
            else
                print("^1[ERROR] Errore di parsing nel file JSON: " .. file .. "^0")
            end
        else
            print("^1[ERROR] Impossibile leggere il file: " .. file .. "^0")
        end
    end

    return data
end

-- Carica tutte le blacklist
local blacklists = loadJSONFiles("server/blacklist")
local blacklistedWeapons = blacklists["server/blacklist/weapons.json"] or {}
local blacklistedVehicles = blacklists["server/blacklist/vehicles.json"] or {}
local blacklistedTriggers = blacklists["server/blacklist/blacklist_triggers.json"] or {}

-- Evento per bannare un giocatore
RegisterServerEvent('anticheat:banPlayer')
AddEventHandler('anticheat:banPlayer', function(reason, details)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local identifier = xPlayer.identifier
        local discord_id = "N/A"
        local discord_name = GetPlayerName(_source) or "Sconosciuto"
        local playerIP = GetPlayerEndpoint(_source) or "N/A"

        -- Recupera il Discord ID
        for _, id in ipairs(GetPlayerIdentifiers(_source)) do
            if string.match(id, "discord:") then
                discord_id = string.sub(id, 9)
            end
        end

        local full_reason = details and (reason .. " - " .. details) or reason

        -- Salva nel database
        MySQL.Async.execute('INSERT INTO banned_players (identifier, discord_id, discord_name, ip, reason, timestamp) VALUES (@identifier, @discord_id, @discord_name, @ip, @reason, @timestamp)', {
            ['@identifier'] = identifier,
            ['@discord_id'] = discord_id,
            ['@discord_name'] = discord_name,
            ['@ip'] = playerIP,
            ['@reason'] = full_reason,
            ['@timestamp'] = os.time()
        }, function(rowsChanged)
            print(('Giocatore %s (Discord: %s, IP: %s) bannato per %s'):format(identifier, discord_id, playerIP, full_reason))

            -- Manda la notifica su Discord
            SendBanLogToDiscord(identifier, discord_id, discord_name, playerIP, full_reason)

            -- Disconnette il giocatore
            DropPlayer(_source, 'Sei stato bannato per ' .. full_reason)
        end)
    end
end)

-- Controlla se un giocatore ha un'arma vietata
function CheckBlacklistedWeapons(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        for _, weapon in ipairs(blacklistedWeapons) do
            if xPlayer.hasWeapon(weapon) then
                TriggerEvent('anticheat:banPlayer', 'Possesso di arma vietata', weapon)
                return
            end
        end
    end
end

-- Controlla se un giocatore usa un veicolo vietato
function CheckBlacklistedVehicles(playerId, vehicle)
    for _, blacklistedVehicle in ipairs(blacklistedVehicles) do
        if vehicle == blacklistedVehicle then
            TriggerEvent('anticheat:banPlayer', 'Utilizzo di veicolo vietato', vehicle)
            return
        end
    end
end

-- Controlla gli eventi vietati
for _, trigger in ipairs(blacklistedTriggers) do
    RegisterServerEvent(trigger)
    AddEventHandler(trigger, function()
        local _source = source
        TriggerEvent('anticheat:banPlayer', 'Trigger vietato eseguito', trigger)
    end)
end

-- Controlla le armi dopo il respawn
AddEventHandler('playerSpawned', function()
    local _source = source
    CheckBlacklistedWeapons(_source)
end)

-- Controlla il veicolo spawnato
RegisterServerEvent('anticheat:checkVehicle')
AddEventHandler('anticheat:checkVehicle', function(vehicle)
    local _source = source
    CheckBlacklistedVehicles(_source, vehicle)
end)

-- Controllo flyhack/invisibilità (richiesta lato client)
RegisterServerEvent('anticheat:checkAdmin')
AddEventHandler('anticheat:checkAdmin', function(playerId, motivo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    -- Controllo se il giocatore è admin
    if xPlayer.getGroup and xPlayer.getGroup() ~= "user" then
        print(('[AntiCheat] %s ha attivato un rilevamento (%s) ma è admin, ignorato.'):format(GetPlayerName(_source), motivo))
        return
    end

    -- Se non è admin → ban
    TriggerEvent('anticheat:banPlayer', motivo, "Rilevato dal sistema automatico")
end)


-- Invia il log di ban su Discord
function SendBanLogToDiscord(identifier, discord_id, discord_name, playerIP, reason)
    local webhook = "https://discord.com/api/webhooks"

    local embed = {
        {
            ["title"] = "🛑 Giocatore Bannato 🛑",
            ["color"] = 16711680, -- Rosso
            ["fields"] = {
                { ["name"] = "🔹 Identifier", ["value"] = identifier, ["inline"] = false },
                { ["name"] = "💻 Discord Name", ["value"] = discord_name, ["inline"] = true },
                { ["name"] = "🆔 Discord ID", ["value"] = discord_id, ["inline"] = true },
                { ["name"] = "🌍 IP", ["value"] = playerIP, ["inline"] = true },
                { ["name"] = "📌 Motivo", ["value"] = reason, ["inline"] = false },
                { ["name"] = "⏳ Data", ["value"] = os.date('%Y-%m-%d %H:%M:%S', os.time()), ["inline"] = false }
            },
            ["footer"] = {
                ["text"] = "Sistema Anticheat",
                ["icon_url"] = "https://i.imgur.com/zpEkiYV.png"
            }
        }
    }

    -- Invia il log al webhook di Discord
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "AntiCheat Log", embeds = embed}), { ['Content-Type'] = 'application/json' })
end
