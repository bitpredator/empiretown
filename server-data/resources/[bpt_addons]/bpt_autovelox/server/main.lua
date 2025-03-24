---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

-- Funzione per contare quanti poliziotti sono online
function GetPoliceCount()
    local count = 0
    local players = ESX.GetExtendedPlayers()

    for _, player in pairs(players) do
        if player.getJob().name == "police" then
            count = count + 1
        end
    end

    return count
end

RegisterServerEvent("autovelox:recordFine")
AddEventHandler("autovelox:recordFine", function(playerId, playerName, fineAmount, reason, location)
    local policeCount = GetPoliceCount()

    if policeCount < 1 then
        print("[Autovelox] Nessun poliziotto online, multa annullata.")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        -- Controlla se il giocatore ha abbastanza soldi
        if xPlayer.getAccount("bank").money >= fineAmount then
            xPlayer.removeAccountMoney("bank", fineAmount) -- Scala i soldi dal conto bancario
        else
            xPlayer.removeMoney(fineAmount) -- Scala i soldi in contanti se non ha abbastanza in banca
        end

        -- Aggiunge i soldi nel conto aziendale della polizia
        TriggerEvent("bpt_addonaccount:getSharedAccount", "society_police", function(account)
            if account then
                account.addMoney(fineAmount)
            end
        end)

        -- Registra la multa nel database
        MySQL.Async.execute("INSERT INTO multe (player_id, player_name, amount, reason, location) VALUES (@playerId, @playerName, @amount, @reason, @location)", {
            ["@playerId"] = playerId,
            ["@playerName"] = playerName,
            ["@amount"] = fineAmount,
            ["@reason"] = reason,
            ["@location"] = location,
        }, function(rowsChanged)
            if rowsChanged > 0 then
                print(("[Autovelox] Multa registrata per %s (ID: %d) | Importo: $%.2f | Motivo: %s | Posizione: %s"):format(playerName, playerId, fineAmount, reason, location))
                TriggerClientEvent("esx:showNotification", playerId, "Hai ricevuto una multa di $" .. fineAmount .. ", l’importo è stato prelevato automaticamente.")
            else
                print("[Autovelox] Errore durante la registrazione della multa nel database")
            end
        end)
    else
        print("[Autovelox] Errore: Giocatore non trovato con ID " .. playerId)
    end
end)
