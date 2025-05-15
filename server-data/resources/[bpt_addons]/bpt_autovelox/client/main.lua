local currentAutovelox = nil
local blockedVehiclePlates = {}

RegisterNetEvent("autovelox:updatePosition")
AddEventHandler("autovelox:updatePosition", function(data)
    currentAutovelox = data
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if currentAutovelox then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local dist = #(coords - vector3(currentAutovelox.x, currentAutovelox.y, currentAutovelox.z))

            if dist < 50.0 then
                if IsPedInAnyVehicle(playerPed, false) then
                    local veh = GetVehiclePedIsIn(playerPed, false)
                    local speed = GetEntitySpeed(veh) * 3.6
                    if speed > currentAutovelox.speedLimit then
                        local plate = GetVehicleNumberPlateText(veh)
                        TriggerServerEvent("autovelox:applyFine", math.floor(speed), plate)
                        Citizen.Wait(30000)
                    end
                end
            end
        end
    end
end)

-- Blocca il veicolo (non utilizzabile)
RegisterNetEvent("autovelox:blockVehicle")
AddEventHandler("autovelox:blockVehicle", function(plate)
    blockedVehiclePlates[plate] = true
    Citizen.CreateThread(function()
        while blockedVehiclePlates[plate] do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                local veh = GetVehiclePedIsIn(playerPed, false)
                local currentPlate = GetVehicleNumberPlateText(veh)
                if currentPlate == plate then
                    DisableControlAction(0, 71, true) -- Accelerate
                    DisableControlAction(0, 72, true) -- Brake
                    DisableControlAction(0, 75, true) -- Exit vehicle
                    DisableControlAction(27, 75, true) -- Exit vehicle controller
                    SetVehicleEngineOn(veh, false, true, true)
                end
            end
        end
    end)
end)

-- Sblocca veicolo
RegisterNetEvent("autovelox:unblockVehicle")
AddEventHandler("autovelox:unblockVehicle", function(plate)
    blockedVehiclePlates[plate] = false
end)

-- Controlla al momento di entrare nel veicolo se è bloccato
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed, false)
            local plate = GetVehicleNumberPlateText(veh)
            ESX.TriggerServerCallback("autovelox:isVehicleBlocked", function(isBlocked)
                if isBlocked and not blockedVehiclePlates[plate] then
                    -- Forza uscita dal veicolo
                    TaskLeaveVehicle(playerPed, veh, 0)
                    TriggerEvent("chat:addMessage", { args = { "^1Sistema Multa", "Questo veicolo è pignorato per multe non pagate." } })
                end
            end, plate)
        end
    end
end)

-- Comando per pagare multa
RegisterCommand("pagaMulta", function()
    TriggerServerEvent("autovelox:payFineAfter")
end)
