ESX = exports["es_extended"]:getSharedObject()

--[[ =========================================================
    FUNZIONI UTILI
========================================================= ]]

-- Trim delle stringhe
string.trim = function(text)
    if text ~= nil then
        return text:match("^%s*(.-)%s*$")
    else
        return nil
    end
end

-- Conta quanti veicoli ci sono in un parcheggio
function GetVehicleNumOfParking(name)
    local rs = MySQL.Sync.fetchAll("SELECT `id` FROM `car_parking` WHERE `parking` = @parking", { ["@parking"] = name })
    if type(rs) == "table" then
        return #rs
    else
        return 0
    end
end

-- Recupera veicoli posseduti da un giocatore
function FindPlayerVehicles(id, cb)
    local vehicles = {}
    MySQL.Async.fetchAll("SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier", { ["@identifier"] = id }, function(rs)
        for _, v in pairs(rs) do
            local vehicle = json.decode(v.vehicle)
            table.insert(vehicles, { vehicle = vehicle, plate = v.plate })
        end
        cb(vehicles)
    end)
end

-- Recupera veicoli parcheggiati da un giocatore
function FindPlayerVehicles2(id, cb)
    local vehicles = {}
    MySQL.Async.fetchAll("SELECT * FROM `car_parking` WHERE `owner` = @identifier", { ["@identifier"] = id }, function(rs)
        for _, v in pairs(rs) do
            local vehicle = json.decode(v.data)
            table.insert(vehicles, { vehicle = vehicle, plate = v.plate })
        end
        cb(vehicles)
    end)
end

-- Aggiorna veicoli in un parcheggio e li manda al client
function RefreshVehicles(xPlayer, src, parkingName)
    if src == nil then
        src = -1
    end

    local vehicles, nameList = {}, {}

    -- Recupera i nomi dei giocatori
    local nrs
    if Config.UsingOldESX then
        nrs = MySQL.Sync.fetchAll("SELECT `identifier`, `name` FROM `users`")
        for _, v in pairs(nrs) do
            nameList[v.identifier] = v.name
        end
    else
        nrs = MySQL.Sync.fetchAll("SELECT `identifier`, `firstname`, `lastname` FROM `users`")
        for _, v in pairs(nrs) do
            nameList[v.identifier] = ("%s %s"):format(v.firstname, v.lastname)
        end
    end

    -- Recupera i veicoli parcheggiati
    local querySQL, queryArg = "SELECT * FROM `car_parking`", {}
    if parkingName ~= nil then
        querySQL = "SELECT * FROM `car_parking` WHERE `parking` = @parkingName"
        queryArg = { ["@parkingName"] = parkingName }
    end

    MySQL.Async.fetchAll(querySQL, queryArg, function(rs)
        for _, v in pairs(rs) do
            local vehicle = json.decode(v.data)
            local fee = math.floor(((os.time() - v.time) / 86400) * Config.ParkingLocations[v.parking].fee)
            if fee < 0 then
                fee = 0
            end

            table.insert(vehicles, {
                vehicle = vehicle,
                plate = v.plate,
                fee = fee,
                owner = v.owner,
                name = nameList[v.owner] or "Sconosciuto",
            })
        end
        TriggerClientEvent("esx_realparking:refreshVehicles", src, vehicles)
    end)
end

--[[ =========================================================
    EVENTI & CALLBACK
========================================================= ]]

-- Refresh veicoli richiesto dal client
RegisterServerEvent("esx_realparking:refreshVehicles")
AddEventHandler("esx_realparking:refreshVehicles", function(parkingName)
    local xPlayer = ESX.GetPlayerFromId(source)
    RefreshVehicles(xPlayer, source, parkingName)
end)

