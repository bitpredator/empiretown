RegisterServerEvent('anticheat:banPlayer')
AddEventHandler('anticheat:banPlayer', function(reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        -- Salva le informazioni del giocatore bannato nel database
        MySQL.Async.execute('INSERT INTO banned_players (identifier, reason, timestamp) VALUES (@identifier, @reason, @timestamp)', {
            ['@identifier'] = xPlayer.identifier,
            ['@reason'] = reason,
            ['@timestamp'] = os.time()
        }, function(rowsChanged)
            print(('Giocatore %s bannato per %s'):format(xPlayer.identifier, reason))
            DropPlayer(_source, 'Sei stato bannato per ' .. reason)
        end)
    end
end)

RegisterServerEvent('anticheat:checkAdmin')
AddEventHandler('anticheat:checkAdmin', function(playerId, reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        local isAdmin = false
        for _, adminId in ipairs(AdminList) do
            if xPlayer.identifier == adminId then
                isAdmin = true
                break
            end
        end

        if not isAdmin then
            TriggerEvent('anticheat:banPlayer', reason)
        end
    end
end)