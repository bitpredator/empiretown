--	Sync server events
RegisterNetEvent("wk_wars2x_sync:sendPowerState")
AddEventHandler("wk_wars2x_sync:sendPowerState", function(target, state)
    TriggerClientEvent("wk_wars2x_sync:receivePowerState", target, state)
end)

RegisterNetEvent("wk_wars2x_sync:sendAntennaPowerState")
AddEventHandler("wk_wars2x_sync:sendAntennaPowerState", function(target, state, ant)
    TriggerClientEvent("wk_wars2x_sync:receiveAntennaPowerState", target, state, ant)
end)

RegisterNetEvent("wk_wars2x_sync:sendAntennaMode")
AddEventHandler("wk_wars2x_sync:sendAntennaMode", function(target, ant, mode)
    TriggerClientEvent("wk_wars2x_sync:receiveAntennaMode", target, ant, mode)
end)

RegisterNetEvent("wk_wars2x_sync:sendLockAntennaSpeed")
AddEventHandler("wk_wars2x_sync:sendLockAntennaSpeed", function(target, ant, data)
    TriggerClientEvent("wk_wars2x_sync:receiveLockAntennaSpeed", target, ant, data)
end)

RegisterNetEvent("wk_wars2x_sync:sendLockCameraPlate")
AddEventHandler("wk_wars2x_sync:sendLockCameraPlate", function(target, cam, data)
    TriggerClientEvent("wk_wars2x_sync:receiveLockCameraPlate", target, cam, data)
end)

--	Radar data sync server events
RegisterNetEvent("wk_wars2x_sync:requestRadarData")
AddEventHandler("wk_wars2x_sync:requestRadarData", function(target)
    TriggerClientEvent("wk_wars2x_sync:getRadarDataFromDriver", target, source)
end)

RegisterNetEvent("wk_wars2x_sync:sendRadarDataForPassenger")
AddEventHandler("wk_wars2x_sync:sendRadarDataForPassenger", function(playerFor, data)
    TriggerClientEvent("wk_wars2x_sync:receiveRadarData", playerFor, data)
end)

RegisterNetEvent("wk_wars2x_sync:sendUpdatedOMData")
AddEventHandler("wk_wars2x_sync:sendUpdatedOMData", function(playerFor, data)
    TriggerClientEvent("wk_wars2x_sync:receiveUpdatedOMData", playerFor, data)
end)