-- Salvataggio veicolo in parcheggio
ESX.RegisterServerCallback("esx_realparking:saveCar", function(source, cb, vehicleData)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = vehicleData.props.plate
    local isFound = false

    FindPlayerVehicles(xPlayer.identifier, function(vehicles)
        for _, v in pairs(vehicles) do
            if type(v.plate) ~= "nil" and string.trim(plate) == string.trim(v.plate) then
                isFound = true
            end
        end

        if GetVehicleNumOfParking(vehicleData.parking) >= Config.ParkingLocations[vehicleData.parking].maxcar then
            return cb({ status = false, message = _U("parking_full") })
        elseif isFound then
            MySQL.Async.fetchAll("SELECT * FROM `car_parking` WHERE `owner` = @identifier AND `plate` = @plate", {
                ["@identifier"] = xPlayer.identifier,
                ["@plate"] = plate,
            }, function(rs)
                if rs and #rs > 0 then
                    cb({ status = false, message = _U("already_parking") })
                else
                    -- Inserisci veicolo nel parcheggio
                    MySQL.Async.execute("INSERT INTO `car_parking` (`owner`, `plate`, `data`, `time`, `parking`) VALUES (@owner, @plate, @data, @time, @parking)", {
                        ["@owner"] = xPlayer.identifier,
                        ["@plate"] = plate,
                        ["@data"] = json.encode(vehicleData),
                        ["@time"] = os.time(),
                        ["@parking"] = vehicleData.parking,
                    })

                    -- Aggiorna stato del veicolo
                    MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored` = 2, `vehicle` = @vehicle, `parking` = @parking WHERE `owner` = @owner AND `plate` = @plate", {
                        ["@owner"] = xPlayer.identifier,
                        ["@vehicle"] = json.encode(vehicleData.props),
                        ["@plate"] = plate,
                        ["@parking"] = vehicleData.parking,
                    })

                    cb({ status = true, message = _U("car_saved") })

                    Wait(100)
                    TriggerClientEvent("esx_realparking:addVehicle", -1, {
                        vehicle = vehicleData,
                        plate = plate,
                        fee = 0.0,
                        owner = xPlayer.identifier,
                        name = xPlayer.getName(),
                    }, xPlayer.source)
                end
            end)
        else
            cb({ status = false, message = _U("not_your_car") })
        end
    end)
end)

-- Richiesta di prendere un veicolo dal parcheggio
ESX.RegisterServerCallback("esx_realparking:driveCar", function(source, cb, vehicleData)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = vehicleData.plate
    local isFound = false

    FindPlayerVehicles2(xPlayer.identifier, function(vehicles)
        for _, v in pairs(vehicles) do
            if type(v.plate) ~= "nil" and string.trim(plate) == string.trim(v.plate) then
                isFound = true
            end
        end

        if not isFound then
            return cb({ status = false, message = _U("not_your_car") })
        end

        MySQL.Async.fetchAll("SELECT * FROM `car_parking` WHERE `owner` = @identifier AND `plate` = @plate", {
            ["@identifier"] = xPlayer.identifier,
            ["@plate"] = plate,
        }, function(rs)
            if rs and #rs > 0 and rs[1] then
                local fee = math.floor(((os.time() - rs[1].time) / 86400) * Config.ParkingLocations[rs[1].parking].fee)
                local playerCash = xPlayer.getMoney()
                local parkingCard = xPlayer.getInventoryItem("parkingcard").count

                if parkingCard > 0 then
                    fee = 0
                end

                if playerCash >= fee then
                    xPlayer.removeMoney(fee)
                    MySQL.Async.execute("DELETE FROM `car_parking` WHERE `plate` = @plate AND `owner` = @identifier", {
                        ["@plate"] = plate,
                        ["@identifier"] = xPlayer.identifier,
                    })
                    MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored` = 0 WHERE `plate` = @plate", { ["@plate"] = plate })

                    cb({
                        status = true,
                        message = string.format(_U("pay_success", fee)),
                        vehData = json.decode(rs[1].data),
                    })

                    TriggerClientEvent("esx_realparking:deleteVehicle", -1, { plate = plate })
                else
                    cb({ status = false, message = _U("not_enough_money") })
                end
            else
                cb({ status = false, message = _U("invalid_car") })
            end
        end)
    end)
end)

-- Se la polizia sequestra un veicolo
ESX.RegisterServerCallback("esx_realparking:impoundVehicle", function(source, cb, vehicleData)
    local plate = vehicleData.plate

    MySQL.Async.fetchAll("SELECT * FROM `car_parking` WHERE `plate` = @plate", {
        ["@plate"] = plate,
    }, function(rs)
        if rs and #rs > 0 and rs[1] then
            print(("[REALPARKING] Police impound vehicle: %s owner: %s"):format(vehicleData.plate, rs[1].owner))

            MySQL.Async.execute("DELETE FROM `car_parking` WHERE `plate` = @plate AND `owner` = @identifier", {
                ["@plate"] = plate,
                ["@identifier"] = rs[1].owner,
            })
            MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored` = 0 WHERE `plate` = @plate", { ["@plate"] = plate })

            cb({ status = true })
            TriggerClientEvent("esx_realparking:deleteVehicle", -1, { plate = plate })
        else
            cb({ status = false, message = _U("invalid_car") })
        end
    end)
end)

-- Identificatore giocatore
ESX.RegisterServerCallback("esx_realparking:getPlayerIdentifier", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier then
        cb(xPlayer.identifier)
    else
        print("[RealParking][ERROR] Failed to get the player identifier!")
        cb(nil)
    end
end)
