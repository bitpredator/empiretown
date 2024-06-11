local playersHealing, deadPlayers = {}, {}

ESX = exports["es_extended"]:getSharedObject()

TriggerEvent("esx_society:registerSociety", "ambulance", "Ambulance", "society_ambulance", "society_ambulance", "society_ambulance", {
    type = "public",
})

RegisterNetEvent("bpt_ambulancejob:revive")
AddEventHandler("bpt_ambulancejob:revive", function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.job.name == "ambulance" then
        local xTarget = ESX.GetPlayerFromId(playerId)

        if xTarget then
            if deadPlayers[playerId] then
                if Config.ReviveReward > 0 then
                    xPlayer.showNotification(TranslateCap("revive_complete_award", xTarget.name, Config.ReviveReward))
                    xPlayer.addMoney(Config.ReviveReward, "Revive Reward")
                    xTarget.triggerEvent("bpt_ambulancejob:revive")
                else
                    xPlayer.showNotification(TranslateCap("revive_complete", xTarget.name))
                    xTarget.triggerEvent("bpt_ambulancejob:revive")
                end
            else
                xPlayer.showNotification(TranslateCap("player_notTranslateCapnconscious"))
            end
        else
            xPlayer.showNotification(TranslateCap("revive_fail_offline"))
        end
    end
end)

RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function()
    deadPlayers[source] = "dead"
    TriggerClientEvent("bpt_ambulancejob:setDeadPlayers", -1, deadPlayers)
end)

RegisterServerEvent("bpt_ambulancejob:svsearch")
AddEventHandler("bpt_ambulancejob:svsearch", function()
    TriggerClientEvent("bpt_ambulancejob:clsearch", -1, source)
end)

RegisterNetEvent("bpt_ambulancejob:onPlayerDistress")
AddEventHandler("bpt_ambulancejob:onPlayerDistress", function()
    if deadPlayers[source] then
        deadPlayers[source] = "distress"
        TriggerClientEvent("bpt_ambulancejob:setDeadPlayers", -1, deadPlayers)
    end
end)

RegisterNetEvent("esx:onPlayerSpawn")
AddEventHandler("esx:onPlayerSpawn", function()
    if deadPlayers[source] then
        deadPlayers[source] = nil
        TriggerClientEvent("bpt_ambulancejob:setDeadPlayers", -1, deadPlayers)
    end
end)

AddEventHandler("esx:playerDropped", function(playerId)
    if deadPlayers[playerId] then
        deadPlayers[playerId] = nil
        TriggerClientEvent("bpt_ambulancejob:setDeadPlayers", -1, deadPlayers)
    end
end)

