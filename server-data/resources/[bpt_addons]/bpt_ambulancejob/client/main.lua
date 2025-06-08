local firstSpawn = true
isDead, isSearched, medic = false, false, 0

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:onPlayerLogout")
AddEventHandler("esx:onPlayerLogout", function()
    ESX.PlayerLoaded = false
    firstSpawn = true
end)

AddEventHandler("esx:onPlayerSpawn", function()
    if firstSpawn then
        firstSpawn = false
        return
    end
    isDead = false
    ClearTimecycleModifier()
    SetPedMotionBlur(PlayerPedId(), false)
    ClearExtraTimecycleModifier()
    EndDeathCam()
end)

-- Create blips
CreateThread(function()
    for k, v in pairs(Config.Hospitals) do
        local blip = AddBlipForCoord(v.Blip.coords)

        SetBlipSprite(blip, v.Blip.sprite)
        SetBlipScale(blip, v.Blip.scale)
        SetBlipColour(blip, v.Blip.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("blip_hospital"))
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent("bpt_ambulancejob:clsearch")
AddEventHandler("bpt_ambulancejob:clsearch", function(medicId)
    local playerPed = PlayerPedId()

    if isDead then
        local coords = GetEntityCoords(playerPed)
        local playersInArea = ESX.Game.GetPlayersInArea(coords, 50.0)

        for i = 1, #playersInArea, 1 do
            local player = playersInArea[i]
            if player == GetPlayerFromServerId(medicId) then
                medic = tonumber(medicId)
                isSearched = true
                break
            end
        end
    end
end)

function OnPlayerDeath()
    ESX.CloseContext()
    ClearTimecycleModifier()
    SetTimecycleModifier("REDMIST_blend")
    SetTimecycleModifierStrength(0.7)
    SetExtraTimecycleModifier("fp_vig_red")
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(PlayerPedId(), true)
    TriggerServerEvent("bpt_ambulancejob:setDeathStatus", true)
    StartDeathTimer()
    StartDeathCam()
    isDead = true
    StartDeathLoop()
    StartDistressSignal()
end

RegisterNetEvent("bpt_ambulancejob:useItem")
AddEventHandler("bpt_ambulancejob:useItem", function(itemName)
    ESX.CloseContext()

    if itemName == "medikit" then
        local lib, anim = "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01" -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            RemoveAnimDict(lib)

            Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent("bpt_ambulancejob:heal", "big", true)
            ESX.ShowNotification(TranslateCap("used_medikit"))
        end)
    elseif itemName == "bandage" then
        local lib, anim = "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01" -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            RemoveAnimDict(lib)

            Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent("bpt_ambulancejob:heal", "small", true)
            ESX.ShowNotification(TranslateCap("used_bandage"))
        end)
    end
end)

