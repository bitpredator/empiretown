local closestDistance, closestPlayer, playerReceiveCard = {}, {}, {}

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("IDCARD:USE")
AddEventHandler("IDCARD:USE", function()
    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestDistance ~= -1 and closestDistance <= 2.0 then
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
    else
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
    end
    Wait(1)
end)

RegisterNetEvent("DMVCARD:USE")
AddEventHandler("DMVCARD:USE", function()
    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestDistance ~= -1 and closestDistance <= 2.0 then
        ESX.ShowNotification((playerReceiveCard):format(GetPlayerName(closestPlayer)))
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), "driver")
    else
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), "driver")
    end
    Wait(1)
end)

RegisterNetEvent("weapon:USE")
AddEventHandler("weapon:USE", function()
    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestDistance ~= -1 and closestDistance <= 2.0 then
        ESX.ShowNotification((playerReceiveCard):format(GetPlayerName(closestPlayer)))
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), "weapon")
    else
        TriggerServerEvent("bpt_idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), "weapon")
    end
    Wait(1)
end)
