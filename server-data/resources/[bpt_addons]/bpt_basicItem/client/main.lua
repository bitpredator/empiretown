local ESX = exports["es_extended"]:getSharedObject()

local function showCard(cardType)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local myServerId = GetPlayerServerId(PlayerId())

    if closestDistance ~= -1 and closestDistance <= 2.0 then
        local targetServerId = GetPlayerServerId(closestPlayer)
        ESX.ShowNotification(("Hai mostrato la %s a %s"):format(cardType, GetPlayerName(closestPlayer)))
        TriggerServerEvent("bpt_idcard:open", myServerId, targetServerId, cardType)
    else
        TriggerServerEvent("bpt_idcard:open", myServerId, myServerId, cardType)
    end
end

RegisterNetEvent("bpt_idcard:useID", function()
    print("DEBUG: Evento ricevuto correttamente - uso IDCARD")
    showCard("id")
end)

RegisterNetEvent("bpt_idcard:useDMV", function()
    showCard("driver")
end)
RegisterNetEvent("bpt_idcard:useWeapon", function()
    showCard("weapon")
end)
