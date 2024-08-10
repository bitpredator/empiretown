local PersonalMenu = {
    ItemSelected = {},
    ItemIndex = {},
    BillData = {},
    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false,
    },
    DoorIndex = 1,
    DoorList = {
        TranslateCap("vehicle_door_frontleft"),
        TranslateCap("vehicle_door_frontright"),
        TranslateCap("vehicle_door_backleft"),
        TranslateCap("vehicle_door_backright"),
    },
    GPSIndex = 1,
    GPSList = {},
}

PlayerVars = {
    isDead = false,
    crouched = false,
    handsup = false,
    pointing = false,
    noclip = false,
    godmode = false,
    ghostmode = false,
    showCoords = false,
    showName = false,
    group = "user",
}

local drawContentOptions = { header = true, instructionalButton = true }
local ruiDrawContent = RageUI.DrawContent

local adminGroups = {
    ["mod"] = true,
    ["admin"] = true,
}

CreateThread(function()
    if Config.Framework == "esx" then
        while not ESX do
            Wait(100)
        end
    end
end)

for i = 1, #Config.GPS do
    PersonalMenu.GPSList[i] = Config.GPS[i].name
end

for i = 1, #Config.AdminCommands do
    local adminCommandCfg = Config.AdminCommands[i]
    local groupsById = {}

    for j = 1, #adminCommandCfg.groups do
        groupsById[adminCommandCfg.groups[j]] = true
    end

    adminCommandCfg.groupsById = groupsById
end

local mainMenu = RageUI.CreateMenu(Config.MenuTitle, TranslateCap("mainmenu_subtitle"), 0, 0, "commonmenu", "interaction_bgd", 255, 255, 255, 255)

local personalMenuCategories = {}
local personalMenuCategoriesById = {}

local function addPersonalMenuCategory(id, name, restriction)
    local menu = RageUI.CreateSubMenu(mainMenu, name)
    local pmCategory = { id = id, name = name, menu = menu, restriction = restriction }
    personalMenuCategories[#personalMenuCategories + 1] = pmCategory
    personalMenuCategoriesById[id] = pmCategory
    return pmCategory
end

local function getPersonalMenuCategory(id)
    return personalMenuCategoriesById[id]
end

local animationCategory = addPersonalMenuCategory("animation", TranslateCap("animation_title"))
local plyPed

addPersonalMenuCategory("vehicle", TranslateCap("vehicle_title"), function()
    return IsPedSittingInAnyVehicle(plyPed) and GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed
end)

addPersonalMenuCategory("boss", TranslateCap("bossmanagement_title"), function()
    return GetPlayerJob().isBoss
end)

addPersonalMenuCategory("admin", TranslateCap("admin_title"), function()
    return adminGroups[PlayerVars.group] ~= nil
end)

for i = 1, #Config.Animations do
    local animationCfg = Config.Animations[i]
    animationCfg.menu = RageUI.CreateSubMenu(animationCategory.menu, animationCfg.name)
end

if Config.Framework == "esx" then
    AddEventHandler("esx:onPlayerDeath", function()
        PlayerVars.isDead = true
        RageUI.CloseAll()
        ESX.UI.Menu.CloseAll()
    end)
end

AddEventHandler("playerSpawned", function()
    PlayerVars.isDead = false
end)

-- Admin Menu --
RegisterNetEvent("bpt_personalmenu:Admin_BringC", function(plyCoords)
    SetEntityCoords(plyPed, plyCoords)
end)

-- Player text message
local function Text(text)
    SetTextColour(186, 186, 186, 255)
    SetTextFont(0)
    SetTextScale(0.378, 0.378)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.03)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

function startAttitude(animSet)
    if not animSet then
        ResetPedMovementClipset(plyPed, 1.0)
        return
    end

    LoadAnimSet(animSet)

    SetPedMotionBlur(plyPed, false)
    SetPedMovementClipset(plyPed, animSet, 1.0)

    RemoveAnimSet(animSet)
end

function startAnim(animDict, animName)
    LoadAnimDict(animDict)
    TaskPlayAnim(plyPed, animDict, animName, 8.0, 1.0, -1, 49, 0, false, false, false)
    RemoveAnimDict(animDict)
end

