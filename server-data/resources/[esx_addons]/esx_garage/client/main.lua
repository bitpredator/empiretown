---@diagnostic disable: undefined-global

local LastMarker, LastPart, thisGarage, thisPound = nil, nil, nil, nil
local HasAlreadyEnteredMarker = false
local next = next
local nearMarker, menuIsShowed = false, false

RegisterNetEvent("esx_garage:closemenu")
AddEventHandler("esx_garage:closemenu", function()
    menuIsShowed = false

    SetNuiFocus(false, false)
    SendNUIMessage({
        hideAll = true,
    })

    if not menuIsShowed and thisPound then
        ESX.TextUI(TranslateCap("access_Impound"))
    end
end)

RegisterNUICallback("escape", function(_, cb)
    TriggerEvent("esx_garage:closemenu")
    cb("ok")
end)

-- Spawn vehicle callback from NUI
RegisterNUICallback("spawnVehicle", function(data, cb)
    -- basic validation
    if not data or not data.spawnPoint or not data.vehicleProps then
        cb("ok")
        return
    end

    -- Calcolo della Z tramite GetGroundZFor_3dCoord (partendo da z alta)
    local spawnCoords = vector3(data.spawnPoint.x, data.spawnPoint.y, 1000.0)
    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0)

    if foundGround then
        local model = data.vehicleProps.model
        local extraOffset = 1.0

        -- offsets base per tipo veicolo (aggiustali a piacere)
        if IsThisModelABike(model) then
            extraOffset = 0.5
        elseif IsThisModelAHeli(model) then
            extraOffset = 3.0
        elseif IsThisModelABoat(model) then
            extraOffset = 5.0
        else
            -- per veicoli molto grandi prova a controllare la classe (se la tua funzione restituisce la classe)
            -- NOTE: GetVehicleClassFromName potrebbe non esistere in tutte le implementazioni; se non funziona rimuovila
            local ok, vclass = pcall(GetVehicleClassFromName, model)
            if ok and tonumber(vclass) and tonumber(vclass) >= 18 then
                extraOffset = 2.0 -- camion, bus, ecc.
            end
        end

        spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ + extraOffset)
    else
        spawnCoords = vector3(spawnCoords.x, spawnCoords.y, 30.0)
    end

    -- Se spawn dal garage (parking)
    if thisGarage then
        if ESX.Game.IsSpawnPointClear(spawnCoords, 2.5) then
            thisGarage = nil
            TriggerServerEvent("esx_garage:updateOwnedVehicle", false, nil, nil, data, spawnCoords)
            TriggerEvent("esx_garage:closemenu")
            ESX.ShowNotification(TranslateCap("veh_released"))
        else
            ESX.ShowNotification(TranslateCap("veh_block"), "error")
        end

    -- Se spawn dall'impound (serve pagamento -> otteniamo costo dinamico dal server)
    elseif thisPound then
        -- richiesta costo dinamico (server calcola in base al tempo di impound)
        ESX.TriggerServerCallback("esx_garage:getImpoundCost", function(finalCost)
            if not finalCost then
                ESX.ShowNotification(TranslateCap("missing_money"))
                cb("ok")
                return
            end

            -- controllo soldi
            ESX.TriggerServerCallback("esx_garage:checkMoney", function(hasMoney)
                if hasMoney then
                    if ESX.Game.IsSpawnPointClear(spawnCoords, 2.5) then
                        -- pagamento (passiamo anche la plate per sicurezza)
                        TriggerServerEvent("esx_garage:payPound", finalCost, data.vehicleProps.plate)

                        -- spawn e aggiornamento DB
                        thisPound = nil
                        TriggerServerEvent("esx_garage:updateOwnedVehicle", false, nil, nil, data, spawnCoords)

                        TriggerEvent("esx_garage:closemenu")
                        ESX.ShowNotification(TranslateCap("veh_released"))
                    else
                        ESX.ShowNotification(TranslateCap("veh_block"), "error")
                    end
                else
                    ESX.ShowNotification(TranslateCap("missing_money"))
                end
            end, finalCost)
        end, data.vehicleProps.plate, data.exitVehicleCost)
    end

    cb("ok")
end)

