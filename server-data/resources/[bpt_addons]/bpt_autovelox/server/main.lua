ESX = exports["es_extended"]:getSharedObject()

local autoveloxPositions = {
    { x = 249.217590, y = -1032.896729, z = 29.296753, speedLimit = 50 },
    { x = 1134.32, y = -982.34, z = 46.42, speedLimit = 70 },
    { x = -249.13, y = 6328.19, z = 32.8, speedLimit = 90 },
}

local currentAutoveloxIndex = 1
local activeFines = {} -- [playerId] = {fineAmount, vehiclePlate}

-- Change the position of the speed camera every so many minutes
Citizen.CreateThread(function()
    while true do
        currentAutoveloxIndex = currentAutoveloxIndex + 1
        if currentAutoveloxIndex > #autoveloxPositions then
            currentAutoveloxIndex = 1
        end
        TriggerClientEvent("autovelox:updatePosition", -1, autoveloxPositions[currentAutoveloxIndex])
        Citizen.Wait(10 * 60 * 1000)
    end
end)

-- Helper function to block a vehicle in the DB
local function blockVehicle(plate)
    MySQL.Async.execute("UPDATE owned_vehicles SET blocked_for_fine = 1 WHERE plate = @plate", {
        ["@plate"] = plate,
    })
end

-- Helper function to unlock vehicle in DB
local function unblockVehicle(plate)
    MySQL.Async.execute("UPDATE owned_vehicles SET blocked_for_fine = 0 WHERE plate = @plate", {
        ["@plate"] = plate,
    })
end

-- Check if vehicle is locked (returns boolean callback)
local function isVehicleBlocked(plate, cb)
    MySQL.Async.fetchScalar("SELECT blocked_for_fine FROM owned_vehicles WHERE plate = @plate LIMIT 1", {
        ["@plate"] = plate,
    }, function(result)
        if result and tonumber(result) == 1 then
            cb(true)
        else
            cb(false)
        end
    end)
end

-- Receives signal from clients with high speed
RegisterNetEvent("autovelox:applyFine")
AddEventHandler("autovelox:applyFine", function(speed, vehiclePlate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then
        return
    end

    local autovelox = autoveloxPositions[currentAutoveloxIndex]
    local fineAmount = math.floor((speed - autovelox.speedLimit) * 10)

    if fineAmount <= 0 then
        return
    end

    -- Check if the vehicle is already blocked (avoid double fines)
    isVehicleBlocked(vehiclePlate, function(isBlocked)
        if isBlocked then
            TriggerClientEvent("chat:addMessage", _source, { args = { "^1Sistema Multa", "Il tuo veicolo è già bloccato per una multa non pagata." } })
            return
        else
            -- Check bank balance
            if xPlayer.getAccount("bank").money >= fineAmount then
                -- withdraws money and sends it to the company
                xPlayer.removeAccountMoney("bank", fineAmount)

                -- government company payment
                local xSociety = ESX.GetSociety("government")
                if xSociety then
                    xSociety.addMoney(fineAmount)
                end

                TriggerClientEvent("chat:addMessage", _source, { args = { "^2Sistema Multa", "Hai pagato una multa di $" .. fineAmount .. "." } })
            else
                activeFines[_source] = { fineAmount = fineAmount, vehiclePlate = vehiclePlate }
                TriggerClientEvent("autovelox:pignoramentoStart", _source, fineAmount)
                TriggerClientEvent("chat:addMessage", _source, { args = { "^1Sistema Multa", "Non hai abbastanza soldi, il veicolo " .. vehiclePlate .. " è stato pignorato finché non pagherai la multa di $" .. fineAmount .. "." } })

                blockVehicle(vehiclePlate)

                TriggerClientEvent("autovelox:blockVehicle", _source, vehiclePlate)
            end
        end
    end)
end)

RegisterNetEvent("autovelox:payFineAfter")
AddEventHandler("autovelox:payFineAfter", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local fineData = activeFines[_source]
    if not fineData then
        TriggerClientEvent("chat:addMessage", _source, { args = { "^1Sistema Multa", "Non hai multe da pagare." } })
        return
    end

    if xPlayer.getAccount("bank").money >= fineData.fineAmount then
        xPlayer.removeAccountMoney("bank", fineData.fineAmount)
        local xSociety = ESX.GetSociety("government")
        if xSociety then
            xSociety.addMoney(fineData.fineAmount)
        end

        unblockVehicle(fineData.vehiclePlate)

        TriggerClientEvent("autovelox:unblockVehicle", _source, fineData.vehiclePlate)

        activeFines[_source] = nil
        TriggerClientEvent("chat:addMessage", _source, { args = { "^2Sistema Multa", "Hai pagato la multa e il veicolo è stato sbloccato." } })
    else
        TriggerClientEvent("chat:addMessage", _source, { args = { "^1Sistema Multa", "Non hai ancora abbastanza soldi per pagare la multa." } })
    end
end)

ESX.RegisterServerCallback("autovelox:isVehicleBlocked", function(_, cb, plate)
    exports.oxmysql:fetch('SELECT blocked_for_fine FROM owned_vehicles WHERE plate = ?', {plate}, function(result)
        if result[1] and result[1].blocked_for_fine == 1 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

