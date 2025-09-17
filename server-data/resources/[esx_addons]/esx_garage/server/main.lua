---@diagnostic disable: undefined-global
-- server/main.lua (cleaned & secured)

-- Utility: controlla ownership del veicolo
local function checkVehicleOwnership(plate, identifier, cb)
    MySQL.query("SELECT owner FROM owned_vehicles WHERE plate = @plate LIMIT 1", {
        ["@plate"] = plate,
    }, function(result)
        if result and result[1] and result[1].owner == identifier then
            cb(true)
        else
            cb(false)
        end
    end)
end

-- UPDATE vehicle record (safe): aggiorna i campi vehicle/stored/parking/pound
local function updateOwnedVehicleInDB(identifier, plate, vehicleJson, stored, parking, pound, cb)
    MySQL.update(
        [[
        UPDATE owned_vehicles
        SET `vehicle` = @vehicle, `stored` = @stored, `parking` = @parking, `pound` = @pound
        WHERE `plate` = @plate AND `owner` = @identifier
    ]],
        {
            ["@vehicle"] = vehicleJson,
            ["@stored"] = stored,
            ["@parking"] = parking,
            ["@pound"] = pound,
            ["@plate"] = plate,
            ["@identifier"] = identifier,
        },
        function(affected)
            if cb then
                cb(affected)
            end
        end
    )
end

-- Evento sicuro per aggiornare lo stato del veicolo (spawn o store)
RegisterNetEvent("esx_garage:updateOwnedVehicle")
AddEventHandler("esx_garage:updateOwnedVehicle", function(stored, parking, Impound, data, spawn)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- controlli base
    if not xPlayer then
        print("[esx_garage] updateOwnedVehicle: xPlayer not found for src:", src)
        return
    end
    if not data or not data.vehicleProps or not data.vehicleProps.plate then
        print("[esx_garage] ERRORE: updateOwnedVehicle chiamato senza dati validi")
        return
    end

    local plate = data.vehicleProps.plate
    local identifier = xPlayer.identifier

    -- Verifica che il veicolo appartenga effettivamente al chiamante
    checkVehicleOwnership(plate, identifier, function(isOwner)
        if not isOwner then
            print(("[esx_garage] WARNING: Player %s tried to update vehicle %s not owned by them"):format(identifier, plate))
            return
        end

        -- Aggiorna DB
        updateOwnedVehicleInDB(identifier, plate, json.encode(data.vehicleProps), stored, parking or 0, Impound or nil, function()
            if stored then
                xPlayer.showNotification(TranslateCap("veh_stored"))
            else
                -- spawn: assicurati di avere spawn (vector3) passato come param `spawn`
                local heading = (data.spawnPoint and data.spawnPoint.heading) or 0.0

                -- spawn sicuro tramite OneSync
                ESX.OneSync.SpawnVehicle(data.vehicleProps.model, spawn, heading, data.vehicleProps, function(netId)
                    local networkVehicle = NetworkGetEntityFromNetworkId(netId)
                    Wait(300)
                    -- warp ped nel veicolo (sicuro)
                    TaskWarpPedIntoVehicle(GetPlayerPed(src), networkVehicle, -1)
                end)
            end
        end)
    end)
end)

-- Evento sicuro chiamato dal client per richiedere l'impound
-- Manteniamo il nome "esx_garage:setImpound" per compatibilità col client,
-- ma lo registriamo come NetEvent e con validazioni.
RegisterNetEvent("esx_garage:setImpound")
AddEventHandler("esx_garage:setImpound", function(Impound, vehicleProps)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return
    end
    if not vehicleProps or not vehicleProps.plate then
        print("[esx_garage] setImpound called with invalid vehicleProps by src:", src)
        return
    end

    local plate = vehicleProps.plate
    local identifier = xPlayer.identifier

    -- Verifica ownership prima di impoundare
    checkVehicleOwnership(plate, identifier, function(isOwner)
        if not isOwner then
            print(("[esx_garage] WARNING: Player %s tried to impound vehicle %s not owned by them"):format(identifier, plate))
            return
        end

        -- Aggiorna DB: stored = 2 (impounded), salva impound_time = NOW()
        MySQL.update(
            [[
            UPDATE owned_vehicles
            SET `stored` = 2, `pound` = @Impound, `vehicle` = @vehicle, `impound_time` = NOW()
            WHERE `plate` = @plate AND `owner` = @identifier
        ]],
            {
                ["@Impound"] = Impound,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@plate"] = plate,
                ["@identifier"] = identifier,
            },
            function(affected)
                if affected and affected > 0 then
                    xPlayer.showNotification(TranslateCap("veh_impounded"))
                else
                    print(("[esx_garage] setImpound: DB update failed for plate %s"):format(plate))
                end
            end
        )
    end)
end)

