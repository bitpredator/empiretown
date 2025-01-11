---@diagnostic disable: undefined-global

local playersHealing, deadPlayers = {}, {}

if GetResourceState("npwd") ~= "missing" then
    TriggerEvent("npwd:registerNumber", "ambulance", TranslateCap("alert_ambulance"), true, true)
end

if GetResourceState("bpt_society") ~= "missing" then
    TriggerEvent("bpt_society:registerSociety", "ambulance", "Ambulance", "society_ambulance", "society_ambulance", "society_ambulance", { type = "public" })
end

local function IsDeadState(src, bool)
    if not src or bool == nil then
        return
    end

    Player(src).state:set("isDead", bool, true)
end

RegisterNetEvent("bpt_ambulancejob:revive")
AddEventHandler("bpt_ambulancejob:revive", function(playerId)
    playerId = tonumber(playerId)
    local xPlayer = source and ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.job.name == "ambulance" then
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget then
            if deadPlayers[playerId] then
                if Config.ReviveReward > 0 then
                    xPlayer.showNotification(TranslateCap("revive_complete_award", xTarget.name, Config.ReviveReward))
                    xPlayer.addMoney(Config.ReviveReward, "Revive Reward")
                    xTarget.triggerEvent("bpt_ambulancejob:revive")
                    IsDeadState(xTarget.source, false)
                else
                    xPlayer.showNotification(TranslateCap("revive_complete", xTarget.name))
                    xTarget.triggerEvent("bpt_ambulancejob:revive")
                    IsDeadState(xTarget.source, false)
                end
                local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

                for _, xPlayer in pairs(Ambulance) do
                    if xPlayer.job.name == "ambulance" then
                        xPlayer.triggerEvent("bpt_ambulancejob:PlayerNotDead", playerId)
                    end
                end
                deadPlayers[playerId] = "distress"
            else
                xPlayer.showNotification(TranslateCap("player_not_unconscious"))
            end
        else
            xPlayer.showNotification(TranslateCap("revive_fail_offline"))
        end
    end
end)

AddEventHandler("txAdmin:events:healedPlayer", function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end
    if deadPlayers[eventData.id] then
        TriggerClientEvent("bpt_ambulancejob:revive", eventData.id)
        local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

        for _, xPlayer in pairs(Ambulance) do
            if xPlayer.job.name == "ambulance" then
                xPlayer.triggerEvent("bpt_ambulancejob:PlayerNotDead", eventData.id)
            end
        end
        deadPlayers[eventData.id] = nil
    end
end)

RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
    local source = source
    deadPlayers[source] = "dead"
    local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")
    IsDeadState(source, true)

    for _, xPlayer in pairs(Ambulance) do
        xPlayer.triggerEvent("bpt_ambulancejob:PlayerDead", source)
    end
end)

RegisterServerEvent("bpt_ambulancejob:svsearch")
AddEventHandler("bpt_ambulancejob:svsearch", function()
    TriggerClientEvent("bpt_ambulancejob:clsearch", -1, source)
end)

RegisterNetEvent("bpt_ambulancejob:onPlayerDistress")
AddEventHandler("bpt_ambulancejob:onPlayerDistress", function()
    local source = source
    local injuredPed = GetPlayerPed(source)
    local injuredCoords = GetEntityCoords(injuredPed)

    if deadPlayers[source] then
        deadPlayers[source] = "distress"
        local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

        for _, xPlayer in pairs(Ambulance) do
            xPlayer.triggerEvent("bpt_ambulancejob:PlayerDistressed", source, injuredCoords)
        end
    end
end)

RegisterNetEvent("esx:onPlayerSpawn")
AddEventHandler("esx:onPlayerSpawn", function()
    local source = source
    if deadPlayers[source] then
        deadPlayers[source] = nil
        IsDeadState(source, false)
        local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

        for _, xPlayer in pairs(Ambulance) do
            xPlayer.triggerEvent("bpt_ambulancejob:PlayerNotDead", source)
        end
    end
end)

