-- Function to park unsaved boats
function ParkBoats()
    MySQL.update("UPDATE owned_vehicles SET `stored` = true WHERE `stored` = false AND type = @type", {
        ["@type"] = "boat",
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print(("[^2INFO^7] Stored ^5%s^7 %s !"):format(rowsChanged, rowsChanged > 1 and "boats" or "boat"))
        end
    end)
end

MySQL.ready(function()
    ParkBoats()
end)

-- Callback for buying a boat
ESX.RegisterServerCallback("bpt_boat:buyBoat", function(source, cb, vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = getPriceFromModel(vehicleProps.model)

    -- If price is 0 (model not found), report exploit attempt
    if price == 0 then
        print(("[^2INFO^7] Player ^5%s^7 Attempted To Exploit Shop"):format(xPlayer.source))
        cb(false)
        return
    end

    -- Check if the player has enough money
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price, "Boat Purchase")

        MySQL.update("INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (@owner, @plate, @vehicle, @type, @stored)", {
            ["@owner"] = xPlayer.identifier,
            ["@plate"] = vehicleProps.plate,
            ["@vehicle"] = json.encode(vehicleProps),
            ["@type"] = "boat",
            ["@stored"] = true,
        }, function(rowsChanged)
            cb(true)
        end)
    else
        cb(false)
    end
end)

-- Event to remove the boat from the garage
RegisterServerEvent("bpt_boat:takeOutVehicle")
AddEventHandler("bpt_boat:takeOutVehicle", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.update("UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate", {
        ["@stored"] = false,
        ["@owner"] = xPlayer.identifier,
        ["@plate"] = plate,
    }, function(rowsChanged)
        if rowsChanged == 0 then
            print(("[^2INFO^7] Player ^5%s^7 Attempted To Exploit Garage"):format(xPlayer.source))
        end
    end)
end)

-- Callback to park the boat
ESX.RegisterServerCallback("bpt_boat:storeVehicle", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.update("UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate", {
        ["@stored"] = true,
        ["@owner"] = xPlayer.identifier,
        ["@plate"] = plate,
    }, function(rowsChanged)
        cb(rowsChanged)
    end)
end)

-- Callback to get boats in garage
ESX.RegisterServerCallback("bpt_boat:getGarage", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.query("SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND type = @type AND `stored` = @stored", {
        ["@owner"] = xPlayer.identifier,
        ["@type"] = "boat",
        ["@stored"] = true,
    }, function(result)
        local vehicles = {}

        for i = 1, #result do
            table.insert(vehicles, result[i].vehicle)
        end

        cb(vehicles)
    end)
end)

-- Callback to purchase boat license
ESX.RegisterServerCallback("bpt_boat:buyBoatLicense", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Config.LicensePrice then
        xPlayer.removeMoney(Config.LicensePrice, "Boat License Purchase")

        TriggerEvent("esx_license:addLicense", source, "boat", function()
            cb(true)
        end)
    else
        cb(false)
    end
end)

-- Function to get the price of the boat based on the model
function getPriceFromModel(model)
    local hashedModel = joaat(model)

    for _, v in ipairs(Config.Vehicles) do
        if hashedModel == joaat(v.model) then
            return v.price
        end
    end

    return 0
end
