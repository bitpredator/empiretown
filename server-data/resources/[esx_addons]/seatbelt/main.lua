local isUiOpen = false
local speedBuffer = {}
local velBuffer = {}
local beltOn = false
local wasInCar = false
local notifIn = false
local notifOut = false

function drawUI(x, y, width, height, scale, text, r, g, b, a, center)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextCentre(center)
    --SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

local function drawRect(x, y, width, height, color)
    DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
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
        local car = GetVehiclePedIsIn(ped)

        if IsPedSittingInAnyVehicle(ped) then
            if not notifIn then
                TriggerEvent("pNotify:SendNotification", {
                    text = "<b style='color:#7b9ee2'>Premi</b> <b style='color:#1e90ff'>B</b> <b style='color:#7b9ee2'>per allacciare la cintura</b>",
                    type = "success",
                    queue = "global",
                    timeout = 4000,
                    layout = "bottomcenter",
                    close = "gta_effects_fade_out",
                })
                notifIn = true
            end
        else
            notifIn = false
        end

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
        local car = GetVehiclePedIsIn(ped)

        if car ~= 0 and (wasInCar or IsCar(car)) then
            wasInCar = true
            if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
                    displayWindow = "true",
                })
                isUiOpen = true
            end

            if beltOn then
                DisableControlAction(0, 75)
            end

            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)

            if speedBuffer[2] ~= nil and not beltOn and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > 19.25 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                local co = GetEntityCoords(ped)
                local fw = Fwv(ped)
                SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                Citizen.Wait(1)
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
            end

            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)
            local speed = GetEntitySpeed(car)

            if IsControlJustReleased(0, 29) and GetLastInputMethod(0) and speed < 10 then
                beltOn = not beltOn
                if beltOn then
                    ProgressBar("ALLACCIAMENTO CINTURA IN CORSO...", 30)
                    Wait(3750)

                    TriggerEvent("pNotify:SendNotification", { text = "Cintura Allacciata", type = "success", timeout = 1400, layout = "centerLeft" })

                    SendNUIMessage({
                        displayWindow = "false",
                    })
                    isUiOpen = true
                else
                    ProgressBar("SLACCIAMENTO CINTURA IN CORSO...", 30)
                    TriggerEvent("pNotify:SendNotification", { text = "Cintura Slacciata", type = "error", timeout = 1400, layout = "centerLeft" })

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
            drawUI(0.910, 1.375, 1.0, 1.0, 0.55, progress_bar_text, 255, 255, 255, 255, false)
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
