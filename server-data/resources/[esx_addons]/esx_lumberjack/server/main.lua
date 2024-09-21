local dutyPlayers = {}
local trees = {}

lib.callback.register("map_lumberjack:duty", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    if not Config.FreelanceJob and job.name ~= Config.JobName then
        return false
    end

    if dutyPlayers[source] then
        dutyPlayers[source] = nil
        return false
    else
        dutyPlayers[source] = true
        return true
    end
end)

Citizen.CreateThread(function()
    for _, v in pairs(Config.Trees) do
        table.insert(trees, {
            coords = v,
            health = 100,
        })
    end
end)

lib.callback.register("map_lumberjack:getTreesWithData", function(_)
    return trees
end)

lib.callback.register("map_lumberjack:hasItem", function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getInventoryItem("water").count
end)

lib.callback.register("map_lumberjack:makeDamage", function(source, index)
    local data = trees[index]
    local xPlayer = ESX.GetPlayerFromId(source)

    if not data or not dutyPlayers[source] then
        return false
    end

    trees[index].health = trees[index].health - 20
    SyncTrees()

    if data.health == 0 then
        xPlayer.addInventoryItem("wood", 5)
        Citizen.SetTimeout(Config.GrowingTime, function()
            trees[index].health = 100
            SyncTrees()
        end)
    end

    return true
end)

function SyncTrees()
    TriggerClientEvent("map_lumberjack:syncTrees", -1, trees)
end
