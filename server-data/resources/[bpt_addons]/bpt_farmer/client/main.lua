local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118,
}

local incollect = false

ESX = exports["es_extended"]:getSharedObject()
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

function DrawText3D(x, y, z, text, scale)
    local _, _x, _y = World3dToScreen2d(x, y, z)

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 90)
end

-- collection potato
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(coords, 2233.21, 5081.3, 48.08, true) < 10.0 then
            DrawText3D(2233.21, 5081.3, 48.08, TranslateCap("press_collect"), 0.4)
            if ESX.GetPlayerData().job.name then
                if GetDistanceBetweenCoords(coords, 2233.21, 5081.3, 48.08, true) < 5.0 then
                    if IsControlJustReleased(0, Keys["E"]) then
                        if incollect == false then
                            Collectionpotato()
                        end
                    end
                end
            end
        end
    end
end)

-- collection cotton
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(coords, 1582.035156, 2167.279053, 79.307007, true) < 10.0 then
            DrawText3D(1582.035156, 2167.279053, 79.307007, TranslateCap("press_collect"), 0.4)
            if ESX.GetPlayerData().job.name then
                if GetDistanceBetweenCoords(coords, 1582.035156, 2167.279053, 79.307007, true) < 5.0 then
                    if IsControlJustReleased(0, Keys["E"]) then
                        if incollect == false then
                            Collectioncotton()
                        end
                    end
                end
            end
        end
    end
end)

-- collection apple
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(coords, 2343.850586, 4756.087891, 34.806641, true) < 10.0 then
            DrawText3D(2343.850586, 4756.087891, 34.806641, TranslateCap("press_collect"), 0.4)
            if ESX.GetPlayerData().job.name then
                if GetDistanceBetweenCoords(coords, 2343.850586, 4756.087891, 34.806641, true) < 5.0 then
                    if IsControlJustReleased(0, Keys["E"]) then
                        if incollect == false then
                            Collectionapple()
                        end
                    end
                end
            end
        end
    end
end)

-- collection grain
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(coords, 2607.942871, 4399.490234, 40.973633, true) < 10.0 then
            DrawText3D(2607.942871, 4399.490234, 40.973633, TranslateCap("press_collect"), 0.4)
            if ESX.GetPlayerData().job.name then
                if GetDistanceBetweenCoords(coords, 2607.942871, 4399.490234, 40.973633, true) < 5.0 then
                    if IsControlJustReleased(0, Keys["E"]) then
                        if incollect == false then
                            Collectiongrain()
                        end
                    end
                end
            end
        end
    end
end)

local blips = {
    { title = "Potato harvest", colour = 0, id = 398, x = 2233.21, y = 5081.3, z = 48.08 },
    { title = "Cotton harvesting", colour = 0, id = 398, x = 1582.035156, y = 2167.279053, z = 79.307007 },
    { title = "Apple picking", colour = 0, id = 398, x = 2343.850586, y = 4756.087891, z = 34.806641 },
    { title = "Wheat harvest", colour = 0, id = 398, x = 2607.942871, y = 4399.490234, z = 40.973633 },
}

CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.85)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

--potato
function Collectionpotato()
    TriggerServerEvent("farmer:collectionpotato")
    exports["esx_notify"]:Notify("info", 3000, TranslateCap("collection_progress"))
    incollect = true
    Wait(6000)
    incollect = false
end

-- cotton
function Collectioncotton()
    TriggerServerEvent("farmer:collectioncotton")
    exports["esx_notify"]:Notify("info", 3000, TranslateCap("collection_progress"))
    incollect = true
    Wait(6000)
    incollect = false
end

-- apple
function Collectionapple()
    TriggerServerEvent("farmer:collectionapple")
    exports["esx_notify"]:Notify("info", 3000, TranslateCap("collection_progress"))
    incollect = true
    Wait(6000)
    incollect = false
end

-- grain
function Collectiongrain()
    TriggerServerEvent("farmer:collectiongrain")
    exports["esx_notify"]:Notify("info", 3000, TranslateCap("collection_progress"))
    incollect = true
    Wait(6000)
    incollect = false
end
