---@diagnostic disable: undefined-global
local registeredStashes = {}
local ox_inventory = exports.ox_inventory

-- Normalizza e controlla se un item è in whitelist (case-insensitive)
local function isWhitelisted(item)
    if not item then
        return false
    end
    local name = tostring(item):lower()
    for _, v in ipairs(Config.WalletWhitelist or {}) do
        if tostring(v):lower() == name then
            return true
        end
    end
    return false
end

-- Hook che intercetta gli spostamenti (swapItems)
ox_inventory:registerHook("swapItems", function(payload)
    -- payload.toInventory può essere string o table; normalizziamo l'id della destinazione
    local toInv = payload.toInventory
    local toInvId

    if type(toInv) == "string" then
        toInvId = toInv
    elseif type(toInv) == "table" and toInv.id then
        toInvId = tostring(toInv.id)
    end

    -- Se la destinazione è uno stash wallet che inizia con "wal_" allora controlliamo l'item
    if toInvId and toInvId:sub(1, 4) == "wal_" then
        local fromSlot = payload.fromSlot
        local itemName

        -- fromSlot dovrebbe essere una table con .name ma gestiamo anche altri casi difensivamente
        if type(fromSlot) == "table" and fromSlot.name then
            itemName = tostring(fromSlot.name)
        elseif type(fromSlot) == "string" then
            itemName = fromSlot
        elseif payload.itemName then
            itemName = tostring(payload.itemName)
        end

        -- se non siamo in grado di capire il nome, lasciamo procedere (evitiamo falsi positivi)
        if not itemName then
            return true
        end

        -- se non è in whitelist blocchiamo e notifichiamo
        if not isWhitelisted(itemName) then
            local src = payload.source
            -- Notifica al client tramite ox_lib (server -> client)
            TriggerClientEvent("ox_lib:notify", src, {
                type = "error",
                description = "Questo oggetto non può essere inserito nel portafogli!",
            })
            return false
        end
    end

    return true
end)

-- Generatore di testo casuale
local function GenerateText(num)
    local str
    repeat
        str = {}
        for i = 1, num do
            str[i] = string.char(math.random(65, 90))
        end
        str = table.concat(str)
    until str ~= "POL" and str ~= "EMS"
    return str
end

-- Generatore di serial
local function GenerateSerial(text)
    if text and text:len() > 3 then
        return text
    end
    return ("%s%s%s"):format(math.random(100000, 999999), text == nil and GenerateText(3) or text, math.random(100000, 999999))
end

-- Evento apertura wallet: registra lo stash se non registrato
RegisterServerEvent("bpt_wallet:openWallet")
AddEventHandler("bpt_wallet:openWallet", function(identifier)
    if not identifier then
        return
    end
    if not registeredStashes[identifier] then
        ox_inventory:RegisterStash("wal_" .. identifier, "Wallet", Config.WalletStorage.slots, Config.WalletStorage.weight, false)
        registeredStashes[identifier] = true
    end
end)

-- Callback per generare nuovo identificatore wallet
lib.callback.register("bpt_wallet:getNewIdentifier", function(source, slot)
    local newId = GenerateSerial()
    -- Imposta metadata sullo slot del player (inv = source)
    ox_inventory:SetMetadata(source, slot, { identifier = newId })
    -- Registra stash
    ox_inventory:RegisterStash("wal_" .. newId, "Wallet", Config.WalletStorage.slots, Config.WalletStorage.weight, false)
    registeredStashes[newId] = true
    return newId
end)
