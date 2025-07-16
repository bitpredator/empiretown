local ids = {}

-- Funzione factory per creare le funzioni di trigger per client/server
local function createTriggerFunction(key)
    return function(playerId, ...)
        if not IsDuplicityVersion() then
            -- Lato client
            TriggerEvent("playernames:configure", GetPlayerServerId(playerId), key, ...)
        else
            -- Lato server: salva e propaga ai client
            ids[playerId] = ids[playerId] or {}
            ids[playerId][key] = table.pack(...)
            TriggerClientEvent("playernames:configure", -1, playerId, key, ...)
        end
    end
end

-- Solo lato server
if IsDuplicityVersion() then
    function reconfigure(targetSource)
        for id, config in pairs(ids) do
            for key, args in pairs(config) do
                TriggerClientEvent("playernames:configure", targetSource, id, key, table.unpack(args))
            end
        end
    end

    AddEventHandler("playerDropped", function()
        ids[source] = nil
    end)
end

-- Exported setter functions
setComponentColor = createTriggerFunction("setc")
setComponentAlpha = createTriggerFunction("seta")
setComponentVisibility = createTriggerFunction("tglc")
setWantedLevel = createTriggerFunction("setw")
setHealthBarColor = createTriggerFunction("sehc")
setNameTemplate = createTriggerFunction("tpl")
setName = createTriggerFunction("name")

-- Prepara il template renderer
local template = load(LoadResourceFile(GetCurrentResourceName(), "template/template.lua"))()

-- Funzione per formattare il nome visualizzato
function formatPlayerNameTag(playerIndex, templateStr)
    local tagString = ""

    -- Sovrascrive print temporaneamente per accumulare l'output del template
    template.print = function(txt)
        tagString = tagString .. txt
    end

    -- Prepara il contesto per il rendering
    local context = {
        name = GetPlayerName(playerIndex),
        i = playerIndex,
        global = _G,
        id = IsDuplicityVersion() and playerIndex or GetPlayerServerId(playerIndex),
    }

    -- Estende dinamicamente il contesto
    TriggerEvent("playernames:extendContext", playerIndex, function(key, value)
        context[key] = value
    end)

    -- Esegue il rendering
    template.render(templateStr, context, nil, true)

    -- Ripristina print originale
    template.print = print

    return tagString
end
