local ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("esx_cuffanimation:startArrest")
AddEventHandler("esx_cuffanimation:startArrest", function(targetId)
    local sourceId = source
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if not targetPlayer then
        print(("[CuffAnimation] Invalid target player ID: %s"):format(targetId))
        return
    end

    -- Invia evento al giocatore arrestato
    TriggerClientEvent("esx_cuffanimation:arrested", targetPlayer.source, sourceId)

    -- Invia evento al poliziotto
    TriggerClientEvent("esx_cuffanimation:arrest", sourceId)
end)
