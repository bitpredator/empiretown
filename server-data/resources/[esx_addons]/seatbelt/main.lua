local isUiOpen = false
local speedBuffer = {}
local velBuffer = {}
local beltOn = false
local wasInCar = false

function DrawUI(x, y, width, height, scale, text, r, g, b, a, center)
    SetTextFont(4)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextCentre(center)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped, false)

        if car ~= 0 and IsCar(car) then
            wasInCar = true
            
            if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({ displayWindow = "true" })
                isUiOpen = true
            end

            if beltOn then
                DisableControlAction(0, 75, true) -- Disabilita uscita se cintura allacciata
            else
                EnableControlAction(0, 75, true) -- Riabilita uscita se cintura slacciata
            end

            if IsControlJustReleased(0, 29) and GetLastInputMethod(0) and GetEntitySpeed(car) < 10 then
                beltOn = not beltOn
                if beltOn then
                    TriggerEvent("ESX:Notify", "info", 3000, "Cintura Allacciata")
                    SendNUIMessage({ displayWindow = "false" })
                else
                    TriggerEvent("ESX:Notify", "info", 3000, "Cintura Slacciata")
                    SendNUIMessage({ displayWindow = "true" })
                    EnableControlAction(0, 75, true) -- Riabilita uscita dopo slacciamento
                end
            end
        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer = {}
            velBuffer = {}
            if isUiOpen == true then
                SendNUIMessage({ displayWindow = "false" })
                isUiOpen = false
            end
        end
    end
end)
