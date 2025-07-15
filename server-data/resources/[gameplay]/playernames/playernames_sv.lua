local curTemplate = nil
local curTags = {}
local activePlayers = {}

--- Funzione principale per il rilevamento degli aggiornamenti
local function detectUpdates()
    SetTimeout(500, detectUpdates) -- Loop continuo ogni mezzo secondo

    -- Controlla se il template dei nomi lato client è cambiato
    local clientTemplate = GetConvar("playerNames_template", "[{{id}}] {{name}}")
    if curTemplate ~= clientTemplate then
        setNameTemplate(-1, clientTemplate) -- Aggiorna per tutti
        curTemplate = clientTemplate
    end

    -- Template lato server
    local serverTemplate = GetConvar("playerNames_svTemplate", "[{{id}}] {{name}}")

    -- Aggiorna i tag attivi
    for playerId in pairs(activePlayers) do
        local newTag = formatPlayerNameTag(playerId, serverTemplate)
        if newTag ~= curTags[playerId] then
            setName(playerId, newTag)
            curTags[playerId] = newTag
        end
    end

    -- Pulisce i tag dei player che non sono più attivi
    for playerId in pairs(curTags) do
        if not activePlayers[playerId] then
            curTags[playerId] = nil
        end
    end
end

--- Rimuove dati quando un giocatore lascia
AddEventHandler("playerDropped", function()
    local src = source
    curTags[src] = nil
    activePlayers[src] = nil
end)

--- Inizializza il nome per un nuovo giocatore
RegisterNetEvent("playernames:init", function()
    local src = source
    reconfigure(src) -- Presumibilmente applica la configurazione di visualizzazione
    activePlayers[src] = true
end)

-- Avvia il ciclo di aggiornamento
CreateThread(detectUpdates)
