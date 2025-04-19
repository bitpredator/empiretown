---@diagnostic disable: undefined-global
local HasAlreadyEnteredMarker, IsInShopMenu = false, false
local CurrentAction, CurrentActionMsg, LastZone, currentDisplayVehicle, CurrentVehicleData
local CurrentActionData, Vehicles, Categories = {}, {}, {}

function GetVehicleFromModel(model)
    for i = 1, #Vehicles do
        local vehicle = Vehicles[i]
        if vehicle.model == model then
            return vehicle
        end
    end
end

function GetVehicles()
    ESX.TriggerServerCallback("esx_vehicleshop:getCategories", function(categories)
        Categories = categories
    end)

    ESX.TriggerServerCallback("esx_vehicleshop:getVehicles", function(vehicles)
        Vehicles = vehicles
    end)
end

AddEventHandler("onResourceStart", GetVehicles)

function PlayerManagement()
    if not Config.EnablePlayerManagement then
        return
    end

    if ESX.PlayerData.job.name == "cardealer" then
        Config.Zones.ShopEntering.Type = 1
        if ESX.PlayerData.job.grade_name == "boss" then
            Config.Zones.BossActions.Type = 1
        end
        return
    end

    Config.Zones.ShopEntering.Type = -1
    Config.Zones.BossActions.Type = -1
    Config.Zones.ResellVehicle.Type = -1
end

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerManagement()
end)

RegisterNetEvent("esx_vehicleshop:sendCategories")
AddEventHandler("esx_vehicleshop:sendCategories", function(categories)
    Categories = categories
end)

RegisterNetEvent("esx_vehicleshop:sendVehicles")
AddEventHandler("esx_vehicleshop:sendVehicles", function(vehicles)
    Vehicles = vehicles
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function()
    PlayerManagement()
    GetVehicles()
end)

function DeleteDisplayVehicleInsideShop()
    local attempt = 0

    if currentDisplayVehicle and DoesEntityExist(currentDisplayVehicle) then
        while DoesEntityExist(currentDisplayVehicle) and not NetworkHasControlOfEntity(currentDisplayVehicle) and attempt < 100 do
            Wait(100)
            NetworkRequestControlOfEntity(currentDisplayVehicle)
            attempt = attempt + 1
        end

        if DoesEntityExist(currentDisplayVehicle) and NetworkHasControlOfEntity(currentDisplayVehicle) then
            ESX.Game.DeleteVehicle(currentDisplayVehicle)
        end
    end
end

