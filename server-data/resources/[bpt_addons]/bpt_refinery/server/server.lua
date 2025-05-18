local materialiRari = {
    {item = "emerald", percent = 2},
    {item = "diamond", percent = 3},
    {item = "gold", percent = 5},
    {item = "steel", percent = 10},
    {item = "iron", percent = 15},
    {item = "copper", percent = 20},
    {item = "gunpowder", percent = 10}
}

RegisterServerEvent("fonderia:startLavorazione", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    -- Controllo se ha già una lavorazione attiva
    local existing = MySQL.query.await("SELECT * FROM refinery_jobs WHERE identifier = ?", {identifier})
    if #existing > 0 then
        TriggerClientEvent("ox_lib:notify", src, {type = "error", description = "Hai già una lavorazione attiva!"})
        return
    end

    -- Controlli item e soldi
    if xPlayer.getInventoryItem("stone").count < 30 then
        TriggerClientEvent("ox_lib:notify", src, {type = "error", description = "Ti servono almeno 30 pietre"})
        return
    end

    if xPlayer.getAccount("bank").money < 100 then
        TriggerClientEvent("ox_lib:notify", src, {type = "error", description = "Non hai abbastanza soldi in banca"})
        return
    end

    -- Rimozione item e soldi
    xPlayer.removeInventoryItem("stone", 30)
    xPlayer.removeAccountMoney("bank", 100)

    -- Selezione dei materiali (fino a 3)
    local totalItems = math.random(1, 3)
    local rewardItems = {}

    for i = 1, totalItems do
        for _, mat in ipairs(materialiRari) do
            if math.random(100) <= mat.percent then
                table.insert(rewardItems, mat.item)
                break
            end
        end
    end

    -- Salvataggio nel database
    local ready_time = os.date("%Y-%m-%d %H:%M:%S", os.time() + 86400) -- 24h

    for _, item in ipairs(rewardItems) do
        MySQL.insert.await("INSERT INTO refinery_jobs (identifier, item, amount, ready_time) VALUES (?, ?, ?, ?)", {
            identifier, item, 1, ready_time
        })
    end

    TriggerClientEvent("ox_lib:notify", src, {type = "success", description = "Hai avviato la lavorazione, torna tra 24 ore"})
end)

RegisterServerEvent("fonderia:ritiraMateriali", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local now = os.date("%Y-%m-%d %H:%M:%S")

    local jobs = MySQL.query.await("SELECT * FROM refinery_jobs WHERE identifier = ? AND ready_time <= ?", {
        identifier, now
    })

    if #jobs == 0 then
        TriggerClientEvent("ox_lib:notify", src, {type = "error", description = "Nessun materiale pronto da ritirare"})
        return
    end

    for _, job in pairs(jobs) do
        xPlayer.addInventoryItem(job.item, job.amount)
    end

    -- Pulizia database
    MySQL.query.await("DELETE FROM refinery_jobs WHERE identifier = ? AND ready_time <= ?", {
        identifier, now
    })

    TriggerClientEvent("ox_lib:notify", src, {type = "success", description = "Hai ritirato i materiali lavorati!"})
end)