function DrawPersonalMenu()
    ruiDrawContent(drawContentOptions, function()
        for i = 1, #personalMenuCategories do
            local pmCategory = personalMenuCategories[i]
            local canOpen = not pmCategory.restriction or pmCategory.restriction()
            RageUI.Button(pmCategory.name, nil, canOpen and { RightLabel = "→→→" } or { RightBadge = RageUI.BadgeStyle.Lock }, canOpen, nil, pmCategory.menu)
        end

        RageUI.List(TranslateCap("mainmenu_gps_button"), PersonalMenu.GPSList, PersonalMenu.GPSIndex, nil, nil, true, function(Hovered, Active, Selected, Index)
            PersonalMenu.GPSIndex = Index

            if not Selected then
                return
            end

            local gpsCfg = Config.GPS[Index]

            if gpsCfg.coords then
                SetNewWaypoint(gpsCfg.coords)
            else
                DeleteWaypoint()
            end

            GameNotification(TranslateCap("gps", gpsCfg.name))
        end)
    end)
end

getPersonalMenuCategory("animation").drawer = function()
    for i = 1, #Config.Animations do
        local animationCfg = Config.Animations[i]
        RageUI.Button(animationCfg.name, nil, { RightLabel = "→→→" }, true, nil, animationCfg.menu)
    end
end

function DrawAnimationsCategory(animationCfg)
    ruiDrawContent(drawContentOptions, function()
        for i = 1, #animationCfg.items do
            local animItemCfg = animationCfg.items[i]

            RageUI.Button(animItemCfg.name, nil, nil, true, function(Hovered, Active, Selected)
                if not Selected then
                    return
                end

                if animItemCfg.type == "anim" then
                    startAnim(animItemCfg.animDict, animItemCfg.animName)
                elseif animItemCfg.type == "scenario" then
                    TaskStartScenarioInPlace(plyPed, animItemCfg.scenarioName, 0, false)
                elseif animItemCfg.type == "attitude" then
                    startAttitude(animItemCfg.animSet)
                end
            end)
        end
    end)
end

