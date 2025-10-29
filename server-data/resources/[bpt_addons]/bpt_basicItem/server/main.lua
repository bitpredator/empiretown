local ESX = exports["es_extended"]:getSharedObject()

-- Funzione helper per registrare item compatibili ESX + OX
local function registerUsableCard(itemName, clientEvent)
    -- Registrazione per OX Inventory (nuovo metodo)
    TriggerEvent("ox_inventory:registerUsableItem", itemName, function(source)
        TriggerClientEvent(clientEvent, source)
    end)
    print(("[bpt_idcard] ✅ Registrato item '%s' per OX Inventory"):format(itemName))

    -- Registrazione fallback per ESX
    if ESX and ESX.RegisterUsableItem then
        ESX.RegisterUsableItem(itemName, function(source)
            TriggerClientEvent(clientEvent, source)
        end)
        print(("[bpt_idcard] ✅ Registrato item '%s' per ESX"):format(itemName))
    end
end

-- 📄 Registrazione carte
registerUsableCard("idcard", "bpt_idcard:useID")
registerUsableCard("dmvcard", "bpt_idcard:useDMV")
registerUsableCard("licensecard", "bpt_idcard:useWeapon")
