PlayerData = ESX.GetPlayerData() -- Setting this for when you restart the resource in game
local inRadialMenu = false
local jobIndex, vehicleIndex = nil, nil
local DynamicMenuItems, FinalMenuItems = {}, {}
local controlsToToggle = { 24, 0, 1, 2, 142, 257, 346 } -- if not using toggle

-- Functions
local function deepcopy(orig) -- modified the deep copy function from http://lua-users.org/wiki/CopyTable
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        if not orig.canOpen or orig.canOpen() then
            local toRemove = {}
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                if type(orig_value) == "table" then
                    if not orig_value.canOpen or orig_value.canOpen() then
                        copy[deepcopy(orig_key)] = deepcopy(orig_value)
                    else
                        toRemove[orig_key] = true
                    end
                else
                    copy[deepcopy(orig_key)] = deepcopy(orig_value)
                end
            end
            for i = 1, #toRemove do
                table.remove(copy, i) --[[ Using this to make sure all indexes get re-indexed and no empty spaces are in the radialmenu ]]
            end
            if copy and next(copy) then
                setmetatable(copy, deepcopy(getmetatable(orig)))
            end
        end
    elseif orig_type ~= "function" then
        copy = orig
    end
    return copy
end

local function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

local function AddOption(data, id)
    local menuID = id ~= nil and id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

local function RemoveOption(id)
    DynamicMenuItems[id] = nil
end

local function SetupJobMenu()
    local JobInteractionCheck = ESX.PlayerData.job.name
    if ESX.PlayerData.job.type == "leo" then
        JobInteractionCheck = "police"
    end
    local JobMenu = {
        id = "jobinteractions",
        title = "Work",
        icon = "briefcase",
        items = {},
    }
    if Config.JobInteractions[JobInteractionCheck] and next(Config.JobInteractions[JobInteractionCheck]) then
        JobMenu.items = Config.JobInteractions[JobInteractionCheck]
    end

    if #JobMenu.items == 0 then
        if jobIndex then
            RemoveOption(jobIndex)
            jobIndex = nil
        end
    else
        jobIndex = AddOption(JobMenu, jobIndex)
    end
end

local function SetupVehicleMenu()
    local VehicleMenu = {
        id = "vehicle",
        title = "Vehicle",
        icon = "car",
        items = {},
    }

    local ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(ped) ~= 0 and GetVehiclePedIsIn(ped) or getNearestVeh()
    if Vehicle ~= 0 then
        VehicleMenu.items[#VehicleMenu.items + 1] = Config.VehicleDoors
        if Config.EnableExtraMenu then
            VehicleMenu.items[#VehicleMenu.items + 1] = Config.VehicleExtras
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local seatIndex = #VehicleMenu.items + 1
            VehicleMenu.items[seatIndex] = deepcopy(Config.VehicleSeats)

            local seatTable = {
                [1] = TranslateCap("driver_seat"),
                [2] = TranslateCap("passenger_seat"),
                [3] = TranslateCap("rear_left_seat"),
                [4] = TranslateCap("rear_right_seat"),
            }

            local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))
            for i = 1, AmountOfSeats do
                local newIndex = #VehicleMenu.items[seatIndex].items + 1
                VehicleMenu.items[seatIndex].items[newIndex] = {
                    id = i - 2,
                    title = seatTable[i] or TranslateCap("other_seats"),
                    icon = "caret-up",
                    type = "client",
                    event = "esx-radialmenu:client:ChangeSeat",
                    shouldClose = false,
                }
            end
        end
    end

    if #VehicleMenu.items == 0 then
        if vehicleIndex then
            RemoveOption(vehicleIndex)
            vehicleIndex = nil
        end
    else
        vehicleIndex = AddOption(VehicleMenu, vehicleIndex)
    end
end

local function SetupSubItems()
    SetupJobMenu()
    SetupVehicleMenu()
end

local function selectOption(t, t2)
    for _, v in pairs(t) do
        if v.items then
            local found, hasAction, val = selectOption(v.items, t2)
            if found then
                return true, hasAction, val
            end
        else
            if v.id == t2.id and ((v.event and v.event == t2.event) or v.action) and (not v.canOpen or v.canOpen()) then
                return true, v.action, v
            end
        end
    end
    return false
end

local function IsPoliceOrEMS()
    return (ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.type == "leo" or ESX.PlayerData.job.name == "ambulance")
end

local function IsDowned()
    return ESX.PlayerData.dead
end

