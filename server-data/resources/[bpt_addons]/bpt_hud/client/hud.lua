ESX = exports["es_extended"]:getSharedObject()
PlayerData = {}

local ShowHUD = true
HUD = {}


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerLoaded = true
    ESX.PlayerData = xPlayer

    Cash = ESX.PlayerData.money
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerLoaded = true
    ESX.PlayerData = xPlayer

    Cash = ESX.PlayerData.money

    PlayerData = xPlayer
    if PlayerData.job.grade_name == "boss" then
        Boss = true
    else
        Boss = false
    end
end)

function Roundxx(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function DrawRct2(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 4, y + height / 1, width, height, r, g, b, a)
end

function DrawTxt3(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(6)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 5.5, y - height / 20000)
end

RegisterNetEvent("sendWeight")
AddEventHandler("sendWeight", function(mm)
    Weight = mm
end)

RegisterNetEvent("showhud:toggle")
AddEventHandler("showhud:toggle", function(m)
    ShowHUD = m
end)

local rdy = true
function ShowHud()
    ShowHUD = not ShowHUD
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    rdy = true
end)

local faimVal = 0
local soifVal = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        TriggerEvent("bpt_status:getStatus", "hunger", function(status)
            faimVal = status.val / 1000000 * 100
        end)
        TriggerEvent("bpt_status:getStatus", "thirst", function(status)
            soifVal = status.val / 1000000 * 100
        end)
    end
end)

Citizen.CreateThread(function()
    Hea = 200
    while true do
        Citizen.Wait(0)
        if rdy then
            if ShowHUD then
                local myPed = GetPlayerPed(-1)
                local veh = GetVehiclePedIsIn(myPed, true)
                local health = GetEntityHealth(myPed) - 100
                local armor = GetPedArmour(myPed)
                local vitesse = GetEntitySpeed(veh) * 3.6
                local plate = GetVehicleNumberPlateText(veh)
                if health < 0 then
                    health = GetEntityHealth(myPed)
                end
                local armor = GetPedArmour(myPed)
                DrawTxt3(0.200, 0.963, 1.0, 1.0, 0.40, "" .. "❤️", 255, 255, 255, 255) -- -20
                DrawTxt3(0.220, 0.963, 1.0, 1.0, 0.50, "" .. math.ceil(health) .. "", 255, 255, 255, 255)

                DrawTxt3(0.250, 0.963, 1.0, 1.0, 0.40, "" .. "🛡", 255, 255, 255, 255)
                DrawTxt3(0.270, 0.963, 1.0, 1.0, 0.50, "" .. math.ceil(armor) .. "", 255, 255, 255, 255)

                DrawTxt3(0.290, 0.963, 1.0, 1.0, 0.40, "" .. "🍔", 255, 255, 255, 255)
                DrawTxt3(0.310, 0.963, 1.0, 1.0, 0.50, "" .. math.ceil(faimVal) .. "", 255, 255, 255, 255)

                DrawTxt3(0.330, 0.963, 1.0, 1.0, 0.40, "" .. "🥤", 255, 255, 255, 255)
                DrawTxt3(0.350, 0.963, 1.0, 1.0, 0.50, "" .. math.ceil(soifVal) .. "", 255, 255, 255, 255)
            end
        end
    end
end)

function DrawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

SendNUIMessage({ hud = ShowHUD })
