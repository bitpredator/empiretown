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

ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local isArresting = false
local isBeingArrested = false
local animDict = "mp_arrest_paired"
local animCop = "cop_p2_back_left"
local animCrook = "crook_p2_back_left"

-- Player Load
RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
end)

-- When player is being arrested (criminal side)
RegisterNetEvent("esx_cuffanimation:arrested", function(targetId)
    isBeingArrested = true

    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    AttachEntityToEntity(playerPed, targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
    TaskPlayAnim(playerPed, animDict, animCrook, 8.0, -8.0, 5500, 33, 0, false, false, false)

    Wait(950)
    DetachEntity(playerPed, true, false)

    isBeingArrested = false
end)

-- When player performs the arrest (cop side)
RegisterNetEvent("esx_cuffanimation:arrest", function()
    local playerPed = PlayerPedId()

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    TaskPlayAnim(playerPed, animDict, animCop, 8.0, -8.0, 5500, 33, 0, false, false, false)

    Wait(3000)
    isArresting = false
end)
