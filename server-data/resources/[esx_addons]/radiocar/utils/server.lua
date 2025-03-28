ESX = exports["es_extended"]:getSharedObject()
CachedOwners = {}

TriggerEvent(Config.ESX, function(esx) ESX = esx end)

function MySQLSyncfetchAll(query, table, cb)
    return MySQL.Sync.fetchAll(query, table, cb)
end

function MySQLAsyncfetchAll(query, table, cb)
    return MySQL.Async.fetchAll(query, table, cb)
end

function MySQLSyncexecute(query, table, cb)
    return MySQL.Sync.execute(query, table, cb)
end

function MySQLAsyncexecute(query, table, cb)
    return MySQL.Async.execute(query, table, cb)
end

function IsVehiclePlayer(source, licensePlate, cb)
    MySQLAsyncfetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {
        ['@plate'] = licensePlate
    }, function(result)
        cb(#result > 0)
    end)
end

RegisterNetEvent("radiocar:openUI")
AddEventHandler("radiocar:openUI", function(spz)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if not xPlayer or not spz then
        print("[radiocar] Errore: xPlayer o targa non valida!")
        return
    end

    if Config.OnlyCarWhoHaveRadio and not exports.radiocar:HasCarRadio(spz) then
        return
    end

    if Config.OnlyOwnerOfTheCar or Config.OnlyOwnedCars then
        if not CachedOwners[spz] then
            local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", { ['@plate'] = spz })

            if #result == 0 then
                print("[radiocar] Nessun veicolo trovato per la targa:", spz)
                return
            end

            CachedOwners[spz] = result[1]
        end

        if Config.OnlyOwnerOfTheCar and CachedOwners[spz].owner ~= xPlayer.identifier then
            print("[radiocar] Accesso negato: Il giocatore non è il proprietario dell'auto!")
            return
        end
    end

    TriggerClientEvent("radiocar:openUI", player)
end)
