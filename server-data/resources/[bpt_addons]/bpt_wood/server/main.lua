RegisterServerEvent("lavorolegno:riceviLegna")
AddEventHandler("lavorolegno:riceviLegna", function()
    local src = source

    -- Aggiungi legna (ox_inventory)
    exports.ox_inventory:AddItem(src, "wood", 1)

    -- Notifica
    TriggerClientEvent("ox_lib:notify", src, { title = "Hai raccolto 1x Legna", type = "success" })
end)
