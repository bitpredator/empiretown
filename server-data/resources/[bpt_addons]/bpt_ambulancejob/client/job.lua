---@diagnostic disable: undefined-global

local CurrentAction, CurrentActionMsg, CurrentActionData = nil, "", {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy, deadPlayers, deadPlayerBlips, isOnDuty = false, {}, {}, false
IsInShopMenu = false

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

function OpenAmbulanceActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-shirt", title = TranslateCap("ambulance") },
        { icon = "fas fa-shirt", title = TranslateCap("cloakroom"), value = "cloakroom" },
    }

    if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == "boss" then
        elements[#elements + 1] = {
            icon = "fas fa-ambulance",
            title = TranslateCap("boss_actions"),
            value = "boss_actions",
        }
    end

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "cloakroom" then
            OpenCloakroomMenu()
        elseif element.value == "boss_actions" then
            TriggerEvent("bpt_society:openBossMenu", "ambulance", function()
                menu.close()
            end, { wash = false })
        end
    end)
end

function OpenMobileAmbulanceActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-ambulance", title = TranslateCap("ambulance") },
        { icon = "fas fa-ambulance", title = TranslateCap("ems_menu"), value = "citizen_interaction" },
    }

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "citizen_interaction" then
            local elements2 = {
                { unselectable = true, icon = "fas fa-ambulance", title = element.title },
                { icon = "fas fa-syringe", title = TranslateCap("ems_menu_revive"), value = "revive" },
                { icon = "fas fa-bandage", title = TranslateCap("ems_menu_small"), value = "small" },
                { icon = "fas fa-bandage", title = TranslateCap("ems_menu_big"), value = "big" },
                { icon = "fas fa-car", title = TranslateCap("ems_menu_putincar"), value = "put_in_vehicle" },
                { icon = "fas fa-search", title = TranslateCap("ems_menu_search"), value = "search" },
                { icon = "fas fa-money-bill", title = TranslateCap("billing"), value = "billing" },
            }

            ESX.OpenContext("right", elements2, function(menu2, element2)
                if IsBusy then
                    return
                end
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if element2.value == "search" then
                    TriggerServerEvent("bpt_ambulancejob:svsearch")
                elseif closestPlayer == -1 or closestDistance > 1.0 then
                    ESX.ShowNotification(TranslateCap("no_players"))
                else
                    if element2.value == "revive" then
                        RevivePlayer(closestPlayer)
                    elseif element2.value == "small" then
                        ESX.TriggerServerCallback("bpt_ambulancejob:getItemAmount", function(quantity)
                            if quantity > 0 then
                                local closestPlayerPed = GetPlayerPed(closestPlayer)
                                local health = GetEntityHealth(closestPlayerPed)

                                if health > 0 then
                                    local playerPed = PlayerPedId()

                                    IsBusy = true
                                    ESX.ShowNotification(TranslateCap("heal_inprogress"))
                                    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                                    Wait(10000)
                                    ClearPedTasks(playerPed)

                                    TriggerServerEvent("bpt_ambulancejob:removeItem", "bandage")
                                    TriggerServerEvent("bpt_ambulancejob:heal", GetPlayerServerId(closestPlayer), "small")
                                    ESX.ShowNotification(TranslateCap("heal_complete", GetPlayerName(closestPlayer)))
                                    IsBusy = false
                                else
                                    ESX.ShowNotification(TranslateCap("player_not_conscious"))
                                end
                            else
                                ESX.ShowNotification(TranslateCap("not_enough_bandage"))
                            end
                        end, "bandage")
                    elseif element2.value == "big" then
                        ESX.TriggerServerCallback("bpt_ambulancejob:getItemAmount", function(quantity)
                            if quantity > 0 then
                                local closestPlayerPed = GetPlayerPed(closestPlayer)
                                local health = GetEntityHealth(closestPlayerPed)

                                if health > 0 then
                                    local playerPed = PlayerPedId()

                                    IsBusy = true
                                    ESX.ShowNotification(TranslateCap("heal_inprogress"))
                                    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                                    Wait(10000)
                                    ClearPedTasks(playerPed)

                                    TriggerServerEvent("bpt_ambulancejob:removeItem", "medikit")
                                    TriggerServerEvent("bpt_ambulancejob:heal", GetPlayerServerId(closestPlayer), "big")
                                    ESX.ShowNotification(TranslateCap("heal_complete", GetPlayerName(closestPlayer)))
                                    IsBusy = false
                                else
                                    ESX.ShowNotification(TranslateCap("player_not_conscious"))
                                end
                            else
                                ESX.ShowNotification(TranslateCap("not_enough_medikit"))
                            end
                        end, "medikit")
                    elseif element2.value == "put_in_vehicle" then
                        TriggerServerEvent("bpt_ambulancejob:putInVehicle", GetPlayerServerId(closestPlayer))
                    end
                end
            end)
        end
    end)
