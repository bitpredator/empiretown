ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("ricicla", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = xPlayer.getAccount("black_money").money

    if amount <= 0 then
        TriggerClientEvent("ox_lib:notify", source, { type = "error", description = "Non hai denaro sporco." })
        return
    end

    xPlayer.removeAccountMoney("black_money", amount)

    MySQL.insert("INSERT INTO money_laundry (identifier, amount, ready_time) VALUES (?, ?, ?)", {
        xPlayer.identifier,
        amount,
        os.time() + Config.RecyclingDelay,
    })

    TriggerClientEvent("ox_lib:notify", source, {
        type = "success",
        description = "Hai avviato il riciclaggio. Torna tra 24 ore.",
    })
end)

RegisterCommand("ritira", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()

    MySQL.query("SELECT id, amount, ready_time FROM money_laundry WHERE identifier = ? AND ready_time <= ?", {
        xPlayer.identifier,
        currentTime,
    }, function(results)
        if #results == 0 then
            TriggerClientEvent("ox_lib:notify", source, { type = "error", description = "Nessun denaro pronto al ritiro." })
            return
        end

        local total = 0
        for _, row in pairs(results) do
            total = total + row.amount
            MySQL.execute("DELETE FROM money_laundry WHERE id = ?", { row.id })
        end

        xPlayer.addMoney(total)

        TriggerClientEvent("ox_lib:notify", source, {
            type = "success",
            description = ("Hai ritirato %s$ puliti."):format(total),
        })
    end)
end)
