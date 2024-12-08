---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("esx_contract:getVehicle")
AddEventHandler("esx_contract:getVehicle", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer ~= -1 and playerDistance <= 3.0 then
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local vehiclecoords = GetEntityCoords(vehicle)
        local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
        if DoesEntityExist(vehicle) and (vehDistance <= 3) then
            local vehProps = ESX.Game.GetVehicleProperties(vehicle)
            ESX.ShowNotification(TranslateCap("writingcontract", vehProps.plate))
            TriggerServerEvent("esx_clothes:sellVehicle", GetPlayerServerId(closestPlayer), vehProps.plate)
        else
            ESX.ShowNotification(TranslateCap("nonearby"))
        end
    else
        ESX.ShowNotification(TranslateCap("nonearbybuyer"))
    end
end)

RegisterNetEvent("esx_contract:showAnim")
AddEventHandler("esx_contract:showAnim", function(player)
    LoadAnimDict("anim@amb@nightclub@peds@")
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, false)
    Citizen.Wait(20000)
    ClearPedTasks(PlayerPedId())
end)

function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end
