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

Config = {}

-- FRAMEWORK --
Config.Framework = "esx" -- change it to 'qb' if you're using qbcore

-- LANGUAGE --
Config.Locale = "it"

-- GENERAL --
Config.MenuTitle = "EmpireTown" -- change it to you're server name
Config.NoclipSpeed = 1.0 -- change it to change the speed in noclip
Config.JSFourIDCard = true -- enable if you're using jsfour-idcard

-- CONTROLS --
Config.Controls = {
    OpenMenu = { keyboard = "F5" },
    HandsUP = { keyboard = "GRAVE" },
    Pointing = { keyboard = "B" },
    Crouch = { keyboard = Keys["LEFTCTRL"] },
    StopTasks = { keyboard = "X" },
    TPMarker = { keyboard1 = Keys["LEFTALT"], keyboard2 = Keys["E"] },
}

-- GPS --
Config.GPS = {
    { name = TranslateCap("none"), coords = nil },
    { name = TranslateCap("police_station"), coords = vec2(425.13, -979.55) },
    { name = TranslateCap("central_garage"), coords = vec2(-449.67, -340.83) },
    { name = TranslateCap("hospital"), coords = vec2(-33.88, -1102.37) },
    { name = TranslateCap("dealer"), coords = vec2(215.06, -791.56) },
    { name = TranslateCap("bennys_custom"), coords = vec2(-212.13, -1325.27) },
    { name = TranslateCap("job_center"), coords = vec2(-264.83, -964.54) },
    { name = TranslateCap("driving_school"), coords = vec2(-829.22, -696.99) },
    { name = TranslateCap("tequila-la"), coords = vec2(-565.09, 273.45) },
    { name = TranslateCap("bahama_mamas"), coords = vec2(-1391.06, -590.34) },
}

