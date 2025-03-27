ESX = exports["es_extended"]:getSharedObject()

-- Evento per scommettere e verificare i fondi del giocatore
RegisterServerEvent("bpt_slots:BetsAndMoney")
AddEventHandler("bpt_slots:BetsAndMoney", function(bets)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not xPlayer then return end

    if bets >= 50 and bets % 50 == 0 then
        if xPlayer.getMoney() >= bets then
            xPlayer.removeMoney(bets)
            TriggerClientEvent("bpt_slots:UpdateSlots", _source, bets)
        else
            TriggerClientEvent('esx:showNotification', _source, TranslateCap('no_money'))
            if Config.SittingEnabled then
                TriggerClientEvent("bpt_slots:unsit", _source)
            end
        end
    else
        TriggerClientEvent('esx:showNotification', _source, TranslateCap('error_bet'))
        if Config.SittingEnabled then
            TriggerClientEvent("bpt_slots:unsit", _source)
        end
    end
end)

-- Evento per pagare le vincite
RegisterServerEvent("bpt_slots:PayOutRewards")
AddEventHandler("bpt_slots:PayOutRewards", function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not xPlayer then return end

    amount = tonumber(amount)
    if amount and amount > 0 then
        xPlayer.addMoney(amount)
        TriggerClientEvent('esx:showNotification', _source, TranslateCap('exit_machine', amount))
    else
        TriggerClientEvent('esx:showNotification', _source, TranslateCap('lose_money'))
    end
end)

-- Gestione delle postazioni occupate alle slot machine
local SeatsTaken = {}

RegisterServerEvent('bpt_slots:takePlace')
AddEventHandler('bpt_slots:takePlace', function(object)
    if not SeatsTaken[object] then
        SeatsTaken[object] = true
    end
end)

RegisterServerEvent('bpt_slots:leavePlace')
AddEventHandler('bpt_slots:leavePlace', function(object)
    SeatsTaken[object] = nil
end)

ESX.RegisterServerCallback('bpt_slots:getPlace', function(source, cb, id)
    cb(SeatsTaken[id] or false)
end)