end

if value == "billing" then
    local elements2 = {
        { unselectable = true, icon = "fas fa-money-bill", title = TranslateCap("billing")},
        {
            title = TranslateCap("amount"),
            input = true,
            inputType = "number",
            inputMin = 1,
            inputMax = 10000000,
            inputPlaceholder = TranslateCap("bill_amount"),
        },
        { icon = "fas fa-check-double", title = TranslateCap("confirm"), value = "confirm" },
    }
    local amount = tonumber(menu2.eles[2].inputValue)
    if amount == nil then
        ESX.ShowNotification(TranslateCap("amount_invalid"))
    else
        ESX.CloseContext()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification(TranslateCap("no_players_near"))
        else
            TriggerServerEvent("bpt_billing:sendBill", GetPlayerServerId(closestPlayer), "society_ballas", "Ballas", amount)
            ESX.ShowNotification(TranslateCap("billing_sent"))
        end
    end
end

function RevivePlayer(closestPlayer)
    IsBusy = true

    ESX.TriggerServerCallback("bpt_ambulancejob:getItemAmount", function(quantity)
        if quantity > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)

            if IsPedDeadOrDying(closestPlayerPed, true) then
                local playerPed = PlayerPedId()
                local lib, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"
                ESX.ShowNotification(TranslateCap("revive_inprogress"))

                for _ = 1, 15 do
                    Wait(900)

                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                        RemoveAnimDict(lib)
                    end)
                end

                TriggerServerEvent("bpt_ambulancejob:removeItem", "medikit")
                TriggerServerEvent("bpt_ambulancejob:revive", GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification(TranslateCap("player_not_unconscious"))
            end
        else
            ESX.ShowNotification(TranslateCap("not_enough_medikit"))
        end
        IsBusy = false
    end, "medikit")
end