local function SetupRadialMenu()
    FinalMenuItems = {}
    if IsDowned() and IsPoliceOrEMS() then
        FinalMenuItems = {
            [1] = {
                id = "emergencybutton2",
                title = TranslateCap("emergency_button"),
                icon = "circle-exclamation",
                type = "client",
                event = "police:client:SendPoliceEmergencyAlert",
                shouldClose = true,
            },
        }
    else
        SetupSubItems()
        FinalMenuItems = deepcopy(Config.MenuItems)
        for _, v in pairs(DynamicMenuItems) do
            FinalMenuItems[#FinalMenuItems + 1] = v
        end
    end
end

local function controlToggle(bool)
    for i = 1, #controlsToToggle, 1 do
        if bool then
            exports["esx-smallresources"]:addDisableControls(controlsToToggle[i])
        else
            exports["esx-smallresources"]:removeDisableControls(controlsToToggle[i])
        end
    end
end

local function setRadialState(bool, sendMessage, delay)
    -- Menuitems have to be added only once
    if Config.UseWhilstWalking then
        if bool then
            SetupRadialMenu()
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", true)
            controlToggle(true)
        else
            controlToggle(false)
        end
        SetNuiFocus(bool, bool)
        SetNuiFocusKeepInput(bool)
    else
        if bool then
            TriggerEvent("esx-radialmenu:client:onRadialmenuOpen")
            SetupRadialMenu()
        else
            TriggerEvent("esx-radialmenu:client:onRadialmenuClose")
        end
        SetNuiFocus(bool, bool)
    end

    if sendMessage then
        SendNUIMessage({
            action = "ui",
            radial = bool,
            items = FinalMenuItems,
            toggle = Config.Toggle,
            keybind = Config.Keybind,
        })
    end
    if delay then
        Wait(500)
    end
    inRadialMenu = bool
end

-- Commands
RegisterCommand("radialmenu", function()
    if not IsPauseMenuActive() then
        if not inRadialMenu then
            setRadialState(true, true)
            SetCursorLocation(0.5, 0.5)
        else
            setRadialState(false, true)
        end
    end
end, false)

RegisterKeyMapping("radialmenu", TranslateCap("command_description"), "keyboard", Config.Keybind)

-- Events

-- Sets the metadata when the player spawns
RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

-- Sets the playerdata to an empty table when the player has quit or did /logout
RegisterNetEvent("esx:onPlayerLogout", function()
    ESX.PlayerLoaded = false
    FirstSpawn = true
end)

RegisterNetEvent("esx-radialmenu:client:noPlayers", function()
    ESX.ShowNotification("Aucun joueur n'est à proximité.", "error", 2500)
end)

RegisterNetEvent("esx-radialmenu:client:openDoor", function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = PlayerPedId()
    local closestVehicle = GetVehiclePedIsIn(ped) ~= 0 and GetVehiclePedIsIn(ped) or getNearestVeh()
    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = GetVehicleNumberPlateText(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent("esx-radialmenu:trunk:server:Door", false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent("esx-radialmenu:trunk:server:Door", true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        ESX.ShowNotification(TranslateCap("no_vehicle_found"), "error", 2500)
    end
end)

RegisterNetEvent("esx-radialmenu:client:setExtra", function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil then
        if GetPedInVehicleSeat(veh, -1) == ped then
            SetVehicleAutoRepairDisabled(veh, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(veh, extra) then
                if IsVehicleExtraTurnedOn(veh, extra) then
                    SetVehicleExtra(veh, extra, true)
                    ESX.ShowNotification(TranslateCap("extra_deactivated", { extra = extra }), "error", 2500)
                else
                    SetVehicleExtra(veh, extra, false)
                    ESX.ShowNotification(TranslateCap("extra_activated", { extra = extra }), "success", 2500)
                end
            else
                ESX.ShowNotification(TranslateCap("extra_not_present", { extra = extra }), "error", 2500)
            end
        else
            ESX.ShowNotification(TranslateCap("not_driver"), "error", 2500)
        end
    end
end)

RegisterNetEvent("esx-radialmenu:trunk:client:Door", function(plate, door, open)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        local pl = GetVehicleNumberPlateText(veh)
        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

RegisterNetEvent("esx-radialmenu:client:ChangeSeat", function(data)
    local PlayerPedId = PlayerPedId()
    local Veh = GetVehiclePedIsIn(PlayerPedId, false)
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local HasHarnass = (PlayerPedId) and IsPedInAnyVehicle(PlayerPedId, false)
    if not HasHarnass then
        local kmh = speed * 3.6
        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
                ESX.ShowNotification(TranslateCap("switched_seats", { seat = data.title }))
            else
                ESX.ShowNotification(TranslateCap("vehicle_driving_fast"), "error")
            end
        else
            ESX.ShowNotification(TranslateCap("seat_occupied"), "error")
        end
    else
        ESX.ShowNotification(TranslateCap("race_harness_on"), "error")
    end
end)

-- NUI Callbacks
RegisterNUICallback("closeRadial", function(data, cb)
    setRadialState(false, false, data.delay)
    cb("ok")
end)

RegisterNUICallback("selectItem", function(inData, cb)
    local itemData = inData.itemData
    local found, action, data = selectOption(FinalMenuItems, itemData)
    if data and found then
        if action then
            action(data)
        elseif data.type == "client" then
            TriggerEvent(data.event, data)
        elseif data.type == "server" then
            TriggerServerEvent(data.event, data)
        elseif data.type == "command" then
            ExecuteCommand(data.event)
        end
    end
    cb("ok")
end)

exports("AddOption", AddOption)
exports("RemoveOption", RemoveOption)
