---@diagnostic disable: undefined-global
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

local labels = {}
local craftingQueue = {}
local job = ""
local grade = 0
ESX = exports["es_extended"]:getSharedObject()

-- Inizializzazione
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end

    job = ESX.GetPlayerData().job.name
    grade = ESX.GetPlayerData().job.grade

    ESX.TriggerServerCallback("bpt_crafting:getItemNames", function(info)
        labels = info
    end)

    -- Blip dei workbench
    for _, v in ipairs(Config.Workbenches) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords[1], v.coords[2], v.coords[3])
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(j)
    job = j.name
    grade = j.grade
end)

function IsNearWorkbench()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for _, v in ipairs(Config.Workbenches) do
        if #(coords - v.coords) < v.radius then
            return true
        end
    end
    return false
end

-- Loop coda crafting
CreateThread(function()
    while true do
        Wait(1000)
        if craftingQueue[1] and (not Config.CraftingStopWithDistance or IsNearWorkbench()) then
            craftingQueue[1].time = craftingQueue[1].time - 1

            SendNUIMessage({
                type = "addqueue",
                item = craftingQueue[1].item,
                time = craftingQueue[1].time,
                id = craftingQueue[1].id,
            })

            if craftingQueue[1].time <= 0 then
                TriggerServerEvent("bpt_crafting:itemCrafted", craftingQueue[1].item, craftingQueue[1].count)
                table.remove(craftingQueue, 1)
            end
        end
    end
end)

-- Apertura workbench
function OpenWorkbench(val)
    ESX.TriggerServerCallback("bpt_crafting:getXP", function(xp)
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(1000)

        local inv = {}
        for _, v in ipairs(ESX.GetPlayerData().inventory) do
            inv[v.name] = v.count
        end

        local recipes = {}
        if #val.recipes > 0 then
            for _, g in ipairs(val.recipes) do
                recipes[g] = Config.Recipes[g]
            end
        else
            recipes = Config.Recipes
        end

        SendNUIMessage({
            type = "open",
            recipes = recipes,
            names = labels,
            level = xp,
            inventory = inv,
            job = job,
            grade = grade,
            hidecraft = Config.HideWhenCantCraft,
            categories = Config.Categories,
        })
    end)
end

-- Loop interazione workbench
CreateThread(function()
    while true do
        Wait(1)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, v in ipairs(Config.Workbenches) do
            local dst = #(coords - v.coords)
            if dst < 10 then
                DrawText3D(v.coords[1], v.coords[2], v.coords[3] - 0.8, TranslateCap("workbench_hologram"))
            end
            if dst < 2 and IsControlJustReleased(0, Keys["E"]) then
                local open = false
                for _, g in ipairs(v.jobs) do
                    if g == job then
                        open = true
                    end
                end
                if open or #v.jobs == 0 then
                    OpenWorkbench(v)
                else
                    ESX.ShowNotification(TranslateCap("wrong_job"))
                end
            end
        end
    end
end)

-- Evento crafting
RegisterNetEvent("bpt_crafting:craftStart")
AddEventHandler("bpt_crafting:craftStart", function(item)
    if Config.MaxCraftQueue ~= -1 and #craftingQueue >= Config.MaxCraftQueue then
        ESX.ShowNotification(TranslateCap("maximum_limit"))
        return
    end

    local id = math.random(0, 999)
    table.insert(craftingQueue, { time = Config.Recipes[item].Time, item = item, count = 1, id = id })

    -- Notifica NUI
    SendNUIMessage({ type = "crafting", item = item })
    SendNUIMessage({ type = "addqueue", item = item, time = Config.Recipes[item].Time, id = id })
end)

-- Messaggi dal server
RegisterNetEvent("bpt_crafting:sendMessage")
AddEventHandler("bpt_crafting:sendMessage", function(msg)
    ESX.ShowNotification(msg)
end)

-- NUI callbacks
RegisterNUICallback("close", function(data, cb)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("craft", function(data, cb)
    local item = data.item
    TriggerServerEvent("bpt_crafting:craft", item, false)
    cb("ok")
end)

-- Notifiche
function ESX.ShowNotification(msg)
    exports["mythic_notify"]:SendAlert("inform", msg)
end

-- DrawText3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100
    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextCentre(true)
        SetTextDropshadow(1, 1, 1, 1, 255)
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        GetTextScaleHeight(0.55 * scale, 4)
        EndTextCommandGetWidth(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
