RegisterNetEvent('esx-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('esx-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('esx-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('esx-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('esx-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('esx-radialmenu:client:Result', otherId, isBusy, type)
end)