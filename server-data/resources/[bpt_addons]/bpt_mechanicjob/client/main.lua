local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, "", {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isBusy = false

function SelectRandomTowable()
    local index = GetRandomIntInRange(1, #Config.Towables)

    for k, v in pairs(Config.Zones) do
        if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
            return k
        end
    end
end

function StartNPCJob()
    NPCOnJob = true

    NPCTargetTowableZone = SelectRandomTowable()
    local zone = Config.Zones[NPCTargetTowableZone]

    Blips["NPCTargetTowableZone"] = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
    SetBlipRoute(Blips["NPCTargetTowableZone"], true)

    ESX.ShowNotification(TranslateCap("drive_to_indicated"))
end

function StopNPCJob(cancel)
    if Blips["NPCTargetTowableZone"] then
        RemoveBlip(Blips["NPCTargetTowableZone"])
        Blips["NPCTargetTowableZone"] = nil
    end

    if Blips["NPCDelivery"] then
        RemoveBlip(Blips["NPCDelivery"])
        Blips["NPCDelivery"] = nil
    end

    Config.Zones.VehicleDelivery.Type = -1

    NPCOnJob = false
    NPCTargetTowable = nil
    NPCTargetTowableZone = nil
    NPCHasSpawnedTowable = false
    NPCHasBeenNextToTowable = false

    if cancel then
        ESX.ShowNotification(TranslateCap("mission_canceled"), "error")
    end
end

function OpenMechanicActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-gear", title = TranslateCap("mechanic") },
        { icon = "fas fa-car", title = TranslateCap("vehicle_list"), value = "vehicle_list" },
        { icon = "fas fa-shirt", title = TranslateCap("work_wear"), value = "cloakroom" },
        { icon = "fas fa-shirt", title = TranslateCap("civ_wear"), value = "cloakroom2" },
        { icon = "fas fa-box", title = TranslateCap("deposit_stock"), value = "put_stock" },
        { icon = "fas fa-box", title = TranslateCap("withdraw_stock"), value = "get_stock" },
    }

    if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == "boss" then
        elements[#elements + 1] = {
            icon = "fas fa-boss",
            title = TranslateCap("boss_actions"),
            value = "boss_actions",
        }
    end

    ESX.OpenContext("right", elements, function(_, element)
        if element.value == "vehicle_list" then
            if Config.EnableSocietyOwnedVehicles then
                local elements2 = {
                    { unselectable = true, icon = "fas fa-car", title = TranslateCap("service_vehicle") },
                }

                ESX.TriggerServerCallback("bpt_society:getVehiclesInGarage", function(vehicles)
                    for i = 1, #vehicles, 1 do
                        elements2[#elements2 + 1] = {
                            icon = "fas fa-car",
                            title = GetDisplayNameFromVehicleModel(vehicles[i].model) .. " [" .. vehicles[i].plate .. "]",
                            value = vehicles[i],
                        }
                    end

                    ESX.OpenContext("right", elements2, function(_, element2)
                        ESX.CloseContext()
                        local vehicleProps = element2.value

                        ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
                            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                            local playerPed = PlayerPedId()
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        end)

                        TriggerServerEvent("bpt_society:removeVehicleFromGarage", "mechanic", vehicleProps)
                    end)
                end, "mechanic")
            else
                local elements2 = {
                    { unselectable = true, icon = "fas fa-car", title = TranslateCap("service_vehicle") },
                    { icon = "fas fa-truck", title = TranslateCap("flat_bed"), value = "flatbed3" },
                    { icon = "fas fa-truck", title = TranslateCap("tow_truck"), value = "towtruck2" },
                }

                if Config.EnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == "boss" or ESX.PlayerData.job.grade_name == "chief" or ESX.PlayerData.job.grade_name == "experimente") then
                    elements2[#elements2 + 1] = {
                        icon = "fas fa-truck",
                        title = "Slamvan",
                        value = "slamvan3",
                    }
                end

                ESX.OpenContext("right", elements2, function(_, element2)
                    if Config.MaxInService == -1 then
                        ESX.CloseContext()
                        ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                            local playerPed = PlayerPedId()
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        end)
                    else
                        ESX.TriggerServerCallback("esx_service:enableService", function(canTakeService, maxInService, inServiceCount)
                            if canTakeService then
                                ESX.CloseContext()
                                ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                                    local playerPed = PlayerPedId()
                                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                end)
                            else
                                ESX.ShowNotification(TranslateCap("service_full") .. inServiceCount .. "/" .. maxInService)
                            end
                        end, "mechanic")
                    end
                end)
            end
        elseif element.value == "cloakroom" then
            ESX.CloseContext()
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_male)
                else
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_female)
                end
            end)
        elseif element.value == "cloakroom2" then
            ESX.CloseContext()
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
        elseif Config.OxInventory and (element.value == "put_stock" or element.value == "get_stock") then
            exports.ox_inventory:openInventory("stash", "society_mechanic")
            return ESX.CloseContext()
        elseif element.value == "put_stock" then
            OpenPutStocksMenu()
        elseif element.value == "get_stock" then
            OpenGetStocksMenu()
        elseif element.value == "boss_actions" then
            TriggerEvent("bpt_society:openBossMenu", "mechanic", function()
                ESX.CloseContext()
            end)
        end
    end, function()
        CurrentAction = "mechanic_actions_menu"
        CurrentActionMsg = TranslateCap("open_actions")
        CurrentActionData = {}
    end)