-- Draw markers & Marker logic
CreateThread(function()
    while true do
        local sleep = 1500

        if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isInMarker, hasExited = false, false
            local currentHospital, currentPart, currentPartNum

            for hospitalNum, hospital in pairs(Config.Hospitals) do
                -- Ambulance Actions
                for k, v in ipairs(hospital.AmbulanceActions) do
                    local distance = #(playerCoords - v)

                    if distance < Config.DrawDistance then
                        sleep = 0
                        DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)

                        if distance < Config.Marker.x then
                            isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, "AmbulanceActions", k
                        end
                    end
                end

                -- Vehicle Spawners
                for k, v in ipairs(hospital.Vehicles) do
                    local distance = #(playerCoords - v.Spawner)

                    if distance < Config.DrawDistance then
                        sleep = 0
                        DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

                        if distance < v.Marker.x then
                            isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, "Vehicles", k
                        end
                    end
                end

                -- Helicopter Spawners
                for k, v in ipairs(hospital.Helicopters) do
                    local distance = #(playerCoords - v.Spawner)

                    if distance < Config.DrawDistance then
                        sleep = 0
                        DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

                        if distance < v.Marker.x then
                            isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, "Helicopters", k
                        end
                    end
                end
            end

            -- Logic for exiting & entering markers
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
                if (LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
                    TriggerEvent("bpt_ambulancejob:hasExitedMarker", LastHospital, LastPart, LastPartNum)
                    hasExited = true
                end

                HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

                TriggerEvent("bpt_ambulancejob:hasEnteredMarker", currentHospital, currentPart, currentPartNum)
            end

            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent("bpt_ambulancejob:hasExitedMarker", LastHospital, LastPart, LastPartNum)
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler("bpt_ambulancejob:hasEnteredMarker", function(hospital, part, partNum)
    if part == "AmbulanceActions" then
        CurrentAction = part
        CurrentActionMsg = TranslateCap("actions_prompt")
        CurrentActionData = {}
    elseif part == "Vehicles" then
        CurrentAction = part
        CurrentActionMsg = TranslateCap("garage_prompt")
        CurrentActionData = { hospital = hospital, partNum = partNum }
    elseif part == "Helicopters" then
        CurrentAction = part
        CurrentActionMsg = TranslateCap("helicopter_prompt")
        CurrentActionData = { hospital = hospital, partNum = partNum }
    end

    ESX.TextUI(CurrentActionMsg)
end)

AddEventHandler("bpt_ambulancejob:hasExitedMarker", function(hospital, part, partNum)
    if not IsInShopMenu then
        ESX.CloseContext()
    end
    ESX.HideUI()
    CurrentAction = nil
end)

-- Key Controls
CreateThread(function()
    while true do
        local sleep = 1500

        if CurrentAction then
            sleep = 0

            if IsControlJustReleased(0, 38) then
                if CurrentAction == "AmbulanceActions" then
                    OpenAmbulanceActionsMenu()
                elseif CurrentAction == "Vehicles" then
                    OpenVehicleSpawnerMenu("car", CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
                elseif CurrentAction == "Helicopters" then
                    OpenVehicleSpawnerMenu("helicopter", CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
                end

                CurrentAction = nil
            end
        end
        GetEntityCoords(PlayerPedId())
        Wait(sleep)
    end
end)

RegisterCommand("ambulance", function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" and not ESX.PlayerData.dead then
        OpenMobileAmbulanceActionsMenu()
    end
end, false)

RegisterKeyMapping("ambulance", "Open Ambulance Actions Menu", "keyboard", "F6")

RegisterNetEvent("bpt_ambulancejob:putInVehicle")
AddEventHandler("bpt_ambulancejob:putInVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle, distance = ESX.Game.GetClosestVehicle()

    if vehicle and distance < 5 then
        local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

        for i = maxSeats - 1, 0, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
        end
    end
end)

function OpenCloakroomMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom") },
        { icon = "fas fa-shirt", title = TranslateCap("ems_clothes_civil"), value = "citizen_wear" },
        { icon = "fas fa-shirt", title = TranslateCap("ems_clothes_ems"), value = "ambulance_wear" },
    }

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "citizen_wear" then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                TriggerEvent("skinchanger:loadSkin", skin)
                isOnDuty = false

                for playerId, v in pairs(deadPlayerBlips) do
                    RemoveBlip(v)
                    deadPlayerBlips[playerId] = nil
                end
                deadPlayers = {}
                if Config.Debug then
                    print("[^2INFO^7] Off Duty")
                end
            end)
        elseif element.value == "ambulance_wear" then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_male)
                else
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_female)
                end

                isOnDuty = true
                local _deadPlayers = deadPlayers
                ESX.TriggerServerCallback("bpt_ambulancejob:getDeadPlayers", function()
                    TriggerEvent("bpt_ambulancejob:setDeadPlayers", _deadPlayers)
                end)
                if Config.Debug then
                    print("[^2INFO^7] Player Sex |^5" .. tostring(skin.sex) .. "^7")
                    print("[^2INFO^7] On Duty")
                end
            end)
        end
    end)
