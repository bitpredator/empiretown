---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

local lastLockStatus = nil

-- Function to draw 3D text in the game world
function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
    local dist = Vdist(px, py, pz, x, y, z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)

        local factor = (dist / 30)
        DrawRect(_x, _y + 0.015, 0.15 * factor, 0.03, 0, 0, 0, 68)
    end
end

-- Command to lock or unlock the vehicle
RegisterCommand("lockvehicle", function()
    local vehicle, dist = ESX.Game.GetClosestVehicle()

    if dist < 10 and vehicle > 0 then
        ClearPedTasks(PlayerPedId())
        Wait(100)
        TriggerServerEvent("carkeys:RequestVehicleLock", VehToNet(vehicle), GetVehicleDoorLockStatus(vehicle))
    else
        ESX.ShowNotification(TranslateCap("no_vehicle_found"))
    end
end)

-- Mapping the button to lock the vehicle
RegisterKeyMapping("lockvehicle", TranslateCap("lock_vehicle"), "keyboard", "f10")

-- Event for changing the vehicle lock status
RegisterNetEvent("carlock:CarLockedEffect", function(netId, lockStatus)
    if lastLockStatus ~= lockStatus then
        lastLockStatus = lockStatus -- Prevents duplicate notifications

        local vehicle = NetToVeh(netId)
        if DoesEntityExist(vehicle) then
            local ped = PlayerPedId()

            local prop = GetHashKey("p_car_keys_01")
            RequestModel(prop)
            while not HasModelLoaded(prop) do
                Wait(10)
            end
            local keyObj = CreateObject(prop, 1.0, 1.0, 1.0, true, true, false)
            AttachEntityToEntity(keyObj, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.039, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            local dict = "anim@mp_player_intmenu@key_fob@"
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Wait(0)
            end

            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                TaskPlayAnim(ped, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
            end

            PlayVehicleDoorCloseSound(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, lockStatus)
            ESX.ShowNotification(lockStatus and TranslateCap("vehicle_locked") or TranslateCap("vehicle_unlocked"))

            SetVehicleLights(vehicle, 2)
            Wait(250)
            SetVehicleLights(vehicle, 0)
            Wait(250)
            SetVehicleLights(vehicle, 2)
            Wait(250)
            SetVehicleLights(vehicle, 0)
            Wait(600)
            DetachEntity(keyObj, false, false)
            DeleteEntity(keyObj)
        end
    end
end)

-- Command to give keys to another player
RegisterCommand("givekeys", function()
    local closestP, closestD = ESX.Game.GetClosestPlayer()
    local vehicle, dist = ESX.Game.GetClosestVehicle()
    if DoesEntityExist(vehicle) and closestP ~= -1 and closestD < 4 and dist < 10 then
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("carkeys:GiveKeyToPerson", plate, GetPlayerServerId(closestP))
    end
end)

-- Central position for changing blocks
local centralPos = vector3(-25.94, -624.51, 35.5)

-- Main thread to handle interaction with block change
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local dist = #(GetEntityCoords(playerPed) - centralPos)

        if dist < 15.0 then
            Draw3DText(centralPos.x, centralPos.y, centralPos.z, TranslateCap("change_locks_for", Config.Price))
            if dist < 2 then
                if IsControlJustPressed(0, 38) then
                    local veh = GetVehiclePedIsIn(playerPed, false)
                    if DoesEntityExist(veh) then
                        TriggerServerEvent("carkeys:NewLocks", GetVehicleNumberPlateText(veh))
                        Wait(5000)
                    else
                        ESX.ShowNotification(TranslateCap("must_in_vehicle"))
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

-- Thread to create blip on map
CreateThread(function()
    local blip = AddBlipForCoord(centralPos.x, centralPos.y, centralPos.z)

    SetBlipSprite(blip, 186)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 73)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TranslateCap("locksmith"))
    EndTextCommandSetBlipName(blip)
end)