AddEventHandler("esx:playerDropped", function(playerId, reason)
    if deadPlayers[playerId] then
        deadPlayers[playerId] = nil
        IsDeadState(playerId, false)
        local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")

        for _, xPlayer in pairs(Ambulance) do
            if xPlayer.job.name == "ambulance" then
                xPlayer.triggerEvent("bpt_ambulancejob:PlayerNotDead", playerId)
            end
        end
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

    if Config.OxInventory and Config.RemoveItemsAfterRPDeath then
        exports.ox_inventory:ClearInventory(xPlayer.source)
        return cb()
    end

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

    if Config.OxInventory then
        return cb()
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
    local price = GetPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

    -- vehicle model not found
    if price == 0 then
        cb(false)
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price, "Job Vehicle Purchase")

            MySQL.insert("INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (?, ?, ?, ?, ?, ?)", { xPlayer.identifier, json.encode(vehicleProps), vehicleProps.plate, type, xPlayer.job.name, true }, function(rowsChanged)
                cb(true)
            end)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback("bpt_ambulancejob:storeNearbyVehicle", function(source, cb, plates)
    local xPlayer = ESX.GetPlayerFromId(source)

    local plate = MySQL.scalar.await("SELECT plate FROM owned_vehicles WHERE owner = ? AND plate IN (?) AND job = ?", { xPlayer.identifier, plates, xPlayer.job.name })

    if plate then
        MySQL.update("UPDATE owned_vehicles SET `stored` = true WHERE owner = ? AND plate = ? AND job = ?", { xPlayer.identifier, plate, xPlayer.job.name }, function(rowsChanged)
            if rowsChanged == 0 then
                cb(false)
            else
                cb(plate)
            end
        end)
    else
        cb(false)
    end
end)

function GetPriceFromHash(vehicleHash, jobGrade, type)
    local vehicles = Config.AuthorizedVehicles[type][jobGrade]

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if joaat(vehicle.model) == vehicleHash then
            return vehicle.price
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
        print(("[^2WARNING^7] Player ^5%s^7 Tried Giving Themselves -> ^5" .. itemName .. "^7!"):format(xPlayer.source))
        return
    elseif itemName ~= "medikit" and itemName ~= "bandage" then
        print(("[^2WARNING^7] Player ^5%s^7 Tried Giving Themselves -> ^5" .. itemName .. "^7!"):format(xPlayer.source))
        return
    end

    if xPlayer.canCarryItem(itemName, amount) then
        xPlayer.addInventoryItem(itemName, amount)
    else
        xPlayer.showNotification(TranslateCap("max_item"))
    end
end)

ESX.RegisterCommand("revive", "admin", function(xPlayer, args, showError)
    args.playerId.triggerEvent("bpt_ambulancejob:revive")
end, true, { help = TranslateCap("revive_help"), validate = true, arguments = {
    { name = "playerId", help = "The player id", type = "player" },
} })

ESX.RegisterCommand("reviveall", "admin", function(xPlayer, args, showError)
    TriggerClientEvent("bpt_ambulancejob:revive", -1)
end, false)

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

ESX.RegisterServerCallback("bpt_ambulancejob:getDeadPlayers", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "ambulance" then
        cb(deadPlayers)
    end
end)

ESX.RegisterServerCallback("bpt_ambulancejob:getDeathStatus", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.scalar("SELECT is_dead FROM users WHERE identifier = ?", { xPlayer.identifier }, function(IsDead)
        cb(IsDead)
    end)
end)

RegisterNetEvent("bpt_ambulancejob:setDeathStatus")
AddEventHandler("bpt_ambulancejob:setDeathStatus", function(IsDead)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type(IsDead) == "boolean" then
        MySQL.update("UPDATE users SET is_dead = ? WHERE identifier = ?", { IsDead, xPlayer.identifier })
        IsDeadState(source, IsDead)

        if not IsDead then
            local Ambulance = ESX.GetExtendedPlayers("job", "ambulance")
            for _, xPlayer in pairs(Ambulance) do
                xPlayer.triggerEvent("bpt_ambulancejob:PlayerNotDead", source)
            end
        end
    end
end)
