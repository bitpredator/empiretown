local isUiOpen = false
local beltOn = false
local wasInCar = false

--- Controlla se il veicolo è di tipo compatibile con la cintura
local function IsEligibleVehicle(veh)
    local class = GetVehicleClass(veh)
    return (class >= 0 and class <= 7) or (class >= 9 and class <= 12) or (class >= 17 and class <= 20)
end

--- Mostra una notifica lato client (usando ESX)
local function ShowSeatbeltNotification(msg)
    TriggerEvent("ESX:Notify", "info", 3000, msg)
end

--- Thread principale
CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and IsEligibleVehicle(vehicle) then
            -- Giocatore è dentro un'auto idonea
            if not isUiOpen and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({ displayWindow = "true" })
                isUiOpen = true
            end

            -- Gestione cintura
            if beltOn then
                DisableControlAction(0, 75, true) -- Disabilita ESCI dal veicolo
            else
                EnableControlAction(0, 75, true)
            end

            -- Premi B per attivare/disattivare la cintura
            if IsControlJustReleased(0, 29) and GetLastInputMethod(0) and GetEntitySpeed(vehicle) < 10 then
                beltOn = not beltOn
                if beltOn then
                    ShowSeatbeltNotification("Cintura allacciata")
                    SendNUIMessage({ displayWindow = "false" })
                else
                    ShowSeatbeltNotification("Cintura slacciata")
                    SendNUIMessage({ displayWindow = "true" })
                    EnableControlAction(0, 75, true)
                end
            end

            wasInCar = true
        elseif wasInCar then
            -- Uscito dall'auto
            wasInCar = false
            beltOn = false
            if isUiOpen then
                SendNUIMessage({ displayWindow = "false" })
                isUiOpen = false
            end
        end
    end
end)