-- ADMIN --
Config.AdminCommands = {
    {
        id = "noclip",
        name = TranslateCap("admin_noclip_button"),
        groups = { "admin", "mod" },
        command = function()
            PlayerVars.noclip = not PlayerVars.noclip

            if PlayerVars.noclip then
                Citizen.CreateThread(function()
                    while PlayerVars.noclip do
                        local plyPed = PlayerPedId()

                        FreezeEntityPosition(plyPed, true)
                        SetEntityInvincible(plyPed, true)
                        SetEntityCollision(plyPed, false, false)

                        SetEntityVisible(plyPed, false, false)

                        local playerId = PlayerId()
                        SetEveryoneIgnorePlayer(playerId, true)
                        SetPoliceIgnorePlayer(playerId, true)

                        local plyCoords = GetEntityCoords(plyPed, false)

                        local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
                        local pitch = GetGameplayCamRelativePitch()
                        local camCoords = vec3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))

                        local len = math.sqrt((camCoords.x * camCoords.x) + (camCoords.y * camCoords.y) + (camCoords.z * camCoords.z))
                        if len ~= 0 then
                            camCoords = camCoords / len
                        end

                        SetEntityVelocity(plyPed, vec3(0))

                        local isShiftPressed, isCtrlPressed = IsControlPressed(0, 21), IsControlPressed(0, 326)

                        local noclipVelocity = isShiftPressed and isCtrlPressed and Config.NoclipSpeed or isShiftPressed and Config.NoclipSpeed * 2.0 or isCtrlPressed and Config.NoclipSpeed / 2.0 or Config.NoclipSpeed

                        if IsControlPressed(0, 32) then
                            plyCoords += noclipVelocity * camCoords
                        end
                        if IsControlPressed(0, 269) then
                            plyCoords -= noclipVelocity * camCoords
                        end

                        SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)

                        Wait(0)
                    end
                end)

                GameNotification(TranslateCap("admin_noclipon"))
            else
                local plyPed = PlayerPedId()

                FreezeEntityPosition(plyPed, false)
                SetEntityInvincible(plyPed, false)
                SetEntityCollision(plyPed, true, true)

                SetEntityVisible(plyPed, true, false)

                local playerId = PlayerId()
                SetEveryoneIgnorePlayer(playerId, false)
                SetPoliceIgnorePlayer(playerId, false)

                GameNotification(TranslateCap("admin_noclipoff"))
            end

            RageUI.CloseAll()
        end,
    },
    {
        id = "godmode",
        name = TranslateCap("admin_godmode_button"),
        groups = { "admin" },
        command = function()
            PlayerVars.godmode = not PlayerVars.godmode
            local plyPed = PlayerPedId()

            if PlayerVars.godmode then
                SetEntityInvincible(plyPed, true)
                GameNotification(TranslateCap("admin_godmodeon"))
            else
                SetEntityInvincible(plyPed, false)
                GameNotification(TranslateCap("admin_godmodeoff"))
            end
        end,
    },
    {
        id = "ghostmode",
        name = TranslateCap("admin_ghostmode_button"),
        groups = { "admin" },
        command = function()
            PlayerVars.ghostmode = not PlayerVars.ghostmode
            local plyPed = PlayerPedId()

            if PlayerVars.ghostmode then
                SetEntityVisible(plyPed, false, false)
                GameNotification(TranslateCap("admin_ghoston"))
            else
                SetEntityVisible(plyPed, true, false)
                GameNotification(TranslateCap("admin_ghostoff"))
            end
        end,
    },
    {
        id = "spawnveh",
        name = TranslateCap("admin_spawnveh_button"),
        groups = { "admin" },
        command = function()
            local modelName = KeyboardInput("PM_BOX_VEHICLE_NAME", TranslateCap("dialogbox_vehiclespawner"), "", 50)
            if not modelName then
                return
            end

            modelName = tostring(modelName)
            if type(modelName) ~= "string" then
                return
            end
            local plyPed = PlayerPedId()

            ESX.Game.SpawnVehicle(modelName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
                TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
            end)

            RageUI.CloseAll()
        end,
    },
    {
        id = "repairveh",
        name = TranslateCap("admin_repairveh_button"),
        groups = { "admin" },
        command = function()
            local plyPed = PlayerPedId()
            local plyVeh = GetVehiclePedIsIn(plyPed, false)
            SetVehicleFixed(plyVeh)
            SetVehicleDirtLevel(plyVeh, 0.0)
        end,
    },
    {
        id = "flipveh",
        name = TranslateCap("admin_flipveh_button"),
        groups = { "admin" },
        command = function()
            local plyPed = PlayerPedId()
            local plyCoords = GetEntityCoords(plyPed)
            local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)

            SetVehicleOnGroundProperly(closestVeh)
            GameNotification(TranslateCap("admin_vehicleflip"))
        end,
    },
    {
        id = "showxyz",
        name = TranslateCap("admin_showxyz_button"),
        groups = { "admin" },
        command = function()
            PlayerVars.showCoords = not PlayerVars.showCoords
        end,
    },
    {
        id = "showname",
        name = TranslateCap("admin_showname_button"),
        groups = { "admin", "mod" },
        command = function()
            PlayerVars.showName = not PlayerVars.showName

            if not PlayerVars.showName then
                for i = 1, #activeTags do
                    local tag = activeTags[i]

                    if IsMpGamerTagActive(tag.handle) then
                        RemoveMpGamerTag(tag.handle)
                    end
                end

                activeTags = {}
                table.wipe(activeTagsMutex)
            end
        end,
    },
    {
        id = "tpmarker",
        name = TranslateCap("admin_tpmarker_button"),
        groups = { "admin" },
        command = function()
            TpMarker()
        end,
    },
    {
        id = "revive",
        name = TranslateCap("admin_revive_button"),
        groups = { "admin" },
        command = function()
            local targetServerId = KeyboardInput("PM_BOX_ID", TranslateCap("dialogbox_playerid"), "", 8)
            if not targetServerId then
                return
            end

            targetServerId = tonumber(targetServerId)
            if type(targetServerId) ~= "number" then
                return
            end

            TriggerServerEvent("bpt_ambulancejob:revive", targetServerId)
            RageUI.CloseAll()
        end,
    },
}