-- Impound request (from NUI)
RegisterNUICallback("impound", function(data, cb)
    if not data or not data.poundName or not data.vehicleProps or not data.poundSpawnPoint then
        cb("ok")
        return
    end

    -- salvo waypoint e chiamo server per segnare il veicolo come impounded
    TriggerServerEvent("esx_garage:setImpound", data.poundName, data.vehicleProps)
    TriggerEvent("esx_garage:closemenu")

    SetNewWaypoint(data.poundSpawnPoint.x, data.poundSpawnPoint.y)

    cb("ok")
end)

-- Create Blips
CreateThread(function()
    for k, v in pairs(Config.Garages) do
        local blip = AddBlipForCoord(v.EntryPoint.x, v.EntryPoint.y, v.EntryPoint.z)

        SetBlipSprite(blip, v.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.Scale)
        SetBlipColour(blip, v.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("parking_blip_name"))
        EndTextCommandSetBlipName(blip)
    end

    for _, v in pairs(Config.Impounds) do
        local blip = AddBlipForCoord(v.GetOutPoint.x, v.GetOutPoint.y, v.GetOutPoint.z)

        SetBlipSprite(blip, v.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.Scale)
        SetBlipColour(blip, v.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("Impound_blip_name"))
        EndTextCommandSetBlipName(blip)
    end
end)

AddEventHandler("esx_garage:hasEnteredMarker", function(name, part)
    if part == "EntryPoint" then
        local _ = IsPedInAnyVehicle(ESX.PlayerData.ped, false)
        local garage = Config.Garages[name]
        thisGarage = garage
    end

    if part == "GetOutPoint" then
        local pound = Config.Impounds[name]
        thisPound = pound

        ESX.TextUI(TranslateCap("access_Impound"))
    end
end)

AddEventHandler("esx_garage:hasExitedMarker", function()
    thisGarage = nil
    thisPound = nil
    ESX.HideUI()
    TriggerEvent("esx_garage:closemenu")
end)

-- Display markers
CreateThread(function()
    while true do
        local sleep = 500

        local playerPed = ESX.PlayerData.ped
        local coords = GetEntityCoords(playerPed)

        -- parking markers
        for _, v in pairs(Config.Garages) do
            if #(coords - vector3(v.EntryPoint.x, v.EntryPoint.y, v.EntryPoint.z)) < Config.DrawDistance then
                DrawMarker(
                    Config.Markers.EntryPoint.Type,
                    v.EntryPoint.x,
                    v.EntryPoint.y,
                    v.EntryPoint.z,
                    0.0,
                    0.0,
                    0.0,
                    0,
                    0.0,
                    0.0,
                    Config.Markers.EntryPoint.Size.x,
                    Config.Markers.EntryPoint.Size.y,
                    Config.Markers.EntryPoint.Size.z,
                    Config.Markers.EntryPoint.Color.r,
                    Config.Markers.EntryPoint.Color.g,
                    Config.Markers.EntryPoint.Color.b,
                    100,
                    false,
                    true,
                    2,
                    false,
                    false,
                    false,
                    false
                )
                sleep = 0
                break
            end
        end

        -- impound markers
        for _, v in pairs(Config.Impounds) do
            if #(coords - vector3(v.GetOutPoint.x, v.GetOutPoint.y, v.GetOutPoint.z)) < Config.DrawDistance then
                DrawMarker(
                    Config.Markers.GetOutPoint.Type,
                    v.GetOutPoint.x,
                    v.GetOutPoint.y,
                    v.GetOutPoint.z,
                    0.0,
                    0.0,
                    0.0,
                    0,
                    0.0,
                    0.0,
                    Config.Markers.GetOutPoint.Size.x,
                    Config.Markers.GetOutPoint.Size.y,
                    Config.Markers.GetOutPoint.Size.z,
                    Config.Markers.GetOutPoint.Color.r,
                    Config.Markers.GetOutPoint.Color.g,
                    Config.Markers.GetOutPoint.Color.b,
                    100,
                    false,
                    true,
                    2,
                    false,
                    false,
                    false,
                    false
                )
                sleep = 0
                break
            end
        end

        nearMarker = (sleep == 0)

        Wait(sleep)
    end
end)

