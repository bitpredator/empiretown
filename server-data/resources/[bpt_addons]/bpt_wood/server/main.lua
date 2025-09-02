-- Callback per controllare l'ascia
lib.callback.register("woodcutting:checkAxe", function(source, axeName)
    axeName = axeName or Config.AxeItem
    local slotCheck = exports.ox_inventory:Search(source, "slots", axeName) or {}
    return slotCheck[1] ~= nil
end)

-- Evento: dare legna e consumare durabilità
RegisterNetEvent("woodcutting:giveWood", function()
    local src = source
    local axe = exports.ox_inventory:Search(src, "slots", Config.AxeItem)[1]
    if not axe then
        TriggerClientEvent("ox_lib:notify", src, { title = "Errore", description = "Non hai un'ascia valida!", type = "error" })
        return
    end

    -- Consuma un uso
    local uses = (axe.metadata.uses or Config.AxeMaxUses or 100) - 1
    if uses <= 0 then
        exports.ox_inventory:RemoveItem(src, Config.AxeItem, 1, axe.metadata, axe.slot)
        TriggerClientEvent("ox_lib:notify", src, { title = "Ascia rotta", description = "La tua ascia si è rotta!", type = "error" })
    else
        axe.metadata.uses = uses
        exports.ox_inventory:SetMetadata(src, axe.slot, axe.metadata)
        TriggerClientEvent("ox_lib:notify", src, { title = "Ascia usata", description = ("Durabilità residua: %s/%s"):format(uses, Config.AxeMaxUses or 100), type = "inform" })
    end

    -- Aggiungi legna
    local amount = math.random(Config.WoodAmount[1], Config.WoodAmount[2])
    exports.ox_inventory:AddItem(src, Config.WoodItem, amount)
    TriggerClientEvent("ox_lib:notify", src, { title = "Hai raccolto legna", description = ("Hai ottenuto x%s %s"):format(amount, Config.WoodItem), type = "success" })
end)