end

function OpenMobileMechanicActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-gear", title = TranslateCap("mechanic") },
        { icon = "fas fa-gear", title = TranslateCap("billing"), value = "billing" },
        { icon = "fas fa-gear", title = TranslateCap("hijack"), value = "hijack_vehicle" },
        { icon = "fas fa-gear", title = TranslateCap("repair"), value = "fix_vehicle" },
        { icon = "fas fa-gear", title = TranslateCap("clean"), value = "clean_vehicle" },
        { icon = "fas fa-gear", title = TranslateCap("imp_veh"), value = "del_vehicle" },
        { icon = "fas fa-gear", title = TranslateCap("tow"), value = "dep_vehicle" },
    }

    ESX.OpenContext("right", elements, function(_, element)
        if isBusy then
            return
        end

        if element.value == "billing" then
            local elements2 = {
                { unselectable = true, icon = "fas fa-scroll", title = element.title },
                { title = "Amount", input = true, inputType = "number", inputMin = 1, inputMax = 10000000, inputPlaceholder = "Amount to bill.." },
                { icon = "fas fa-check-double", title = "Confirm", value = "confirm" },
            }

            ESX.OpenContext("right", elements2, function(menu2)
                local amount = tonumber(menu2.eles[2].inputValue)

                if amount == nil or amount < 0 then
                    ESX.ShowNotification(TranslateCap("amount_invalid"), "error")
                else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification(TranslateCap("no_players_nearby"), "error")
                    else
                        ESX.CloseContext()
                        TriggerServerEvent("bpt_billing:sendBill", GetPlayerServerId(closestPlayer), "society_mechanic", TranslateCap("mechanic"), amount)
                    end
                end
            end)
        elseif element.value == "hijack_vehicle" then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local _ = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(TranslateCap("inside_vehicle"))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                CreateThread(function()
                    Wait(10000)

                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(TranslateCap("vehicle_unlocked"))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(TranslateCap("no_vehicle_nearby"))
            end
        elseif element.value == "fix_vehicle" then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local _ = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(TranslateCap("inside_vehicle"))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
                CreateThread(function()
                    Wait(20000)

                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    SetVehicleEngineOn(vehicle, true, true, true)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(TranslateCap("vehicle_repaired"))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(TranslateCap("no_vehicle_nearby"))
            end
        elseif element.value == "clean_vehicle" then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local _ = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(TranslateCap("inside_vehicle"))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
                CreateThread(function()
                    Wait(10000)

                    SetVehicleDirtLevel(vehicle, 0)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(TranslateCap("vehicle_cleaned"))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(TranslateCap("no_vehicle_nearby"))
            end
        elseif element.value == "del_vehicle" then
            local playerPed = PlayerPedId()

            if IsPedSittingInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    ESX.ShowNotification(TranslateCap("vehicle_impounded"))
                    ESX.Game.DeleteVehicle(vehicle)
                else
                    ESX.ShowNotification(TranslateCap("must_seat_driver"))
                end
            else
                local vehicle = ESX.Game.GetVehicleInDirection()

                if DoesEntityExist(vehicle) then
                    ESX.ShowNotification(TranslateCap("vehicle_impounded"))
                    ESX.Game.DeleteVehicle(vehicle)
                else
                    ESX.ShowNotification(TranslateCap("must_near"))
                end
            end
        elseif element.value == "dep_vehicle" then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, true)

            local towmodel = `flatbed3`
            local isVehicleTow = IsVehicleModel(vehicle, towmodel)

            if isVehicleTow then
                local targetVehicle = ESX.Game.GetVehicleInDirection()

                if CurrentlyTowedVehicle == nil then
                    if targetVehicle ~= 0 then
                        if not IsPedInAnyVehicle(playerPed, true) then
                            if vehicle ~= targetVehicle then
                                AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                CurrentlyTowedVehicle = targetVehicle
                                ESX.ShowNotification(TranslateCap("vehicle_success_attached"))

                                if NPCOnJob then
                                    if NPCTargetTowable == targetVehicle then
                                        ESX.ShowNotification(TranslateCap("please_drop_off"))
                                        Config.Zones.VehicleDelivery.Type = 1

                                        if Blips["NPCTargetTowableZone"] then
                                            RemoveBlip(Blips["NPCTargetTowableZone"])
                                            Blips["NPCTargetTowableZone"] = nil
                                        end

                                        Blips["NPCDelivery"] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
                                        SetBlipRoute(Blips["NPCDelivery"], true)
                                    end
                                end
                            else
                                ESX.ShowNotification(TranslateCap("cant_attach_own_tt"))
                            end
                        end
                    else
                        ESX.ShowNotification(TranslateCap("no_veh_att"))
                    end
                else
                    AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    DetachEntity(CurrentlyTowedVehicle, true, true)

                    if NPCOnJob then
                        if NPCTargetDeleterZone then
                            if CurrentlyTowedVehicle == NPCTargetTowable then
                                ESX.Game.DeleteVehicle(NPCTargetTowable)
                                TriggerServerEvent("bpt_mechanicjob:onNPCJobMissionCompleted")
                                StopNPCJob()
                                NPCTargetDeleterZone = false
                            else
                                ESX.ShowNotification(TranslateCap("not_right_veh"))
                            end
                        else
                            ESX.ShowNotification(TranslateCap("not_right_place"))
                        end
                    end

                    CurrentlyTowedVehicle = nil
                    ESX.ShowNotification(TranslateCap("veh_det_succ"))
                end
            else
                ESX.ShowNotification(TranslateCap("imp_flatbed"))
            end

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(TranslateCap("inside_vehicle"))
                return
            end
        end
    end)
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback("bpt_mechanicjob:getStockItems", function(items)
        local elements = {
            { unselectable = true, icon = "fas fa-box", title = TranslateCap("mechanic_stock") },
        }

        for i = 1, #items, 1 do
            elements[#elements + 1] = {
                icon = "fas fa-box",
                title = "x" .. items[i].count .. " " .. items[i].label,
                value = items[i].name,
            }
        end

        ESX.OpenContext("right", elements, function(_, element)
            local itemName = element.value

            local elements2 = {
                { unselectable = true, icon = "fas fa-box", title = element.title },
                { title = "Amount", input = true, inputType = "number", inputMin = 1, inputMax = 100, inputPlaceholder = "Amount to withdraw.." },
                { icon = "fas fa-check-double", title = "Confirm", value = "confirm" },
            }

            ESX.OpenContext("right", elements2, function(menu2)
                local count = tonumber(menu2.eles[2].inputValue)

                if count == nil then
                    ESX.ShowNotification(TranslateCap("invalid_quantity"))
                else
                    ESX.CloseContext()
                    TriggerServerEvent("bpt_mechanicjob:getStockItem", itemName, count)

                    Wait(1000)
                    OpenGetStocksMenu()
                end
            end)
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback("bpt_mechanicjob:getPlayerInventory", function(inventory)
        local elements = {
            { unselectable = true, icon = "fas fa-box", title = TranslateCap("inventory") },
        }

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                elements[#elements + 1] = {
                    icon = "fas fa-box",
                    title = item.label .. " x" .. item.count,
                    type = "item_standard",
                    value = item.name,
                }
            end
        end

        ESX.OpenContext("right", elements, function(_, element)
            local itemName = element.value

            local elements2 = {
                { unselectable = true, icon = "fas fa-box", title = element.title },
                { title = "Amount", input = true, inputType = "number", inputMin = 1, inputMax = 100, inputPlaceholder = "Amount to deposit.." },
                { icon = "fas fa-check-double", title = "Confirm", value = "confirm" },
            }

            ESX.OpenContext("right", elements2, function(menu2)
                local count = tonumber(menu2.eles[2].inputValue)

                if count == nil then
                    ESX.ShowNotification(TranslateCap("invalid_quantity"))
                else
                    ESX.CloseContext()
                    TriggerServerEvent("bpt_mechanicjob:putStockItems", itemName, count)

                    Wait(1000)
                    OpenPutStocksMenu()
                end
            end)
        end)
    end)
end

RegisterNetEvent("bpt_mechanicjob:onHijack")
AddEventHandler("bpt_mechanicjob:onHijack", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = ESX.Game.GetClosestVehicle(coords)
        end

        local chance = math.random(100)
        local alarm = math.random(100)

        if DoesEntityExist(vehicle) then
            if alarm <= 33 then
                SetVehicleAlarm(vehicle, true)
                StartVehicleAlarm(vehicle)
            end

            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

            CreateThread(function()
                Wait(10000)
                if chance <= 66 then
                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    ClearPedTasksImmediately(playerPed)
                    ESX.ShowNotification(TranslateCap("veh_unlocked"))
                else
                    ESX.ShowNotification(TranslateCap("hijack_failed"))
                    ClearPedTasksImmediately(playerPed)
                end
            end)
        end
    end
end)

RegisterNetEvent("bpt_mechanicjob:onfixkit")
AddEventHandler("bpt_mechanicjob:onfixkit", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = ESX.Game.GetClosestVehicle(coords)
        end

        if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            CreateThread(function()
                Wait(20000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification(TranslateCap("veh_repaired"))
            end)
        end
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler("bpt_mechanicjob:hasEnteredMarker", function(zone)
    if zone == "NPCJobTargetTowable" then
    elseif zone == "VehicleDelivery" then
        NPCTargetDeleterZone = true
    elseif zone == "MechanicActions" then
        CurrentAction = "mechanic_actions_menu"
        CurrentActionMsg = TranslateCap("open_actions")
        CurrentActionData = {}
    elseif zone == "VehicleDeleter" then
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            CurrentAction = "delete_vehicle"
            CurrentActionMsg = TranslateCap("veh_stored")
            CurrentActionData = { vehicle = vehicle }
        end
    end

    if zone ~= "VehicleSpawnPoint" then
        ESX.TextUI(CurrentActionMsg)
    end
end)

AddEventHandler("bpt_mechanicjob:hasExitedMarker", function(zone)
    if zone == "VehicleDelivery" then
        NPCTargetDeleterZone = false
    end
    CurrentAction = nil
    ESX.CloseContext()
    ESX.HideUI()
end)

AddEventHandler("bpt_mechanicjob:hasExitedEntityZone", function(entity)
    if CurrentAction == "remove_entity" then
        CurrentAction = nil
    end
    ESX.CloseContext()
    ESX.HideUI()
end)

-- Pop NPC mission vehicle when inside area
CreateThread(function()
    while true do
        local Sleep = 1500

        if NPCTargetTowableZone and not NPCHasSpawnedTowable then
            Sleep = 0
            local coords = GetEntityCoords(PlayerPedId())
            local zone = Config.Zones[NPCTargetTowableZone]

            if #(coords - zone.Pos) < Config.NPCSpawnDistance then
                local model = Config.Vehicles[GetRandomIntInRange(1, #Config.Vehicles)]

                ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
                    NPCTargetTowable = vehicle
                end)

                NPCHasSpawnedTowable = true
            end
        end

        if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
            Sleep = 500
            local coords = GetEntityCoords(PlayerPedId())
            local zone = Config.Zones[NPCTargetTowableZone]

            if #(coords - zone.Pos) < Config.NPCNextToDistance then
                Sleep = 0
                ESX.ShowNotification(TranslateCap("please_tow"))
                NPCHasBeenNextToTowable = true
            end
        end
        Wait(Sleep)
    end
end)

-- Create Blips
CreateThread(function()
    local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

    SetBlipSprite(blip, 446)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(TranslateCap("mechanic"))
    EndTextCommandSetBlipName(blip)
end)

-- Display markers
CreateThread(function()
    while true do
        local Sleep = 2000

        if ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then
            Sleep = 500
            local coords = GetEntityCoords(PlayerPedId())

            for _, v in pairs(Config.Zones) do
                if v.Type ~= -1 and #(coords - v.Pos) < Config.DrawDistance then
                    Sleep = 0
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, true, nil, nil, false)
                end
            end
        end
        Wait(Sleep)
    end
end)

-- Enter / Exit marker events
CreateThread(function()
    while true do
        local Sleep = 500

        if ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then
            local coords = GetEntityCoords(PlayerPedId())
            local isInMarker = false
            local currentZone = nil

            for k, v in pairs(Config.Zones) do
                if #(coords - v.Pos) < v.Size.x then
                    Sleep = 0
                    isInMarker = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone = currentZone
                TriggerEvent("bpt_mechanicjob:hasEnteredMarker", currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent("bpt_mechanicjob:hasExitedMarker", LastZone)
            end
        end
        Wait(Sleep)
    end
end)

-- Key Controls
CreateThread(function()
    while true do
        local sleep = 500
        if CurrentAction then
            sleep = 0
            if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then
                if CurrentAction == "mechanic_actions_menu" then
                    OpenMechanicActionsMenu()
                elseif CurrentAction == "delete_vehicle" then
                    if Config.EnableSocietyOwnedVehicles then
                        local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
                        TriggerServerEvent("bpt_society:putVehicleInGarage", "mechanic", vehicleProps)
                    else
                        local entityModel = GetEntityModel(CurrentActionData.vehicle)

                        if entityModel == `flatbed3` or entityModel == `towtruck2` or entityModel == `slamvan3` then
                            TriggerServerEvent("esx_service:disableService", "mechanic")
                        end
                    end
                    ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                elseif CurrentAction == "remove_entity" then
                    DeleteEntity(CurrentActionData.entity)
                end

                CurrentAction = nil
            end
        end
        Wait(sleep)
    end
end)
RegisterCommand("mechanicMenu", function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then
        OpenMobileMechanicActionsMenu()
    end
end, false)

RegisterCommand("mechanicjob", function()
    local playerPed = PlayerPedId()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then
        if NPCOnJob then
            if GetGameTimer() - NPCLastCancel > 5 * 60000 then
                StopNPCJob(true)
                NPCLastCancel = GetGameTimer()
            else
                ESX.ShowNotification(TranslateCap("wait_five"), "error")
            end
        else
            if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `flatbed3`) then
                StartNPCJob()
            else
                ESX.ShowNotification(TranslateCap("must_in_flatbed"), "error")
            end
        end
    end
end, false)

RegisterKeyMapping("mechanicMenu", "Open Mechanic Menu", "keyboard", Config.Controls.mechanicMenu)
RegisterKeyMapping("mechanicjob", "Togggle NPC Job", "keyboard", Config.Controls.toggleNPCJob)

AddEventHandler("esx:onPlayerDeath", function() end)
AddEventHandler("esx:onPlayerSpawn", function() end)
