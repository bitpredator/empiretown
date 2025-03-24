---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("autovelox:recordFine")
AddEventHandler("autovelox:recordFine", function(playerId, playerName, fineAmount, reason, location)
    print(("[Autovelox] Multa ricevuta da %s (ID: %d) | Importo: $%.2f | Motivo: %s | Posizione: %s"):format(playerName, playerId, fineAmount, reason, location))

    local xPlayer = ESX.GetPlayerFromId(playerId)

    -- Verifica che il giocatore esista
    if xPlayer then
        local query = "INSERT INTO multe (player_id, player_name, amount, reason, location) VALUES (@playerId, @playerName, @amount, @reason, @location)"

        MySQL.Async.execute(query, {
            ["@playerId"] = playerId,
            ["@playerName"] = playerName,
            ["@amount"] = fineAmount,
            ["@reason"] = reason,
            ["@location"] = location,
        }, function(rowsChanged)
            if rowsChanged > 0 then
                print("[Autovelox] Multa registrata con successo nel database")
                TriggerClientEvent("esx:showNotification", playerId, "Hai ricevuto una multa di $" .. fineAmount)
            else
                print("[Autovelox] Errore durante la registrazione della multa nel database")
            end
        end)
    else
        print("[Autovelox] Errore: Giocatore non trovato con ID " .. playerId)
    end
end)
