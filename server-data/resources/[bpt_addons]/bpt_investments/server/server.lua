local lastInvestment = {}

RegisterServerEvent("borsa:investi", function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()

    local now = os.time()
    local last = lastInvestment[identifier] or 0

    if now - last < 86400 then
        -- Mancano ancora ore/minuti
        local remaining = 86400 - (now - last)
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)

        TriggerClientEvent("ox_lib:notify", src, {
            title = "Investimento bloccato",
            description = ("Puoi investire nuovamente tra %d ore e %d minuti."):format(hours, minutes),
            type = "error",
        })
        return
    end

    if xPlayer.getMoney() >= amount then
        xPlayer.removeMoney(amount)

        lastInvestment[identifier] = now

        local chance = math.random(1, 100)
        local multiplier = 0

        if chance <= 15 then
            multiplier = 0.5
        elseif chance <= 45 then
            multiplier = 0.9
        elseif chance <= 80 then
            multiplier = 1.2
        else
            multiplier = 1.5
        end

        local ritorno = math.floor(amount * multiplier)

        SetTimeout(10000, function()
            xPlayer.addMoney(ritorno)

            TriggerClientEvent("ox_lib:notify", src, {
                title = "Esito Investimento",
                description = "Hai ricevuto $" .. ritorno .. " dal tuo investimento.",
                type = ritorno > amount and "success" or "warning",
            })
        end)
    else
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Fondi Insufficienti",
            description = "Non hai abbastanza denaro.",
            type = "error",
        })
    end
end)