function ReturnVehicleProvider()
    ESX.TriggerServerCallback("esx_vehicleshop:getCommercialVehicles", function(vehicles)
        local elements = {}

        for _, v in ipairs(vehicles) do
            local returnPrice = ESX.Math.Round(v.price * 0.75)
            local vehicleLabel = GetVehicleFromModel(v.vehicle).name

            table.insert(elements, {
                label = ('%s [<span style="color:orange;">%s</span>]'):format(vehicleLabel, TranslateCap("generic_shopitem", ESX.Math.GroupDigits(returnPrice))),
                value = v.vehicle,
            })
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "return_provider_menu", {
            title = TranslateCap("return_provider_menu"),
            align = "top-left",
            elements = elements,
        }, function(data, menu)
            TriggerServerEvent("esx_vehicleshop:returnProvider", data.current.value)

            Wait(300)
            menu.close()
            ReturnVehicleProvider()
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function StartShopRestriction()
    CreateThread(function()
        while IsInShopMenu do
            Wait(0)

            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end)
end

function OpenShopMenu()
    if #Vehicles == 0 then
        print("[esx_vehicleshop] [^3ERROR^7] No vehicles found")
        return
    end

    IsInShopMenu = true
    ESX.ShowContext("vehicle_shop", {
        title = TranslateCap("car_dealer"),
        options = {
            {
                title = TranslateCap("categories"),
                description = TranslateCap("choose_category"),
                arrow = true,
                event = "esx_vehicleshop:showCategoryVehicles",
                args = { categories = Categories, vehicles = Vehicles },
            },
        },
    })

    CreateThread(function()
        while IsInShopMenu do
            Wait(0)
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end)
end

RegisterNetEvent("esx_vehicleshop:showCategoryVehicles")
AddEventHandler("esx_vehicleshop:showCategoryVehicles", function(data)
    local categoryVehicles = {}
    local options = {}

    for i = 1, #data.categories do
        local vehicles = {}
        for k, v in ipairs(data.vehicles) do
            if data.categories[i].name == v.category then
                table.insert(vehicles, v)
            end
        end
        if #vehicles > 0 then
            table.insert(options, {
                title = data.categories[i].label,
                description = TranslateCap("press_to_view"),
                arrow = true,
                event = "esx_vehicleshop:showVehicleList",
                args = { vehicles = vehicles },
            })
        end
    end

    ESX.ShowContext("vehicle_categories", {
        title = TranslateCap("categories"),
        options = options,
    })
end)

RegisterNetEvent("esx_vehicleshop:showVehicleList")
AddEventHandler("esx_vehicleshop:showVehicleList", function(data)
    local options = {}

    for i = 1, #data.vehicles do
        local vehicle = data.vehicles[i]
        table.insert(options, {
            title = vehicle.name,
            description = TranslateCap("generic_shopitem", ESX.Math.GroupDigits(vehicle.price)),
            event = "esx_vehicleshop:showVehicleInfo",
            args = { vehicle = vehicle },
        })
    end

    ESX.ShowContext("vehicle_list", {
        title = TranslateCap("choose_vehicle"),
        options = options,
    })
end)

RegisterNetEvent("esx_vehicleshop:showVehicleInfo")
AddEventHandler("esx_vehicleshop:showVehicleInfo", function(data)
    local vehicle = data.vehicle
    ESX.ShowContext("vehicle_info", {
        title = vehicle.name,
        options = {
            {
                title = TranslateCap("buy_vehicle"),
                description = TranslateCap("generic_shopitem", ESX.Math.GroupDigits(vehicle.price)),
                event = "esx_vehicleshop:attemptPurchase",
                args = { vehicle = vehicle },
            },
        },
    })
end)

RegisterNetEvent("esx_vehicleshop:attemptPurchase")
AddEventHandler("esx_vehicleshop:attemptPurchase", function(data)
    local vehicle = data.vehicle
    if Config.EnablePlayerManagement then
        ESX.TriggerServerCallback("esx_vehicleshop:buyCarDealerVehicle", function(success)
            if success then
                IsInShopMenu = false
                DeleteDisplayVehicleInsideShop()

                CurrentAction = "shop_menu"
                CurrentActionMsg = TranslateCap("shop_menu")
                CurrentActionData = {}

                local playerPed = PlayerPedId()
                FreezeEntityPosition(playerPed, false)
                SetEntityVisible(playerPed, true, true)
                SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

                ESX.ShowNotification(TranslateCap("vehicle_purchased"))
            else
                ESX.ShowNotification(TranslateCap("broke_company"))
            end
        end, vehicle.model)
    else
        local generatedPlate = GeneratePlate()
        ESX.TriggerServerCallback("esx_vehicleshop:buyVehicle", function(success)
            if success then
                IsInShopMenu = false
                DeleteDisplayVehicleInsideShop()

                ESX.Game.SpawnVehicle(vehicle.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetVehicleNumberPlateText(vehicle, generatedPlate)
                    FreezeEntityPosition(PlayerPedId(), false)
                    SetEntityVisible(PlayerPedId(), true, true)
                end)

                ESX.ShowNotification(TranslateCap("vehicle_purchased"))
            else
                ESX.ShowNotification(TranslateCap("not_enough_money"))
            end
        end, vehicle.model, generatedPlate)
    end
end)

function WaitForVehicleToLoad(modelHash)
    modelHash = (type(modelHash) == "number" and modelHash or joaat(modelHash))

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)

        BeginTextCommandBusyspinnerOn("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("shop_awaiting_model"))
        EndTextCommandBusyspinnerOn(4)

        while not HasModelLoaded(modelHash) do
            Wait(0)
            DisableAllControlActions(0)
        end

        BusyspinnerOff()
    end
end

function OpenResellerMenu()
    ESX.ShowContext("reseller", {
        title = TranslateCap("car_dealer"),
        options = {
            {
                title = TranslateCap("buy_vehicle"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "buy_vehicle" },
            },
            {
                title = TranslateCap("pop_vehicle"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "pop_vehicle" },
            },
            {
                title = TranslateCap("depop_vehicle"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "depop_vehicle" },
            },
            {
                title = TranslateCap("return_provider"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "return_provider" },
            },
            {
                title = TranslateCap("create_bill"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "create_bill" },
            },
            {
                title = TranslateCap("get_rented_vehicles"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "get_rented_vehicles" },
            },
            {
                title = TranslateCap("set_vehicle_owner_sell"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "set_vehicle_owner_sell" },
            },
            {
                title = TranslateCap("set_vehicle_owner_rent"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "set_vehicle_owner_rent" },
            },
            {
                title = TranslateCap("deposit_stock"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "put_stock" },
            },
            {
                title = TranslateCap("take_stock"),
                event = "esx_vehicleshop:resellerAction",
                args = { action = "get_stock" },
            },
        },
    })

    CurrentAction = "reseller_menu"
    CurrentActionMsg = TranslateCap("shop_menu")
    CurrentActionData = {}
end

RegisterNetEvent("esx_vehicleshop:resellerAction")
AddEventHandler("esx_vehicleshop:resellerAction", function(data)
    local action = data.action

    if Config.OxInventory and (action == "put_stock" or action == "get_stock") then
        exports.ox_inventory:openInventory("stash", "society_cardealer")
    elseif action == "buy_vehicle" then
        OpenShopMenu()
    elseif action == "put_stock" then
        OpenPutStocksMenu()
    elseif action == "get_stock" then
        OpenGetStocksMenu()
    elseif action == "pop_vehicle" then
        OpenPopVehicleMenu()
    elseif action == "depop_vehicle" then
        if currentDisplayVehicle then
            DeleteDisplayVehicleInsideShop()
        else
            ESX.ShowNotification(TranslateCap("no_current_vehicle"))
        end
    elseif action == "return_provider" then
        ReturnVehicleProvider()
    elseif action == "create_bill" then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance < 3 then
            ESX.ShowContext("create_bill", {
                title = TranslateCap("invoice_amount"),
                options = {
                    {
                        title = TranslateCap("amount"),
                        input = true,
                        inputType = "number",
                        event = "esx_vehicleshop:createBill",
                        args = { playerId = GetPlayerServerId(closestPlayer) },
                    },
                },
            })
        else
            ESX.ShowNotification(TranslateCap("no_players"))
        end
    elseif action == "get_rented_vehicles" then
        OpenRentedVehiclesMenu()
    elseif action == "set_vehicle_owner_sell" then
        if currentDisplayVehicle then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            if closestPlayer ~= -1 and closestDistance < 3 then
                local newPlate = GeneratePlate()
                local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
                vehicleProps.plate = newPlate
                SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
                TriggerServerEvent("esx_vehicleshop:setVehicleOwnedPlayerId", GetPlayerServerId(closestPlayer), vehicleProps, CurrentVehicleData.model, CurrentVehicleData.name)
                currentDisplayVehicle = nil
            else
                ESX.ShowNotification(TranslateCap("no_players"))
            end
        else
            ESX.ShowNotification(TranslateCap("no_current_vehicle"))
        end
    elseif action == "set_vehicle_owner_rent" then
        if currentDisplayVehicle then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            if closestPlayer ~= -1 and closestDistance < 3 then
                ESX.ShowContext("rent_amount", {
                    title = TranslateCap("rental_amount"),
                    options = {
                        {
                            title = TranslateCap("amount"),
                            input = true,
                            inputType = "number",
                            event = "esx_vehicleshop:rentVehicle",
                            args = { playerId = GetPlayerServerId(closestPlayer) },
                        },
                    },
                })
            else
                ESX.ShowNotification(TranslateCap("no_players"))
            end
        else
            ESX.ShowNotification(TranslateCap("no_current_vehicle"))
        end
    end
end)

function OpenPopVehicleMenu()
    ESX.TriggerServerCallback("esx_vehicleshop:getCommercialVehicles", function(vehicles)
        local options = {}

        for _, v in ipairs(vehicles) do
            local vehicleLabel = GetVehicleFromModel(v.vehicle).name

            table.insert(options, {
                title = vehicleLabel,
                description = TranslateCap("generic_shopitem", ESX.Math.GroupDigits(v.price)),
                event = "esx_vehicleshop:popVehicle",
                args = { vehicle = v.vehicle },
            })
        end

        ESX.ShowContext("commercial_vehicles", {
            title = TranslateCap("vehicle_dealer"),
            options = options,
        })
    end)
end

RegisterNetEvent("esx_vehicleshop:popVehicle")
AddEventHandler("esx_vehicleshop:popVehicle", function(data)
    local model = data.vehicle
    DeleteDisplayVehicleInsideShop()

    ESX.Game.SpawnVehicle(model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
        currentDisplayVehicle = vehicle

        for i = 1, #Vehicles, 1 do
            if model == Vehicles[i].model then
                CurrentVehicleData = Vehicles[i]
                break
            end
        end
    end)
end)

function OpenRentedVehiclesMenu()
    ESX.TriggerServerCallback("esx_vehicleshop:getRentedVehicles", function(vehicles)
        local options = {}

        for _, v in ipairs(vehicles) do
            local vehicleLabel = GetVehicleFromModel(v.name).name

            table.insert(options, {
                title = v.playerName,
                description = string.format("%s - %s", vehicleLabel, v.plate),
                disabled = true,
            })
        end

        ESX.ShowContext("rented_vehicles", {
            title = TranslateCap("rent_vehicle"),
            options = options,
        })
    end)
end

function OpenBossActionsMenu()
    ESX.UI.Menu.CloseAll()
    TriggerEvent("esx_society:openBossMenu", "cardealer", function(data, menu)
        menu.close()
    end, { wash = false })
end

RegisterNetEvent("esx_vehicleshop:createBill")
AddEventHandler("esx_vehicleshop:createBill", function(data)
    if data.value then
        local amount = tonumber(data.value)
        if amount and amount > 0 then
            TriggerServerEvent("esx_billing:sendBill", data.playerId, "society_cardealer", TranslateCap("car_dealer"), amount)
        else
            ESX.ShowNotification(TranslateCap("invalid_amount"))
        end
    end
end)

RegisterNetEvent("esx_vehicleshop:rentVehicle")
AddEventHandler("esx_vehicleshop:rentVehicle", function(data)
    if data.value then
        local amount = tonumber(data.value)
        if amount and amount > 0 then
            local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
            local newPlate = GeneratePlate()
            vehicleProps.plate = newPlate
            SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
            TriggerServerEvent("esx_vehicleshop:rentVehicle", data.playerId, vehicleProps, CurrentVehicleData.model, CurrentVehicleData.name, amount)
            currentDisplayVehicle = nil
        else
            ESX.ShowNotification(TranslateCap("invalid_amount"))
        end
    end
end)

function OpenGetStocksMenu()
    ESX.TriggerServerCallback("esx_vehicleshop:getStockItems", function(items)
        local elements = {}

        for i = 1, #items, 1 do
            if items[i].count > 0 then
                table.insert(elements, {
                    label = "x" .. items[i].count .. " " .. items[i].label,
                    value = items[i].name,
                })
            end
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "stocks_menu", {
            title = TranslateCap("dealership_stock"),
            align = "top-left",
            elements = elements,
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "stocks_menu_get_item_count", {
                title = TranslateCap("amount"),
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(TranslateCap("quantity_invalid"))
                else
                    TriggerServerEvent("esx_vehicleshop:getStockItem", itemName, count)
                    menu2.close()
                    menu.close()
                    OpenGetStocksMenu()
                end
            end, function(_, menu2)
                menu2.close()
            end)
        end, function(_, menu)
            menu.close()
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback("esx_vehicleshop:getPlayerInventory", function(inventory)
        local elements = {}

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. " x" .. item.count,
                    type = "item_standard",
                    value = item.name,
                })
            end
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "stocks_menu", {
            title = TranslateCap("inventory"),
            align = "top-left",
            elements = elements,
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "stocks_menu_put_item_count", {
                title = TranslateCap("amount"),
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(TranslateCap("quantity_invalid"))
                else
                    TriggerServerEvent("esx_vehicleshop:putStockItems", itemName, count)
                    menu2.close()
                    menu.close()
                    OpenPutStocksMenu()
                end
            end, function(_, menu2)
                menu2.close()
            end)
        end, function(_, menu)
            menu.close()
        end)
    end)
end

AddEventHandler("esx_vehicleshop:hasEnteredMarker", function(zone)
    if zone == "ShopEntering" then
        if Config.EnablePlayerManagement then
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "cardealer" then
                CurrentAction = "reseller_menu"
                CurrentActionMsg = TranslateCap("shop_menu")
                CurrentActionData = {}
            end
        else
            CurrentAction = "shop_menu"
            CurrentActionMsg = TranslateCap("shop_menu")
            CurrentActionData = {}
        end
    elseif zone == "GiveBackVehicle" and Config.EnablePlayerManagement then
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            CurrentAction = "give_back_vehicle"
            CurrentActionMsg = TranslateCap("vehicle_menu")
            CurrentActionData = { vehicle = vehicle }
        end
    elseif zone == "ResellVehicle" then
        local playerPed = PlayerPedId()

        if IsPedSittingInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleData, model, resellPrice, plate

            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                for i = 1, #Vehicles, 1 do
                    if joaat(Vehicles[i].model) == GetEntityModel(vehicle) then
                        vehicleData = Vehicles[i]
                        break
                    end
                end

                if vehicleData then
                    resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
                    model = GetEntityModel(vehicle)
                    plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

                    CurrentAction = "resell_vehicle"
                    CurrentActionMsg = TranslateCap("sell_menu", vehicleData.name, ESX.Math.GroupDigits(resellPrice))

                    CurrentActionData = {
                        vehicle = vehicle,
                        label = vehicleData.name,
                        price = resellPrice,
                        model = model,
                        plate = plate,
                    }
                else
                    ESX.ShowNotification(TranslateCap("invalid_vehicle"))
                end
            end
        end
    elseif zone == "BossActions" and Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "cardealer" and ESX.PlayerData.job.grade_name == "boss" then
        CurrentAction = "boss_actions_menu"
        CurrentActionMsg = TranslateCap("shop_menu")
        CurrentActionData = {}
    end
end)

AddEventHandler("esx_vehicleshop:hasExitedMarker", function(zone)
    if not IsInShopMenu then
        ESX.UI.Menu.CloseAll()
    end
    ESX.HideUI()
    CurrentAction = nil
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if IsInShopMenu then
            ESX.UI.Menu.CloseAll()

            local playerPed = PlayerPedId()

            FreezeEntityPosition(playerPed, false)
            SetEntityVisible(PlayerPedId(), true, true)
            SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
        end

        DeleteDisplayVehicleInsideShop()
    end
end)

-- Create Blips
CreateThread(function()
    if Config.Blip.show then
        local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos)

        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("car_dealer"))
        EndTextCommandSetBlipName(blip)
    end
