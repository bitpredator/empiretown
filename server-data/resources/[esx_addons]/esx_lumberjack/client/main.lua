local trees = {}
local duty = false
local model

Citizen.CreateThread(function()
    lib.callback("map_lumberjack:getTreesWithData", false, function(data)
        SetTrees(data)
    end)
end)

function SetTrees(list)
    for k, v in pairs(trees) do
        DeleteObject(v.obj)
        RemoveBlip(v.blip)
    end

    trees = list

    local hash = GetHashKey(Config.TreeModel)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    for k, v in pairs(trees) do
        if v.health > 0 then
            local obj = CreateObject(hash, v.coords.x, v.coords.y, v.coords.z, false, true, false)
            FreezeEntityPosition(obj, true)

            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 5)
            SetBlipScale(blip, 0.5)
            SetBlipHighDetail(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Tree")
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 4)

            trees[k].obj = obj
            trees[k].blip = blip
        end
    end

    SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent("map_lumberjack:syncTrees", function(list)
    SetTrees(list)
end)

-- TODO: Improve 3d text optimization
Citizen.CreateThread(function()
    local sleep
    while true do
        Citizen.Wait(sleep)
        if duty then
            local coords = GetEntityCoords(PlayerPedId())
            local isNear = false
            for _, v in pairs(trees) do
                local pos = vector3(v.coords.x, v.coords.y, v.coords.z)
                local dist = #(coords - pos)
                if (dist < 10) and v.health > 0 then
                    sleep = sleep
                    isNear = true
                    Draw3DText(pos.x, pos.y, pos.z + 2, 0.35, "~w~Health: ~o~" .. v.health .. "% ~n~ ~w~[~g~G~w~] ~w~Cut a tree")
                end
            end

            if not isNear then
                sleep = sleep
            end
        end
    end
end)

local animDict = "melee@hatchet@streamed_core"
local animName = "plyr_rear_takedown_b"
RegisterCommand("cutatree", function()
    if not duty then
        return false
    end
    local closest = nil
    local coords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(trees) do
        local pos = vector3(v.coords.x, v.coords.y, v.coords.z)
        local dist = #(coords - pos)
        if dist < 3 and v.health > 0 then
            closest = k
        end
    end
    if closest == nil or IsEntityPlayingAnim(PlayerPedId(), animDict, animName, 3) then
        return false
    end

    lib.callback("map_lumberjack:hasItem", false, function(data)
        if not data then
            return false
        end

        local model = GetHashKey("prop_tool_fireaxe")
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        local ped = PlayerPedId()
        local axe = CreateObject(model, 0, 0, 0, true, false, false)
        AttachEntityToEntity(axe, ped, GetPedBoneIndex(ped, 0x188E), 0, 0, 0, 0, 0, 0, true, false, true, false, 0, true)

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 8.0, 3000, 0, 0, false, false, false)
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(3000)

        lib.callback("map_lumberjack:makeDamage", false, function(data) end, closest)

        FreezeEntityPosition(PlayerPedId(), false)
        DeleteObject(axe)
    end)
end)

-- DUTY
Citizen.CreateThread(function()
    local sleep = 500
    while true do
        Citizen.Wait(sleep)
        local coords = GetEntityCoords(PlayerPedId())
        local dutyPED = #(coords - vector3(Config.Duty.x, Config.Duty.y, Config.Duty.z))
        if dutyPED < 8 then
            sleep = 5
            MessageWithBackground(vector3(Config.Duty.x, Config.Duty.y, Config.Duty.z + 2), "~INPUT_CONTEXT~ Start working as Lumberjack")
        else
            sleep = 500
        end
    end
end)

RegisterCommand("startLumberjackDuty", function()
    local coords = GetEntityCoords(PlayerPedId())
    local dist = #(coords - vector3(Config.Duty.x, Config.Duty.y, Config.Duty.z))
    if dist > 2 then
        return false
    end

    lib.callback("map_lumberjack:duty", false, function(boolean)
        duty = boolean
        if boolean then
            ESX.ShowNotification(TranslateCap("you_started"))
        else
            ESX.ShowNotification(TranslateCap("you_ended"))
        end
    end)
end)

-- PED
local pedSpawned = false
local ped = nil

if Config.UsePED then
    Citizen.CreateThread(function()
        while true do
            local dist = #(GetEntityCoords(PlayerPedId()) - vector3(Config.Duty.x, Config.Duty.y, Config.Duty.z))
            if dist < 100 then
                if not pedSpawned then
                    local model = GetHashKey(Config.PedModel)
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(10)
                    end
                    ped = CreatePed(4, model, Config.Duty.x, Config.Duty.y, Config.Duty.z, Config.Duty.w, false, false)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, false)
                    SetPedCanRagdollFromPlayerImpact(ped, false)
                    SetPedCanRagdoll(ped, false)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetModelAsNoLongerNeeded(model)
                    pedSpawned = true
                end
            else
                if pedSpawned then
                    DeletePed(ped)
                    pedSpawned = false
                end
            end
            Citizen.Wait(3000)
        end
    end)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeletePed(ped)
        for _, v in pairs(trees) do
            DeleteObject(v.obj)
        end
    end
end)

RegisterKeyMapping("cutatree", "Cut a tree", "keyboard", "g")
RegisterKeyMapping("startLumberjackDuty", "Start Lumberjack duty", "keyboard", "e")