end

RegisterNetEvent("bpt_ambulancejob:heal")
AddEventHandler("bpt_ambulancejob:heal", function(healType, quiet)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    if healType == "small" then
        local health = GetEntityHealth(playerPed)
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
        SetEntityHealth(playerPed, newHealth)
    elseif healType == "big" then
        SetEntityHealth(playerPed, maxHealth)
    end

    if Config.Debug then
        print("[^2INFO^7] Healing Player - ^5" .. tostring(healType) .. "^7")
    end
    if not quiet then
        ESX.ShowNotification(TranslateCap("healed"))
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    if isOnDuty and job.name ~= "ambulance" then
        for playerId, v in pairs(deadPlayerBlips) do
            if Config.Debug then
                print("[^2INFO^7] Removing dead blip - ^5" .. tostring(playerId) .. "^7")
            end
            RemoveBlip(v)
            deadPlayerBlips[playerId] = nil
        end

        isOnDuty = false
    end
end)

RegisterNetEvent("bpt_ambulancejob:PlayerDead")
AddEventHandler("bpt_ambulancejob:PlayerDead", function(Player)
    if Config.Debug then
        print("[^2INFO^7] Player Dead | ^5" .. tostring(Player) .. "^7")
    end
    deadPlayers[Player] = "dead"
end)

RegisterNetEvent("bpt_ambulancejob:PlayerNotDead")
AddEventHandler("bpt_ambulancejob:PlayerNotDead", function(Player)
    if deadPlayerBlips[Player] then
        RemoveBlip(deadPlayerBlips[Player])
        deadPlayerBlips[Player] = nil
    end
    if Config.Debug then
        print("[^2INFO^7] Player Alive | ^5" .. tostring(Player) .. "^7")
    end
    deadPlayers[Player] = nil
end)

RegisterNetEvent("bpt_ambulancejob:setDeadPlayers")
AddEventHandler("bpt_ambulancejob:setDeadPlayers", function()
    if isOnDuty then
        for playerId, v in pairs(deadPlayerBlips) do
            RemoveBlip(v)
            deadPlayerBlips[playerId] = nil
        end

        for playerId, status in pairs(deadPlayers) do
            if Config.Debug then
                print("[^2INFO^7] Player Dead | ^5" .. tostring(playerId) .. "^7")
            end
            if status == "distress" then
                if Config.Debug then
                    print("[^2INFO^7] Creating Distress Blip for Player - ^5" .. tostring(playerId) .. "^7")
                end
                local player = GetPlayerFromServerId(playerId)
                local playerPed = GetPlayerPed(player)
                local blip = AddBlipForEntity(playerPed)

                SetBlipSprite(blip, 303)
                SetBlipColour(blip, 1)
                SetBlipFlashes(blip, true)
                SetBlipCategory(blip, 7)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(TranslateCap("blip_dead"))
                EndTextCommandSetBlipName(blip)

                deadPlayerBlips[playerId] = blip
            end
        end
    end
end)

RegisterNetEvent("bpt_ambulancejob:PlayerDistressed")
AddEventHandler("bpt_ambulancejob:PlayerDistressed", function(playerId, playerCoords)
    deadPlayers[playerId] = "distress"

    if isOnDuty then
        if Config.Debug then
            print("[^2INFO^7] Player Distress Recived - ID:^5" .. tostring(playerId) .. "^7")
        end
        ESX.ShowNotification(TranslateCap("unconscious_found"), "error", 10000)
        deadPlayerBlips[playerId] = nil

        local blip = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        SetBlipSprite(blip, Config.DistressBlip.Sprite)
        SetBlipColour(blip, Config.DistressBlip.Color)
        SetBlipScale(blip, Config.DistressBlip.Scale)
        SetBlipFlashes(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("blip_dead"))
        EndTextCommandSetBlipName(blip)

        deadPlayerBlips[playerId] = blip
    end
end)