-- Callback: recupera i veicoli parcheggiati in un determinato parking (stored = 1)
ESX.RegisterServerCallback("esx_garage:getVehiclesInParking", function(source, cb, parking)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb({})
        return
    end

    MySQL.query("SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `parking` = @parking AND `stored` = 1", {
        ["@identifier"] = xPlayer.identifier,
        ["@parking"] = parking,
    }, function(result)
        local vehicles = {}
        for i = 1, #result, 1 do
            table.insert(vehicles, {
                vehicle = json.decode(result[i].vehicle),
                plate = result[i].plate,
            })
        end
        cb(vehicles)
    end)
end)

-- Callback: verifica se il giocatore possiede la targa
ESX.RegisterServerCallback("esx_garage:checkVehicleOwner", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end

    MySQL.query("SELECT COUNT(*) as count FROM `owned_vehicles` WHERE `owner` = @identifier AND `plate` = @plate", {
        ["@identifier"] = xPlayer.identifier,
        ["@plate"] = plate,
    }, function(result)
        if result and tonumber(result[1].count) > 0 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

-- Callback: veicoli impounded generici del giocatore (stored = 2)
ESX.RegisterServerCallback("esx_garage:getVehiclesImpounded", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb({})
        return
    end

    MySQL.query("SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `stored` = 2", {
        ["@identifier"] = xPlayer.identifier,
    }, function(result)
        local vehicles = {}
        for i = 1, #result, 1 do
            table.insert(vehicles, {
                vehicle = json.decode(result[i].vehicle),
                plate = result[i].plate,
            })
        end
        cb(vehicles)
    end)
end)

-- Callback: veicoli nel pound specifico (stored = 2 e pound = Impound)
ESX.RegisterServerCallback("esx_garage:getVehiclesInPound", function(source, cb, Impound)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb({})
        return
    end

    MySQL.query("SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `pound` = @Impound AND `stored` = 2", {
        ["@identifier"] = xPlayer.identifier,
        ["@Impound"] = Impound,
    }, function(result)
        local vehicles = {}
        for i = 1, #result, 1 do
            table.insert(vehicles, {
                vehicle = json.decode(result[i].vehicle),
                plate = result[i].plate,
            })
        end
        cb(vehicles)
    end)
end)

-- Callback: controllo soldi semplice
ESX.RegisterServerCallback("esx_garage:checkMoney", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end
    cb(xPlayer.getMoney() >= amount)
end)

-- Evento: pagamento impound (rimuove soldi)
RegisterNetEvent("esx_garage:payPound")
AddEventHandler("esx_garage:payPound", function(amount, plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end
    if not amount or type(amount) ~= "number" then
        return
    end

    -- (opzionale) verifica ownership prima di prelevare?
    -- Se vuoi essere sicuro: checkVehicleOwnership(plate, xPlayer.identifier, function(isOwner) ... end)
    if xPlayer.getMoney() >= amount then
        xPlayer.removeMoney(amount, "Impound Fee")
        xPlayer.showNotification(TranslateCap("pay_Impound_bill", amount))

        -- una volta pagato, puoi aggiornare lo stato del veicolo a stored = 1 (parcheggiato)
        if plate then
            MySQL.update("UPDATE owned_vehicles SET `stored` = 1 WHERE `plate` = @plate AND `owner` = @identifier", {
                ["@plate"] = plate,
                ["@identifier"] = xPlayer.identifier,
            })
        end
    else
        xPlayer.showNotification(TranslateCap("missing_money"))
    end
end)

-- Callback: calcola il costo dinamico dell'impound usando TIMESTAMPDIFF in DB (più affidabile)
ESX.RegisterServerCallback("esx_garage:getImpoundCost", function(source, cb, plate, baseCost)
    if not plate or not baseCost then
        cb(baseCost or 0)
        return
    end

    -- TIMESTAMPDIFF(hour, impound_time, NOW()) -> ore trascorse
    MySQL.query("SELECT TIMESTAMPDIFF(HOUR, impound_time, NOW()) as hours FROM owned_vehicles WHERE plate = @plate LIMIT 1", {
        ["@plate"] = plate,
    }, function(result)
        if not result or not result[1] or not result[1].hours then
            cb(baseCost)
            return
        end

        local hours = tonumber(result[1].hours) or 0
        -- Formula: ogni 12 ore aumenta del 10%
        local multiplier = 1.0 + (0.1 * math.floor(hours / 12))
        local finalCost = math.floor(baseCost * multiplier)

        cb(finalCost)
    end)
end)
