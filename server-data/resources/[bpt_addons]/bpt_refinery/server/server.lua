---@diagnostic disable: undefined-global
local ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("bpt_refinery:startProcessing", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local identifier = xPlayer.identifier
    local existing = MySQL.query.await("SELECT * FROM refinery_jobs WHERE identifier = ?", { identifier })

    if #existing > 5 then
        TriggerClientEvent("ox_lib:notify", src, { type = "error", description = TranslateCap("already_processing") })
        return
    end

    if xPlayer.getInventoryItem("stone").count < 30 then
        TriggerClientEvent("ox_lib:notify", src, { type = "error", description = TranslateCap("not_enough_stone") })
        return
    end

    if xPlayer.getAccount("bank").money < 100 then
        TriggerClientEvent("ox_lib:notify", src, { type = "error", description = TranslateCap("not_enough_money") })
        return
    end

    xPlayer.removeInventoryItem("stone", 30)
    xPlayer.removeAccountMoney("bank", 100)

    local totalItems = math.random(15, 30)
    local rewardItems = {}

    for i = 1, totalItems do
        for _, mat in ipairs(Config.RefineryRewards) do
            if math.random(100) <= mat.percent then
                table.insert(rewardItems, mat.item)
                break
            end
        end
    end

    local ready_time = os.date("%Y-%m-%d %H:%M:%S", os.time() + 86400)

    for _, item in ipairs(rewardItems) do
        MySQL.insert.await("INSERT INTO refinery_jobs (identifier, item, amount, ready_time) VALUES (?, ?, ?, ?)", {
            identifier,
            item,
            1,
            ready_time,
        })
    end

    TriggerClientEvent("ox_lib:notify", src, { type = "success", description = TranslateCap("processing_started") })
end)

RegisterServerEvent("bpt_refinery:collectMaterials", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local identifier = xPlayer.identifier
    local now = os.date("%Y-%m-%d %H:%M:%S")
    local jobs = MySQL.query.await("SELECT * FROM refinery_jobs WHERE identifier = ? AND ready_time <= ?", { identifier, now })

    if #jobs == 0 then
        TriggerClientEvent("ox_lib:notify", src, { type = "error", description = TranslateCap("no_items_ready") })
        return
    end

    for _, job in ipairs(jobs) do
        xPlayer.addInventoryItem(job.item, job.amount)
    end

    MySQL.query.await("DELETE FROM refinery_jobs WHERE identifier = ? AND ready_time <= ?", { identifier, now })

    TriggerClientEvent("ox_lib:notify", src, { type = "success", description = TranslateCap("items_collected") })
end)
