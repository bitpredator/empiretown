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
    SetTextDropShadow()
    SetTextCentre(center)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then
        hr = 360.0 + hr
    end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped, false)

        if car ~= 0 then
            local speed = GetEntitySpeed(car)
            if (speed >= 0 and speed <= 40) and not beltOn and IsCar(car) then
                PlaySound(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false, 0, true)
                Citizen.Wait(500)
                PlaySound(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false, 0, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped, false)

        if car ~= 0 and (wasInCar or IsCar(car)) then
            wasInCar = true
            if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
                    displayWindow = "true",
                })
                isUiOpen = true
            end

            if beltOn then
                DisableControlAction(0, 75, true)
            end

            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)

            if speedBuffer[2] ~= nil and not beltOn and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > 19.25 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                local co = GetEntityCoords(ped)
                local fw = Fwv(ped)
                SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true, false)
                SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                Citizen.Wait(1)
                SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
            end

            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)
            local speed = GetEntitySpeed(car)

            if IsControlJustReleased(0, 29) and GetLastInputMethod(0) and speed < 10 then
                beltOn = not beltOn
                if beltOn then
                    ProgressBar("ALLACCIAMENTO CINTURA IN CORSO...", 30)
                    Wait(3750)
                    TriggerEvent("ESX:Notify", "info", 3000, "Cintura Allacciata")

                    SendNUIMessage({
                        displayWindow = "false",
                    })
                    isUiOpen = true
                else
                    ProgressBar("SLACCIAMENTO CINTURA IN CORSO...", 30)
                    TriggerEvent("ESX:Notify", "info", 3000, "Cintura Slacciata")

                    SendNUIMessage({
                        displayWindow = "true",
                    })
                    isUiOpen = true
                end
            end
        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
                    displayWindow = "false",
                })
                isUiOpen = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPlayerDead(PlayerId()) and isUiOpen == true then
            SendNUIMessage({
                displayWindow = "false",
            })
            isUiOpen = false
        end
    end
end)

local progress_time = 0.20
local progress_bar = false
local progress_bar_duration = 20
local progress_bar_text = ""

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(progress_bar_duration)
        if progress_time > 0 then
            progress_time = progress_time - 0.002
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if progress_bar then
            DrawRect(0.50, 0.90, 0.20, 0.05, 0, 0, 0, 100)
            DrawUI(0.910, 1.375, 1.0, 1.0, 0.55, progress_bar_text, 255, 255, 255, 255, false)
            if progress_time > 0 then
                DrawRect(0.50, 0.90, 0.20 - progress_time, 0.05, 75, 156, 237, 225)
            elseif progress_time < 1 and progress_bar then
                progress_bar = false
            end
        end
    end
end)

function ProgressBar(text, time)
    progress_bar_text = text
    progress_bar_duration = time
    progress_time = 0.20
    progress_bar = true
end