function StartDeathLoop()
    CreateThread(function()
        while isDead do
            DisableAllControlActions(0)
            EnableControlAction(0, 47, true) -- G
            EnableControlAction(0, 245, true) -- T
            EnableControlAction(0, 38, true) -- E

            ProcessCamControls()
            if isSearched then
                local playerPed = PlayerPedId()
                local ped = GetPlayerPed(GetPlayerFromServerId(medic))
                isSearched = false

                AttachEntityToEntity(playerPed, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                Wait(1000)
                DetachEntity(playerPed, true, false)
                ClearPedTasksImmediately(playerPed)
            end
            Wait(0)
        end
    end)
end

function StartDistressSignal()
    CreateThread(function()
        local timer = Config.BleedoutTimer

        while timer > 0 and isDead do
            Wait(0)
            timer = timer - 30

            SetTextFont(4)
            SetTextScale(0.5, 0.5)
            SetTextColour(200, 50, 50, 255)
            SetTextDropshadow(0.1, 3, 27, 27, 255)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(TranslateCap("distress_send"))
            EndTextCommandDisplayText(0.446, 0.77)

            if IsControlJustReleased(0, 47) then
                SendDistressSignal()
                break
            end
        end
    end)
end

function SendDistressSignal()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    ESX.ShowNotification(TranslateCap("distress_sent"))
    TriggerServerEvent("bpt_ambulancejob:onPlayerDistress")
end

function DrawGenericTextThisFrame()
    SetTextFont(4)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
end

function secondsToClock(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format("%02.f", math.floor(seconds / 3600))
        local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

        return mins, secs
    end
end

function StartDeathTimer()
    local canPayFine = false

    if Config.EarlyRespawnFine then
        ESX.TriggerServerCallback("bpt_ambulancejob:checkBalance", function(canPay)
            canPayFine = canPay
        end)
    end

    local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
    local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

    CreateThread(function()
        -- early respawn timer
        while earlySpawnTimer > 0 and isDead do
            Wait(1000)

            if earlySpawnTimer > 0 then
                earlySpawnTimer = earlySpawnTimer - 1
            end
        end

        -- bleedout timer
        while bleedoutTimer > 0 and isDead do
            Wait(1000)

            if bleedoutTimer > 0 then
                bleedoutTimer = bleedoutTimer - 1
            end
        end
    end)

    CreateThread(function()
        local text, timeHeld

        -- early respawn timer
        while earlySpawnTimer > 0 and isDead do
            Wait(0)
            text = TranslateCap("respawn_available_in", secondsToClock(earlySpawnTimer))

            DrawGenericTextThisFrame()
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayText(0.5, 0.8)
        end

        -- bleedout timer
        while bleedoutTimer > 0 and isDead do
            Wait(0)
            text = TranslateCap("respawn_bleedout_in", secondsToClock(bleedoutTimer))

            if not Config.EarlyRespawnFine then
                text = text .. TranslateCap("respawn_bleedout_prompt")

                if IsControlPressed(0, 38) and timeHeld > 120 then
                    RemoveItemsAfterRPDeath()
                    break
                end
            elseif Config.EarlyRespawnFine and canPayFine then
                text = text .. TranslateCap("respawn_bleedout_fine", ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

                if IsControlPressed(0, 38) and timeHeld > 120 then
                    TriggerServerEvent("bpt_ambulancejob:payFine")
                    RemoveItemsAfterRPDeath()
                    break
                end
            end

            if IsControlPressed(0, 38) then
                timeHeld += 1
            else
                timeHeld = 0
            end

            DrawGenericTextThisFrame()

            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayText(0.5, 0.8)
        end

        if bleedoutTimer < 1 and isDead then
            RemoveItemsAfterRPDeath()
        end
    end)
end

function GetClosestRespawnPoint()
    local plyCoords = GetEntityCoords(PlayerPedId())
    local closestDist, closestHospital

    for i = 1, #Config.RespawnPoints do
        local dist = #(plyCoords - Config.RespawnPoints[i].coords)

        if not closestDist or dist <= closestDist then
            closestDist, closestHospital = dist, Config.RespawnPoints[i]
        end
    end

    return closestHospital
end

function RemoveItemsAfterRPDeath()
    TriggerServerEvent("bpt_ambulancejob:setDeathStatus", false)

    CreateThread(function()
        ESX.TriggerServerCallback("bpt_ambulancejob:removeItemsAfterRPDeath", function()
            local ClosestHospital = GetClosestRespawnPoint()

            if not ClosestHospital then
                ESX.ShowNotification("Nessun punto di respawn configurato! Contatta un amministratore.")
                print("ERRORE: Nessun punto di respawn trovato in Config.RespawnPoints")
                return
            end

            ESX.SetPlayerData("loadout", {})

            DoScreenFadeOut(800)
            RespawnPed(PlayerPedId(), ClosestHospital.coords, ClosestHospital.heading)
            while not IsScreenFadedOut() do
                Wait(0)
            end
            DoScreenFadeIn(800)
        end)
    end)
end

function RespawnPed(ped, coords, heading)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)

    TriggerEvent("bpt_basicneeds:resetStatus")
    TriggerServerEvent("esx:onPlayerSpawn")
    TriggerEvent("esx:onPlayerSpawn")
    TriggerEvent("playerSpawned") -- compatibility with old scripts, will be removed soon
end

RegisterNetEvent("esx_phone:loaded")
AddEventHandler("esx_phone:loaded", function(phoneNumber, contacts)
    local specialContact = {
        name = "Ambulance",
        number = "ambulance",
        base64Icon = "data:image/png;base64,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",
    }

    TriggerEvent("esx_phone:addSpecialContact", specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler("esx:onPlayerDeath", function(data)
    OnPlayerDeath()
end)

RegisterNetEvent("bpt_ambulancejob:revive")
AddEventHandler("bpt_ambulancejob:revive", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    TriggerServerEvent("bpt_ambulancejob:setDeathStatus", false)

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    local formattedCoords = { x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1) }

    RespawnPed(playerPed, formattedCoords, 0.0)
    isDead = false
    ClearTimecycleModifier()
    SetPedMotionBlur(playerPed, false)
    ClearExtraTimecycleModifier()
    EndDeathCam()
    DoScreenFadeIn(800)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
    RequestIpl("Coroner_Int_on") -- Morgue
end