-- Enter / Exit marker detection & UI flow
CreateThread(function()
    while true do
        if nearMarker then
            local playerPed = ESX.PlayerData.ped
            local coords = GetEntityCoords(playerPed)
            local isInMarker = false
            local currentMarker = nil
            local currentPart = nil

            -- Garage EntryPoints
            for k, v in pairs(Config.Garages) do
                if #(coords - vector3(v.EntryPoint.x, v.EntryPoint.y, v.EntryPoint.z)) < Config.Markers.EntryPoint.Size.x then
                    isInMarker = true
                    currentMarker = k
                    currentPart = "EntryPoint"
                    local isInVehicle = IsPedInAnyVehicle(playerPed, false)

                    if not isInVehicle and IsControlJustReleased(0, 38) and not menuIsShowed then
                        ESX.TriggerServerCallback("esx_garage:getVehiclesInParking", function(vehicles)
                            if next(vehicles) then
                                menuIsShowed = true

                                -- crea liste locali per evitare duplicati
                                local localVehiclesList = {}
                                local localImpoundedList = {}

                                for i = 1, #vehicles, 1 do
                                    table.insert(localVehiclesList, {
                                        model = GetDisplayNameFromVehicleModel(vehicles[i].vehicle.model),
                                        plate = vehicles[i].plate,
                                        props = vehicles[i].vehicle,
                                    })
                                end

                                local spawnPoint = {
                                    x = v.SpawnPoint.x,
                                    y = v.SpawnPoint.y,
                                    heading = v.SpawnPoint.heading,
                                }

                                ESX.TriggerServerCallback("esx_garage:getVehiclesImpounded", function(impounded)
                                    if next(impounded) then
                                        for i = 1, #impounded, 1 do
                                            table.insert(localImpoundedList, {
                                                model = GetDisplayNameFromVehicleModel(impounded[i].vehicle.model),
                                                plate = impounded[i].plate,
                                                props = impounded[i].vehicle,
                                            })
                                        end

                                        local poundSpawnPoint = {
                                            x = Config.Impounds[v.ImpoundedName].GetOutPoint.x,
                                            y = Config.Impounds[v.ImpoundedName].GetOutPoint.y,
                                        }

                                        SendNUIMessage({
                                            showMenu = true,
                                            type = "garage",
                                            vehiclesList = { json.encode(localVehiclesList) },
                                            vehiclesImpoundedList = { json.encode(localImpoundedList) },
                                            poundName = v.ImpoundedName,
                                            poundSpawnPoint = poundSpawnPoint,
                                            spawnPoint = spawnPoint,
                                            locales = {
                                                action = TranslateCap("veh_exit"),
                                                veh_model = TranslateCap("veh_model"),
                                                veh_plate = TranslateCap("veh_plate"),
                                                veh_condition = TranslateCap("veh_condition"),
                                                veh_action = TranslateCap("veh_action"),
                                                impound_action = TranslateCap("impound_action"),
                                            },
                                        })
                                    else
                                        SendNUIMessage({
                                            showMenu = true,
                                            type = "garage",
                                            vehiclesList = { json.encode(localVehiclesList) },
                                            spawnPoint = spawnPoint,
                                            locales = {
                                                action = TranslateCap("veh_exit"),
                                                veh_model = TranslateCap("veh_model"),
                                                veh_plate = TranslateCap("veh_plate"),
                                                veh_condition = TranslateCap("veh_condition"),
                                                veh_action = TranslateCap("veh_action"),
                                                no_veh_impounded = TranslateCap("no_veh_impounded"),
                                            },
                                        })
                                    end
                                end)
                                SetNuiFocus(true, true)
                                if menuIsShowed then
                                    ESX.HideUI()
                                end
                            else
                                -- nessun veicolo in parking, mostro solo impounded se ci sono
                                menuIsShowed = true
                                local localImpoundedList = {}

                                ESX.TriggerServerCallback("esx_garage:getVehiclesImpounded", function(impounded)
                                    if next(impounded) then
                                        for i = 1, #impounded, 1 do
                                            table.insert(localImpoundedList, {
                                                model = GetDisplayNameFromVehicleModel(impounded[i].vehicle.model),
                                                plate = impounded[i].plate,
                                                props = impounded[i].vehicle,
                                            })
                                        end

                                        local poundSpawnPoint = {
                                            x = Config.Impounds[v.ImpoundedName].GetOutPoint.x,
                                            y = Config.Impounds[v.ImpoundedName].GetOutPoint.y,
                                        }

                                        SendNUIMessage({
                                            showMenu = true,
                                            type = "garage",
                                            vehiclesImpoundedList = { json.encode(localImpoundedList) },
                                            poundName = v.ImpoundedName,
                                            poundSpawnPoint = poundSpawnPoint,
                                            locales = {
                                                action = TranslateCap("veh_exit"),
                                                veh_model = TranslateCap("veh_model"),
                                                veh_plate = TranslateCap("veh_plate"),
                                                veh_condition = TranslateCap("veh_condition"),
                                                veh_action = TranslateCap("veh_action"),
                                                no_veh_parking = TranslateCap("no_veh_parking"),
                                                no_veh_impounded = TranslateCap("no_veh_impounded"),
                                                impound_action = TranslateCap("impound_action"),
                                            },
                                        })
                                    else
                                        SendNUIMessage({
                                            showMenu = true,
                                            type = "garage",
                                            locales = {
                                                action = TranslateCap("veh_exit"),
                                                veh_model = TranslateCap("veh_model"),
                                                veh_plate = TranslateCap("veh_plate"),
                                                veh_condition = TranslateCap("veh_condition"),
                                                veh_action = TranslateCap("veh_action"),
                                                no_veh_parking = TranslateCap("no_veh_parking"),
                                            },
                                        })
                                    end
                                end)
                                SetNuiFocus(true, true)
                                if menuIsShowed then
                                    ESX.HideUI()
                                end
                            end
                        end, currentMarker)
                    end
                    break
                end
            end

            -- Impound GetOutPoint
            for k, v in pairs(Config.Impounds) do
                if #(coords - vector3(v.GetOutPoint.x, v.GetOutPoint.y, v.GetOutPoint.z)) < 2.0 then
                    isInMarker = true
                    currentMarker = k
                    currentPart = "GetOutPoint"

                    if IsControlJustReleased(0, 38) and not menuIsShowed then
                        ESX.TriggerServerCallback("esx_garage:getVehiclesInPound", function(vehicles)
                            if next(vehicles) then
                                menuIsShowed = true

                                local localVehiclesList = {}

                                for i = 1, #vehicles, 1 do
                                    table.insert(localVehiclesList, {
                                        model = GetDisplayNameFromVehicleModel(vehicles[i].vehicle.model),
                                        plate = vehicles[i].plate,
                                        props = vehicles[i].vehicle,
                                    })
                                end

                                local spawnPoint = {
                                    x = v.SpawnPoint.x,
                                    y = v.SpawnPoint.y,
                                    heading = v.SpawnPoint.heading,
                                }

                                -- NON chiamare updateOwnedVehicle qui (era un bug)
                                SendNUIMessage({
                                    showMenu = true,
                                    type = "impound",
                                    vehiclesList = { json.encode(localVehiclesList) },
                                    spawnPoint = spawnPoint,
                                    poundCost = v.Cost,
                                    locales = {
                                        action = TranslateCap("pay_impound"),
                                        veh_model = TranslateCap("veh_model"),
                                        veh_plate = TranslateCap("veh_plate"),
                                        veh_condition = TranslateCap("veh_condition"),
                                        veh_action = TranslateCap("veh_action"),
                                    },
                                })

                                SetNuiFocus(true, true)
                                if menuIsShowed then
                                    ESX.HideUI()
                                end
                            else
                                ESX.ShowNotification(TranslateCap("no_veh_Impound"))
                            end
                        end, currentMarker)
                    end
                    break
                end
            end

            -- Marker enter/exit events
            if isInMarker and (not HasAlreadyEnteredMarker or (LastMarker ~= currentMarker or LastPart ~= currentPart)) then
                if LastMarker ~= currentMarker or LastPart ~= currentPart then
                    TriggerEvent("esx_garage:hasExitedMarker")
                end

                HasAlreadyEnteredMarker = true
                LastMarker = currentMarker
                LastPart = currentPart

                TriggerEvent("esx_garage:hasEnteredMarker", currentMarker, currentPart)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent("esx_garage:hasExitedMarker")
            end

            -- store vehicle while inside vehicle
            if isInMarker then
                local playerPed = ESX.PlayerData.ped
                if IsPedInAnyVehicle(playerPed, false) and IsControlJustReleased(0, 38) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                    ESX.TriggerServerCallback("esx_garage:checkVehicleOwner", function(owner)
                        if owner then
                            ESX.Game.DeleteVehicle(vehicle)
                            TriggerServerEvent("esx_garage:updateOwnedVehicle", true, currentMarker, nil, { vehicleProps = vehicleProps })
                        else
                            ESX.ShowNotification(TranslateCap("not_owning_veh"), "error")
                        end
                    end, vehicleProps.plate)
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)
