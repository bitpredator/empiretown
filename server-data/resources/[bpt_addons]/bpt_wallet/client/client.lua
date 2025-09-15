---@diagnostic disable: undefined-global
local WalEquipped, walObj
local ox_inventory = exports.ox_inventory
local justConnect = true

local function RemoveWal()
    if walObj and DoesEntityExist(walObj) then
        DeleteObject(walObj)
    end
    walObj = nil
    WalEquipped = nil
end

-- Quando l'inventario cambia, controlliamo se il player possiede ancora l'item wallet
AddEventHandler("ox_inventory:updateInventory", function(changes)
    if justConnect then
        Wait(4500)
        justConnect = nil
    end

    -- Controllo semplice: conta quanti wallet ha il giocatore
    local count = ox_inventory:Search("count", Config.WalletItem)
    if type(count) ~= "number" then
        count = 0
    end

    if count < 1 and WalEquipped then
        RemoveWal()
    end
end)

-- Exportabile: apre il wallet. Usa metadata.identifier se già presente, altrimenti chiede al server di generarne uno
exports("openWallet", function(data, slot)
    -- Controllo sicuro sulla presenza di slot.metadata.identifier
    if not (slot and slot.metadata and slot.metadata.identifier) then
        -- richiedi al server un nuovo identifier (passando il slot client-side)
        local identifier = lib.callback.await("bpt_wallet:getNewIdentifier", 100, data.slot)
        if identifier then
            exports.ox_inventory:openInventory("stash", "wal_" .. identifier)
        else
            lib.notify({ type = "error", description = "Errore durante la creazione del portafogli." })
        end
    else
        -- Assicuriamoci che lo stash sia registrato server-side prima di aprirlo
        TriggerServerEvent("bpt_wallet:openWallet", slot.metadata.identifier)
        exports.ox_inventory:openInventory("stash", "wal_" .. slot.metadata.identifier)
    end
end)