RegisterNetEvent("bpt_ambulancejob:heal")
AddEventHandler("bpt_ambulancejob:heal", function(target, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "ambulance" then
        TriggerClientEvent("bpt_ambulancejob:heal", target, type)
    end
end)

RegisterNetEvent("bpt_ambulancejob:putInVehicle")
AddEventHandler("bpt_ambulancejob:putInVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "ambulance" then
        TriggerClientEvent("bpt_ambulancejob:putInVehicle", target)
    end
end)

ESX.RegisterServerCallback("bpt_ambulancejob:removeItemsAfterRPDeath", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.RemoveCashAfterRPDeath then
        if xPlayer.getMoney() > 0 then
            xPlayer.removeMoney(xPlayer.getMoney(), "Death")
        end

        if xPlayer.getAccount("black_money").money > 0 then
            xPlayer.setAccountMoney("black_money", 0, "Death")
        end
    end

    if Config.RemoveItemsAfterRPDeath then
        for i = 1, #xPlayer.inventory, 1 do
            if xPlayer.inventory[i].count > 0 then
                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
            end
        end
    end

    local playerLoadout = {}
    if Config.RemoveWeaponsAfterRPDeath then
        for i = 1, #xPlayer.loadout, 1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end
    else -- save weapons & restore em' since spawnmanager removes them
        for i = 1, #xPlayer.loadout, 1 do
            table.insert(playerLoadout, xPlayer.loadout[i])
        end

        -- give back wepaons after a couple of seconds
        CreateThread(function()
            Wait(5000)
            for i = 1, #playerLoadout, 1 do
                if playerLoadout[i].label ~= nil then
                    xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
                end
            end
        end)
    end

    cb()
end)

if Config.EarlyRespawnFine then
    ESX.RegisterServerCallback("bpt_ambulancejob:checkBalance", function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankBalance = xPlayer.getAccount("bank").money

        cb(bankBalance >= Config.EarlyRespawnFineAmount)
    end)

    RegisterNetEvent("bpt_ambulancejob:payFine")
    AddEventHandler("bpt_ambulancejob:payFine", function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local fineAmount = Config.EarlyRespawnFineAmount

        xPlayer.showNotification(TranslateCap("respawn_bleedout_fine_msg", ESX.Math.GroupDigits(fineAmount)))
        xPlayer.removeAccountMoney("bank", fineAmount, "Respawn Fine")
    end)
end

ESX.RegisterServerCallback("bpt_ambulancejob:getItemAmount", function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count

    cb(quantity)
end)

ESX.RegisterServerCallback("bpt_ambulancejob:buyJobVehicle", function(source, cb, vehicleProps, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

    -- vehicle model not found
    if price == 0 then
        cb(false)
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price, "Job Vehicle Purchase")

            MySQL.Async.execute("INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)", {
                ["@owner"] = xPlayer.identifier,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@plate"] = vehicleProps.plate,
                ["@type"] = type,
                ["@job"] = xPlayer.job.name,
                ["@stored"] = true,
            }, function()
                cb(true)
            end)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback("bpt_ambulancejob:storeNearbyVehicle", function(source, cb, nearbyVehicles)
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundPlate, foundNum

    for k, v in ipairs(nearbyVehicles) do
        local result = MySQL.Sync.fetchAll("SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job", {
            ["@owner"] = xPlayer.identifier,
            ["@plate"] = v.plate,
            ["@job"] = xPlayer.job.name,
        })

        if result[1] then
            foundPlate, foundNum = result[1].plate, k
            break
        end
    end

    if not foundPlate then
        cb(false)
    else
        MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job", {
            ["@owner"] = xPlayer.identifier,
            ["@plate"] = foundPlate,
            ["@job"] = xPlayer.job.name,
        }, function(rowsChanged)
            if rowsChanged == 0 then
                cb(false)
            else
                cb(true, foundNum)
            end
        end)
    end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
    local vehicles = Config.AuthorizedVehicles[type][jobGrade]

    for _, v in ipairs(vehicles) do
        if GetHashKey(v.model) == vehicleHash then
            return v.price
        end
    end

    return 0
end

RegisterNetEvent("bpt_ambulancejob:removeItem")
AddEventHandler("bpt_ambulancejob:removeItem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)

    if item == "bandage" then
        xPlayer.showNotification(TranslateCap("used_bandage"))
    elseif item == "medikit" then
        xPlayer.showNotification(TranslateCap("used_medikit"))
    end
end)

RegisterNetEvent("bpt_ambulancejob:giveItem")
AddEventHandler("bpt_ambulancejob:giveItem", function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "ambulance" then
        print(('[bpt_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
        return
    elseif itemName ~= "medikit" and itemName ~= "bandage" then
        print(('[bpt_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
        return
    end

    if xPlayer.canCarryItem(itemName, amount) then
        xPlayer.addInventoryItem(itemName, amount)
    else
        xPlayer.showNotification(TranslateCap("max_item"))
    end
end)

ESX.RegisterCommand(
    "revive",
    "admin",
    function(_, args)
        args.playerId.triggerEvent("bpt_ambulancejob:revive")
    end,
    true,
    {
        help = TranslateCap("revive_help"),
        validate = true,
        arguments = {
            { name = "playerId", help = "The player id", type = "player" },
        },
    }
)

ESX.RegisterUsableItem("medikit", function(source)
    if not playersHealing[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("medikit", 1)

        playersHealing[source] = true
        TriggerClientEvent("bpt_ambulancejob:useItem", source, "medikit")

        Wait(10000)
        playersHealing[source] = nil
    end
end)

ESX.RegisterUsableItem("bandage", function(source)
    if not playersHealing[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bandage", 1)

        playersHealing[source] = true
        TriggerClientEvent("bpt_ambulancejob:useItem", source, "bandage")

        Wait(10000)
        playersHealing[source] = nil
    end
end)

ESX.RegisterServerCallback("bpt_ambulancejob:getDeathStatus", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchScalar("SELECT is_dead FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
    }, function(isDead)
        if isDead then
            print(('[bpt_ambulancejob] [^2INFO^7] "%s" attempted combat logging'):format(xPlayer.identifier))
        end

        cb(isDead)
    end)
end)

RegisterNetEvent("bpt_ambulancejob:setDeathStatus")
AddEventHandler("bpt_ambulancejob:setDeathStatus", function(isDead)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type(isDead) == "boolean" then
        MySQL.Sync.execute("UPDATE users SET is_dead = @isDead WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier,
            ["@isDead"] = isDead,
        })
    end
end)