end)

-- Enter / Exit marker events & Draw Markers
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep, currentZone = false, true

        for k, v in pairs(Config.Zones) do
            local distance = #(playerCoords - v.Pos)

            if distance < Config.DrawDistance then
                letSleep = false

                if v.Type ~= -1 then
                    DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                end

                if distance < v.Size.x then
                    isInMarker, currentZone = true, k
                end
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker, LastZone = true, currentZone
            LastZone = currentZone
            TriggerEvent("esx_vehicleshop:hasEnteredMarker", currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent("esx_vehicleshop:hasExitedMarker", LastZone)
        end

        if letSleep then
            Wait(500)
        end
    end
end)

-- Key controls
CreateThread(function()
    while true do
        Wait(0)

        if CurrentAction then
            ESX.TextUI(CurrentActionMsg)

            if IsControlJustReleased(0, 38) then
                if CurrentAction == "shop_menu" then
                    if Config.LicenseEnable then
                        ESX.TriggerServerCallback("esx_license:checkLicense", function(hasDriversLicense)
                            if hasDriversLicense then
                                OpenShopMenu()
                            else
                                ESX.ShowNotification(TranslateCap("license_missing"))
                            end
                        end, GetPlayerServerId(PlayerId()), "drive")
                    else
                        OpenShopMenu()
                    end
                elseif CurrentAction == "reseller_menu" then
                    OpenResellerMenu()
                elseif CurrentAction == "give_back_vehicle" then
                    ESX.TriggerServerCallback("esx_vehicleshop:giveBackVehicle", function(isRentedVehicle)
                        if isRentedVehicle then
                            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                            ESX.ShowNotification(TranslateCap("delivered"))
                        else
                            ESX.ShowNotification(TranslateCap("not_rental"))
                        end
                    end, ESX.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle)))
                elseif CurrentAction == "resell_vehicle" then
                    ESX.TriggerServerCallback("esx_vehicleshop:resellVehicle", function(vehicleSold)
                        if vehicleSold then
                            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                            ESX.ShowNotification(TranslateCap("vehicle_sold_for", CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
                        else
                            ESX.ShowNotification(TranslateCap("not_yours"))
                        end
                    end, CurrentActionData.plate, CurrentActionData.model)
                elseif CurrentAction == "boss_actions_menu" then
                    OpenBossActionsMenu()
                end
                ESX.HideUI()
                CurrentAction = nil
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    RequestIpl("shr_int") -- Load walls and floor

    local interiorID = 7170
    PinInteriorInMemory(interiorID)
    ActivateInteriorEntitySet(interiorID, "csr_beforeMission") -- Load large window
    RefreshInterior(interiorID)
end)

if ESX.PlayerLoaded then
    PlayerManagement()
end
GetVehicles()