getPersonalMenuCategory("vehicle").drawer = function()
    RageUI.Button(TranslateCap("vehicle_engine_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        if not IsPedSittingInAnyVehicle(plyPed) then
            GameNotification(TranslateCap("no_vehicle"))
            return
        end

        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if GetIsVehicleEngineRunning(plyVeh) then
            SetVehicleEngineOn(plyVeh, false, false, true)
            SetVehicleUndriveable(plyVeh, true)
        elseif not GetIsVehicleEngineRunning(plyVeh) then
            SetVehicleEngineOn(plyVeh, true, false, true)
            SetVehicleUndriveable(plyVeh, false)
        end
    end)

    RageUI.List(TranslateCap("vehicle_door_button"), PersonalMenu.DoorList, PersonalMenu.DoorIndex, nil, nil, true, function(Hovered, Active, Selected, Index)
        PersonalMenu.DoorIndex = Index

        if not Selected then
            return
        end

        if not IsPedSittingInAnyVehicle(plyPed) then
            GameNotification(TranslateCap("no_vehicle"))
            return
        end

        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if Index == 1 then
            if not PersonalMenu.DoorState.FrontLeft then
                PersonalMenu.DoorState.FrontLeft = true
                SetVehicleDoorOpen(plyVeh, 0, false, false)
            elseif PersonalMenu.DoorState.FrontLeft then
                PersonalMenu.DoorState.FrontLeft = false
                SetVehicleDoorShut(plyVeh, 0, false, false)
            end
        elseif Index == 2 then
            if not PersonalMenu.DoorState.FrontRight then
                PersonalMenu.DoorState.FrontRight = true
                SetVehicleDoorOpen(plyVeh, 1, false, false)
            elseif PersonalMenu.DoorState.FrontRight then
                PersonalMenu.DoorState.FrontRight = false
                SetVehicleDoorShut(plyVeh, 1, false, false)
            end
        elseif Index == 3 then
            if not PersonalMenu.DoorState.BackLeft then
                PersonalMenu.DoorState.BackLeft = true
                SetVehicleDoorOpen(plyVeh, 2, false, false)
            elseif PersonalMenu.DoorState.BackLeft then
                PersonalMenu.DoorState.BackLeft = false
                SetVehicleDoorShut(plyVeh, 2, false, false)
            end
        elseif Index == 4 then
            if not PersonalMenu.DoorState.BackRight then
                PersonalMenu.DoorState.BackRight = true
                SetVehicleDoorOpen(plyVeh, 3, false, false)
            elseif PersonalMenu.DoorState.BackRight then
                PersonalMenu.DoorState.BackRight = false
                SetVehicleDoorShut(plyVeh, 3, false, false)
            end
        end
    end)

    RageUI.Button(TranslateCap("vehicle_hood_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        if not IsPedSittingInAnyVehicle(plyPed) then
            GameNotification(TranslateCap("no_vehicle"))
            return
        end

        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if not PersonalMenu.DoorState.Hood then
            PersonalMenu.DoorState.Hood = true
            SetVehicleDoorOpen(plyVeh, 4, false, false)
        elseif PersonalMenu.DoorState.Hood then
            PersonalMenu.DoorState.Hood = false
            SetVehicleDoorShut(plyVeh, 4, false, false)
        end
    end)

    RageUI.Button(TranslateCap("vehicle_trunk_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        if not IsPedSittingInAnyVehicle(plyPed) then
            GameNotification(TranslateCap("no_vehicle"))
            return
        end

        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if not PersonalMenu.DoorState.Trunk then
            PersonalMenu.DoorState.Trunk = true
            SetVehicleDoorOpen(plyVeh, 5, false, false)
        elseif PersonalMenu.DoorState.Trunk then
            PersonalMenu.DoorState.Trunk = false
            SetVehicleDoorShut(plyVeh, 5, false, false)
        end
    end)
end

local societyMoney = {}
getPersonalMenuCategory("boss").drawer = function()
    if societyMoney then
        RageUI.Button(TranslateCap("bossmanagement_chest_button"), nil, { RightLabel = ("$%s"):format(GroupDigits(societyMoney)) }, true, nil)
    end

    RageUI.Button(TranslateCap("bossmanagement_hire_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        local playerJob = GetPlayerJob()

        if not playerJob.isBoss then
            GameNotification(TranslateCap("missing_rights"))
            return
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            GameNotification(TranslateCap("players_nearby"))
            return
        end

        TriggerServerEvent("bpt_personalmenu:Boss_recruterplayer", GetPlayerServerId(closestPlayer))
    end)

    RageUI.Button(TranslateCap("bossmanagement_fire_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        local playerJob = GetPlayerJob()

        if not playerJob.isBoss then
            GameNotification(TranslateCap("missing_rights"))
            return
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            GameNotification(TranslateCap("players_nearby"))
            return
        end

        TriggerServerEvent("bpt_personalmenu:Boss_virerplayer", GetPlayerServerId(closestPlayer))
    end)

    RageUI.Button(TranslateCap("bossmanagement_promote_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        local playerJob = GetPlayerJob()

        if not playerJob.isBoss then
            GameNotification(TranslateCap("missing_rights"))
            return
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            GameNotification(TranslateCap("players_nearby"))
            return
        end

        TriggerServerEvent("bpt_personalmenu:Boss_promouvoirplayer", GetPlayerServerId(closestPlayer))
    end)

    RageUI.Button(TranslateCap("bossmanagement_demote_button"), nil, nil, true, function(Hovered, Active, Selected)
        if not Selected then
            return
        end

        local playerJob = GetPlayerJob()

        if not playerJob.isBoss then
            GameNotification(TranslateCap("missing_rights"))
            return
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            GameNotification(TranslateCap("players_nearby"))
            return
        end

        TriggerServerEvent("bpt_personalmenu:Boss_destituerplayer", GetPlayerServerId(closestPlayer))
    end)
end

getPersonalMenuCategory("admin").drawer = function()
    for i = 1, #Config.AdminCommands do
        local adminCommandCfg = Config.AdminCommands[i]

        if adminCommandCfg.groupsById[PlayerVars.group] then
            RageUI.Button(adminCommandCfg.name, nil, nil, true, function(Hovered, Active, Selected)
                if not Selected then
                    return
                end
                adminCommandCfg.command()
            end)
        else
            RageUI.Button(adminCommandCfg.name, nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, nil)
        end
    end
end

RegisterCommand("+openpersonal", function()
    if PlayerVars.isDead then
        return
    end

    if RageUI.Visible(mainMenu) then
        return
    end

    TriggerServerCallback("bpt_personalmenu:Admin_getUsergroup", function(plyGroup)
        PlayerVars.group = plyGroup
    end)

    TriggerEvent("bpt_personalmenu:menuOpening")
    RageUI.Visible(mainMenu, true)
    DrawPersonalMenu()
end, false)

RegisterCommand("-openpersonal", function() end, false)

RegisterKeyMapping("+openpersonal", "Ouvrir le menu personnel", "KEYBOARD", Config.Controls.OpenMenu.keyboard)
TriggerEvent("chat:removeSuggestion", "/+openpersonal")
TriggerEvent("chat:removeSuggestion", "/-openpersonal")

CreateThread(function()
    local ruiVisible = RageUI.Visible

    while true do
        if ruiVisible(mainMenu) then
            DrawPersonalMenu()
            goto continue
        end

        for i = 1, #personalMenuCategories do
            local pmCategory = personalMenuCategories[i]

            if ruiVisible(pmCategory.menu) then
                if not pmCategory.restriction or pmCategory.restriction() then
                    ruiDrawContent(drawContentOptions, pmCategory.drawer)
                else
                    RageUI.GoBack()
                end

                goto continue
            end
        end

        for i = 1, #Config.Animations do
            local animationCfg = Config.Animations[i]

            if ruiVisible(animationCfg.menu) then
                DrawAnimationsCategory(animationCfg)
                goto continue
            end
        end

        ::continue::
        Wait(0)
    end
end)

RegisterCommand("+stoptask", function()
    local playerPed = PlayerPedId()

    if (not IsPedArmed(playerPed, tonumber("111", 2)) or IsPedInAnyVehicle(playerPed)) and not PlayerVars.isDead then
        if GetScriptTaskStatus(playerPed, `SCRIPT_TASK_START_SCENARIO_IN_PLACE`) == 1 or GetScriptTaskStatus(playerPed, `SCRIPT_TASK_PLAY_ANIM`) == 1 then
            ResetOtherAnimsVals()
            ClearPedTasks(plyPed)
        end
    end
end, false)

RegisterCommand("-stoptask", function() end, false)

RegisterKeyMapping("+stoptask", "Annulez animation", "KEYBOARD", Config.Controls.StopTasks.keyboard)
TriggerEvent("chat:removeSuggestion", "/+stoptask")
TriggerEvent("chat:removeSuggestion", "/-stoptask")

function tpMarker()
    local waypointHandle = GetFirstBlipInfoId(8)

    if not DoesBlipExist(waypointHandle) then
        GameNotification(TranslateCap("admin_nomarker"))
        return
    end

    CreateThread(function()
        local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
        local foundGround, zCoords, zPos = false, -500.0, 0.0

        while not foundGround do
            zCoords = zCoords + 10.0
            RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
            Wait(0)
            foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords, false)

            if not foundGround and zCoords >= 2000.0 then
                foundGround = true
            end
        end

        SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
        GameNotification(TranslateCap("admin_tpmarker"))
    end)
end

CreateThread(function()
    while true do
        plyPed = PlayerPedId()

        if
            (IsControlPressed(0, Config.Controls.TPMarker.keyboard1) or IsDisabledControlPressed(0, Config.Controls.TPMarker.keyboard1))
            and (IsControlJustReleased(0, Config.Controls.TPMarker.keyboard2) or IsDisabledControlJustReleased(0, Config.Controls.TPMarker.keyboard2))
            and IsUsingKeyboard(2)
            and not PlayerVars.isDead
        then
            TriggerServerCallback("bpt_personalmenu:Admin_getUsergroup", function(plyGroup)
                if not adminGroups[plyGroup] then
                    return
                end

                tpMarker()
            end)
        end

        if PlayerVars.showCoords then
            local plyCoords = GetEntityCoords(plyPed, false)
            Text("~r~X~s~: " .. MathRound(plyCoords.x, 2) .. "\n~b~Y~s~: " .. MathRound(plyCoords.y, 2) .. "\n~g~Z~s~: " .. MathRound(plyCoords.z, 2) .. "\n~y~Angle~s~: " .. MathRound(GetEntityPhysicsHeading(plyPed), 2))
        end

        Wait(0)
    end
end)
