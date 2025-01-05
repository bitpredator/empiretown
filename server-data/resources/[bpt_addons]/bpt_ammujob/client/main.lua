---@diagnostic disable: undefined-global

local CurrentActionData, handcuffTimer, dragStatus, blipsCops = {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, CurrentAction, CurrentActionMsg
dragStatus.isDragged, IsInShopMenu = false, false

function CleanPlayer(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function OpenArmoryMenu(station)
    if Config.OxInventory then
        exports.ox_inventory:openInventory("stash", { id = "society_ammu", owner = station })
        return ESX.CloseContext()
    end

    ESX.OpenContext("right", function(menu)
        CurrentAction = "menu_armory"
        CurrentActionMsg = TranslateCap("open_armory")
        CurrentActionData = { station = station }
    end)
end

function OpenAmmuActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-ammu", title = TranslateCap("menu_title") },
        { icon = "fas fa-user", title = TranslateCap("citizen_interaction"), value = "citizen_interaction" },
    }

    ESX.OpenContext("right", elements, function(menu, element)
        local data = { current = element }

        if data.current.value == "citizen_interaction" then
            local elements2 = {
                { unselectable = true, icon = "fas fa-user", title = element.title },
                { icon = "fas fa-idkyet", title = TranslateCap("id_card"), value = "identity_card" },
                { icon = "fas fa-idkyet", title = TranslateCap("search"), value = "search" },
                { icon = "fas fa-idkyet", title = TranslateCap("handcuff"), value = "handcuff" },
                { icon = "fas fa-idkyet", title = TranslateCap("drag"), value = "drag" },
                { icon = "fas fa-idkyet", title = TranslateCap("put_in_vehicle"), value = "put_in_vehicle" },
                { icon = "fas fa-idkyet", title = TranslateCap("out_the_vehicle"), value = "out_the_vehicle" },
                { icon = "fas fa-idkyet", title = TranslateCap("billing"), value = "billing" },
                { icon = "fas fa-idkyet", title = TranslateCap("weapon"), value = "weapon" },
            }

            if Config.EnableLicenses then
                elements2[#elements2 + 1] = {
                    icon = "fas fa-scroll",
                    title = TranslateCap("license_check"),
                    value = "license",
                }
            end

            ESX.OpenContext("right", elements2, function(menu2, element2)
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    local data2 = { current = element2 }
                    local action = data2.current.value

                    if action == "identity_card" then
                        OpenIdentityCardMenu(closestPlayer)
                    elseif action == "search" then
                        OpenBodySearchMenu(closestPlayer)
                    elseif action == "handcuff" then
                        TriggerServerEvent("esx_cuffanimation:startArrest", GetPlayerServerId(closestPlayer))
                        Citizen.Wait(3100)
                        TriggerServerEvent("bpt_ammujob:handcuff", GetPlayerServerId(closestPlayer))
                    elseif action == "drag" then
                        TriggerServerEvent("bpt_ammujob:drag", GetPlayerServerId(closestPlayer))
                    elseif action == "put_in_vehicle" then
                        TriggerServerEvent("bpt_ammujob:putInVehicle", GetPlayerServerId(closestPlayer))
                    elseif action == "out_the_vehicle" then
                        TriggerServerEvent("bpt_ammujob:OutVehicle", GetPlayerServerId(closestPlayer))
                    elseif action == "billing" then
                        OpenFineMenu(closestPlayer)
                    elseif action == "weapon" then
                        TriggerServerEvent("esx_license:addLicense", GetPlayerServerId(closestPlayer), "weapon")
                        ESX.ShowNotification(TranslateCap("released_gun_licence"))
                        TriggerServerEvent("bpt_ammujob:message", GetPlayerServerId(closestDistance), TranslateCap("received_firearms_license"))
                    elseif action == "license" then
                        ShowPlayerLicense(closestPlayer)
                    end
                else
                    ESX.ShowNotification(TranslateCap("no_players_nearby"))
                end
            end, function()
                OpenAmmuActionsMenu()
            end)
        end
    end)
end

function OpenIdentityCardMenu(player)
    ESX.TriggerServerCallback("bpt_ammujob:getOtherPlayerData", function(data)
        local elements = {
            { icon = "fas fa-user", title = TranslateCap("name", data.name) },
            { icon = "fas fa-user", title = TranslateCap("job", ("%s - %s"):format(data.job, data.grade)) },
        }

        if Config.EnableESXIdentity then
            elements[#elements + 1] = { icon = "fas fa-user", title = TranslateCap("sex", TranslateCap(data.sex)) }
            elements[#elements + 1] = { icon = "fas fa-user", title = TranslateCap("sex", TranslateCap(data.sex)) }
            elements[#elements + 1] = { icon = "fas fa-user", title = TranslateCap("height", data.height) }
        end

        if Config.EnableESXOptionalneeds and data.drunk then
            elements[#elements + 1] = { title = TranslateCap("bac", data.drunk) }
        end

        if data.licenses then
            elements[#elements + 1] = { title = TranslateCap("license_label") }

            for i = 1, #data.licenses, 1 do
                elements[#elements + 1] = { title = data.licenses[i].label }
            end
        end

        ESX.OpenContext("right", elements, nil, function(menu)
            OpenAmmuActionsMenu()
        end)
    end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
    if Config.OxInventory then
        ESX.CloseContext()
        exports.ox_inventory:openInventory("player", GetPlayerServerId(player))
        return
    end

    ESX.TriggerServerCallback("bpt_ammujob:getOtherPlayerData", function(data)
        local elements = {
            { unselectable = true, icon = "fas fa-user", title = TranslateCap("search") },
        }

        for i = 1, #data.accounts, 1 do
            if data.accounts[i].name == "black_money" and data.accounts[i].money > 0 then
                elements[#elements + 1] = {
                    icon = "fas fa-money",
                    title = TranslateCap("confiscate_dirty", ESX.Math.Round(data.accounts[i].money)),
                    value = "black_money",
                    itemType = "item_account",
                    amount = data.accounts[i].money,
                }
                break
            end
        end

        table.insert(elements, { label = TranslateCap("guns_label") })

        for i = 1, #data.weapons, 1 do
            elements[#elements + 1] = {
                icon = "fas fa-gun",
                title = TranslateCap("confiscate_weapon", ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                value = data.weapons[i].name,
                itemType = "item_weapon",
                amount = data.weapons[i].ammo,
            }
        end

        elements[#elements + 1] = { title = TranslateCap("inventory_label") }

        for i = 1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                elements[#elements + 1] = {
                    icon = "fas fa-box",
                    title = TranslateCap("confiscate_inv", data.inventory[i].count, data.inventory[i].label),
                    value = data.inventory[i].name,
                    itemType = "item_standard",
                    amount = data.inventory[i].count,
                }
            end
        end

        ESX.OpenContext("right", elements, function(_, element)
            data = { current = element }
            if data.current.value then
                TriggerServerEvent("bpt_ammujob:confiscatePlayerItem", GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                OpenBodySearchMenu(player)
            end
        end)
    end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
    if Config.EnableFinePresets then
        local elements = {
            { unselectable = true, icon = "fas fa-scroll", title = TranslateCap("billing") },
            { icon = "fas fa-scroll", title = TranslateCap("traffic_offense"), value = 0 },
            { icon = "fas fa-scroll", title = TranslateCap("minor_offense"), value = 1 },
            { icon = "fas fa-scroll", title = TranslateCap("average_offense"), value = 2 },
            { icon = "fas fa-scroll", title = TranslateCap("major_offense"), value = 3 },
        }

        ESX.OpenContext("right", elements, function(_, element)
            local data = { current = element }
            OpenFineCategoryMenu(player, data.current.value)
        end)
    else
        ESX.CloseContext()
        ESX.CloseContext()
        OpenFineTextInput(player)
    end
end

local fineList = {}
function OpenFineCategoryMenu(player, category)
    if not fineList[category] then
        local p = promise.new()

        ESX.TriggerServerCallback("bpt_ammujob:getFineList", function(fines)
            p:resolve(fines)
        end, category)

        fineList[category] = Citizen.Await(p)
    end

    local elements = {
        { unselectable = true, icon = "fas fa-scroll", title = TranslateCap("billing") },
    }

    for _, fine in ipairs(fineList[category]) do
        elements[#elements + 1] = {
            icon = "fas fa-scroll",
            title = ('%s <span style="color:green;">%s</span>'):format(fine.label, TranslateCap("armory_item", ESX.Math.GroupDigits(fine.amount))),
            value = fine.id,
            amount = fine.amount,
            fineLabel = fine.label,
        }
    end

    ESX.OpenContext("right", elements, function(menu, element)
        local data = { current = element }
        if Config.EnablePlayerManagement then
            TriggerServerEvent("bpt_billing:sendBill", GetPlayerServerId(player), "society_ammu", TranslateCap("fine_total", data.current.fineLabel), data.current.amount)
        else
            TriggerServerEvent("bpt_billing:sendBill", GetPlayerServerId(player), "", TranslateCap("fine_total", data.current.fineLabel), data.current.amount)
        end

        ESX.SetTimeout(300, function()
            OpenFineCategoryMenu(player, category)
        end)
    end)
end

function OpenFineTextInput(player)
    Citizen.CreateThread(function()
        local amount = 0
        local reason = ""
        AddTextEntry("FMMC_KEY_TIP1", TranslateCap("fine_enter_amount"))
        Citizen.Wait(0)
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(0)
        end
        if UpdateOnscreenKeyboard() ~= 2 then
            amount = tonumber(GetOnscreenKeyboardResult())
            if amount == nil or amount <= 0 then
                ESX.ShowNotification(TranslateCap("invalid_amount"))
                return
            end
        end
        AddTextEntry("FMMC_KEY_TIP1", TranslateCap("fine_enter_text"))
        Citizen.Wait(0)
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 120)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(0)
        end
        if UpdateOnscreenKeyboard() ~= 2 then
            reason = GetOnscreenKeyboardResult()
        end
        Citizen.Wait(500)
        TriggerServerEvent("bpt_billing:sendBill", GetPlayerServerId(player), "society_ammu", reason, amount)
        OpenAmmuActionsMenu()
    end)
end

function ShowPlayerLicense(player)
    ESX.TriggerServerCallback("bpt_ammujob:getOtherPlayerData", function(playerData)
        local elements = {}
        if playerData.licenses then
            for i = 1, #playerData.licenses, 1 do
                if playerData.licenses[i].label and playerData.licenses[i].type then
                    elements[#elements + 1] = {
                        icon = "fas fa-scroll",
                        title = playerData.licenses[i].label,
                        type = playerData.licenses[i].type,
                    }
                end
            end
        end
        ESX.OpenContext("right", elements, nil, function(menu)
            OpenAmmuActionsMenu()
        end)
    end, GetPlayerServerId(player))
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback("bpt_ammujob:getStockItems", function(items)
        local elements = {
            { unselectable = true, icon = "fas fa-box", title = TranslateCap("ammu_stock") },
        }

        for i = 1, #items, 1 do
            elements[#elements + 1] = {
                icon = "fas fa-box",
                title = "x" .. items[i].count .. " " .. items[i].label,
                value = items[i].name,
            }
        end

        ESX.OpenContext("right", elements, function(menu, element)
            local data = { current = element }
            local itemName = data.current.value

            local elements2 = {
                { unselectable = true, icon = "fas fa-box", title = element.title },
                {
                    title = TranslateCap("quantity"),
                    input = true,
                    inputType = "number",
                    inputMin = 1,
                    inputMax = 150,
                    inputPlaceholder = TranslateCap("quantity_placeholder"),
                },
                { icon = "fas fa-check-double", title = TranslateCap("confirm"), value = "confirm" },
            }

            ESX.OpenContext("right", elements2, function(menu2, element2)
                local data2 = { value = menu2.eles[2].inputValue }
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification(TranslateCap("quantity_invalid"))
                else
                    ESX.CloseContext()
                    TriggerServerEvent("bpt_ammujob:getStockItem", itemName, count)

                    Wait(300)
                    OpenGetStocksMenu()
                end
            end)
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback("bpt_ammujob:getPlayerInventory", function(inventory)
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

        ESX.OpenContext("right", elements, function(menu, element)
            local data = { current = element }
            local itemName = data.current.value

            local elements2 = {
                { unselectable = true, icon = "fas fa-box", title = element.title },
                {
                    title = TranslateCap("quantity"),
                    input = true,
                    inputType = "number",
                    inputMin = 1,
                    inputMax = 150,
                    inputPlaceholder = TranslateCap("quantity_placeholder"),
                },
                { icon = "fas fa-check-double", title = TranslateCap("confirm"), value = "confirm" },
            }

            ESX.OpenContext("right", elements2, function(menu2, element2)
                local data2 = { value = menu2.eles[2].inputValue }
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification(TranslateCap("quantity_invalid"))
                else
                    ESX.CloseContext()
                    TriggerServerEvent("bpt_ammujob:putStockItems", itemName, count)

                    Wait(300)
                    OpenPutStocksMenu()
                end
            end)
        end)
    end)
end

AddEventHandler("bpt_ammujob:hasEnteredMarker", function(station, part, partNum)
    if part == "Armory" then
        CurrentAction = "menu_armory"
        CurrentActionMsg = TranslateCap("open_armory")
        CurrentActionData = { station = station }
    elseif part == "Vehicles" then
        CurrentAction = "menu_vehicle_spawner"
        CurrentActionMsg = TranslateCap("garage_prompt")
        CurrentActionData = { station = station, part = part, partNum = partNum }
    elseif part == "BossActions" then
        CurrentAction = "menu_boss_actions"
        CurrentActionMsg = TranslateCap("open_bossmenu")
        CurrentActionData = {}
    end
end)

AddEventHandler("bpt_ammujob:hasExitedMarker", function(station, part, partNum)
    if not IsInShopMenu then
        ESX.CloseContext()
    end

    CurrentAction = nil
end)

AddEventHandler("bpt_ammujob:hasEnteredEntityZone", function(entity)
    local playerPed = PlayerPedId()

    if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammu" and IsPedOnFoot(playerPed) then
        CurrentAction = "remove_entity"
        CurrentActionMsg = TranslateCap("remove_prop")
        CurrentActionData = { entity = entity }
    end

    if GetEntityModel(entity) == `p_ld_stinger_s` then
        playerPed = PlayerPedId()
        local _ = GetEntityCoords(playerPed)

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            for i = 0, 7, 1 do
                SetVehicleTyreBurst(vehicle, i, true, 1000)
            end
        end
    end
end)

AddEventHandler("bpt_ammujob:hasExitedEntityZone", function(entity)
    if CurrentAction == "remove_entity" then
        CurrentAction = nil
    end
end)

RegisterNetEvent("bpt_ammujob:handcuff")
AddEventHandler("bpt_ammujob:handcuff", function()
    isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()

    if isHandcuffed then
        RequestAnimDict("mp_arresting")
        while not HasAnimDictLoaded("mp_arresting") do
            Wait(100)
        end

        TaskPlayAnim(playerPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, false, false, false)
        RemoveAnimDict("mp_arresting")

        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed, true)
        DisplayRadar(false)

        if Config.EnableHandcuffTimer then
            if handcuffTimer.active then
                ESX.ClearTimeout(handcuffTimer.task)
            end

            StartHandcuffTimer()
        end
    else
        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end
end)

RegisterNetEvent("bpt_ammujob:unrestrain")
AddEventHandler("bpt_ammujob:unrestrain", function()
    if isHandcuffed then
        local playerPed = PlayerPedId()
        isHandcuffed = false

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)

        -- end timer
        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end
    end
end)

RegisterNetEvent("bpt_ammujob:drag")
AddEventHandler("bpt_ammujob:drag", function(copId)
    if isHandcuffed then
        dragStatus.isDragged = not dragStatus.isDragged
        dragStatus.CopId = copId
    end
end)

CreateThread(function()
    local wasDragged

    while true do
        local Sleep = 1500

        if isHandcuffed and dragStatus.isDragged then
            Sleep = 50
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(ESX.PlayerData.ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    wasDragged = true
                else
                    Wait(1000)
                end
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(ESX.PlayerData.ped, true, false)
            end
        elseif wasDragged then
            wasDragged = false
            DetachEntity(ESX.PlayerData.ped, true, false)
        end
        Wait(Sleep)
    end
end)

RegisterNetEvent("bpt_ammujob:putInVehicle")
AddEventHandler("bpt_ammujob:putInVehicle", function()
    if isHandcuffed then
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
                dragStatus.isDragged = false
            end
        end
    end
end)

RegisterNetEvent("bpt_ammujob:OutVehicle")
AddEventHandler("bpt_ammujob:OutVehicle", function()
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local IsPedSittingInAnyVehicle = IsPedSittingInAnyVehicle
    local TaskLeaveVehicle = TaskLeaveVehicle
    if IsPedSittingInAnyVehicle(ESX.PlayerData.ped) then
        local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
        TaskLeaveVehicle(ESX.PlayerData.ped, vehicle, 64)
    end
end)

-- Handcuff
CreateThread(function()
    local DisableControlAction = DisableControlAction
    local IsEntityPlayingAnim = IsEntityPlayingAnim
    while true do
        local Sleep = 1000

        if isHandcuffed then
            Sleep = 0
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 30, true) -- D

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

            if IsEntityPlayingAnim(ESX.PlayerData.ped, "mp_arresting", "idle", 3) ~= 1 then
                ESX.Streaming.RequestAnimDict("mp_arresting", function()
                    TaskPlayAnim(ESX.PlayerData.ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0.0, false, false, false)
                    RemoveAnimDict("mp_arresting")
                end)
            end
        end
        Wait(Sleep)
    end
end)

-- Create blips
CreateThread(function()
    for _, v in pairs(Config.Ammu) do
        local blip = AddBlipForCoord(v.Blip.Coords.x, v.Blip.Coords.y, v.Blip.Coords.z)
        SetBlipSprite(blip, v.Blip.Sprite)
        SetBlipDisplay(blip, v.Blip.Display)
        SetBlipScale(blip, v.Blip.Scale)
        SetBlipColour(blip, v.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(TranslateCap("map_blip"))
        EndTextCommandSetBlipName(blip)
    end
end)

-- Draw markers and more
CreateThread(function()
    while true do
        local Sleep = 1500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammu" then
            Sleep = 500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local isInMarker, hasExited = false, false
            local currentStation, currentPart, currentPartNum

            for k, v in pairs(Config.Ammu) do
                for i = 1, #v.Armories, 1 do
                    local distance = #(playerCoords - v.Armories[i])

                    if distance < Config.DrawDistance then
                        DrawMarker(Config.MarkerType.Armories, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                        Sleep = 0

                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, "Armory", i
                        end
                    end
                end

                for i = 1, #v.Vehicles, 1 do
                    local distance = #(playerCoords - v.Vehicles[i].Spawner)

                    if distance < Config.DrawDistance then
                        DrawMarker(Config.MarkerType.Vehicles, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                        Sleep = 0

                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, "Vehicles", i
                        end
                    end
                end

                if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == "boss" then
                    for i = 1, #v.BossActions, 1 do
                        local distance = #(playerCoords - v.BossActions[i])

                        if distance < Config.DrawDistance then
                            DrawMarker(Config.MarkerType.BossActions, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                            Sleep = 0

                            if distance < Config.MarkerSize.x then
                                isInMarker, currentStation, currentPart, currentPartNum = true, k, "BossActions", i
                            end
                        end
                    end
                end
            end

            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
                if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
                    TriggerEvent("bpt_ammujob:hasExitedMarker", LastStation, LastPart, LastPartNum)
                    hasExited = true
                end

                HasAlreadyEnteredMarker = true
                LastStation = currentStation
                LastPart = currentPart
                LastPartNum = currentPartNum

                TriggerEvent("bpt_ammujob:hasEnteredMarker", currentStation, currentPart, currentPartNum)
            end

            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent("bpt_ammujob:hasExitedMarker", LastStation, LastPart, LastPartNum)
            end
        end
        Wait(Sleep)
    end
end)

ESX.RegisterInput("ammu:interact", "(BPT AmmuJob) " .. TranslateCap("interaction"), "keyboard", "E", function()
    if not CurrentAction then
        return
    end

    if not ESX.PlayerData.job or (ESX.PlayerData.job and ESX.PlayerData.job.name ~= "ammu") then
        return
    end

    if CurrentAction == "menu_armory" then
        if not Config.EnableESXService then
            OpenArmoryMenu(CurrentActionData.station)
        elseif playerInService then
            OpenArmoryMenu(CurrentActionData.station)
        else
            ESX.ShowNotification(TranslateCap("service_not"))
        end
    elseif CurrentAction == "menu_vehicle_spawner" then
        if not Config.EnableESXService then
            OpenVehicleSpawnerMenu("car", CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
        elseif playerInService then
            OpenVehicleSpawnerMenu("car", CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
        else
            ESX.ShowNotification(TranslateCap("service_not"))
        end
    elseif CurrentAction == "delete_vehicle" then
        ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
    elseif CurrentAction == "menu_boss_actions" then
        ESX.CloseContext()
        TriggerEvent("bpt_society:openBossMenu", "ammu", function(data, menu)
            ESX.CloseContext()

            CurrentAction = "menu_boss_actions"
            CurrentActionMsg = TranslateCap("open_bossmenu")
            CurrentActionData = {}
        end)
    elseif CurrentAction == "remove_entity" then
        DeleteEntity(CurrentActionData.entity)
    end

    CurrentAction = nil
end)

ESX.RegisterInput("ammu:quickactions", "(BPT AmmuJob) " .. TranslateCap("quick_actions"), "keyboard", "F6", function()
    if not ESX.PlayerData.job or (ESX.PlayerData.job.name ~= "ammu") or isDead then
        return
    end

    if not Config.EnableESXService then
        OpenAmmuActionsMenu()
    elseif playerInService then
        OpenAmmuActionsMenu()
    else
        ESX.ShowNotification(TranslateCap("service_not"))
    end
end)

CreateThread(function()
    while true do
        local Sleep = 1000

        if CurrentAction then
            Sleep = 0
            ESX.ShowHelpNotification(CurrentActionMsg)
        end
        Wait(Sleep)
    end
end)

-- Create blip for colleagues
function CreateBlip(id)
    local ped = GetPlayerPed(id)
    local blip = GetBlipFromEntity(ped)

    if not DoesBlipExist(blip) then -- Add blip and create head display on player
        blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
        SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
        SetBlipNameToPlayerName(blip, id) -- update blip name
        SetBlipScale(blip, 0.85) -- set scale
        SetBlipAsShortRange(blip, true)

        table.insert(blipsCops, blip) -- add blip to array so we can remove it later
    end
end

AddEventHandler("esx:onPlayerSpawn", function(spawn)
    isDead = false
    TriggerEvent("bpt_ammujob:unrestrain")

    if not hasAlreadyJoined then
        TriggerServerEvent("bpt_ammujob:spawned")
    end
    hasAlreadyJoined = true
end)

AddEventHandler("esx:onPlayerDeath", function(data)
    isDead = true
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent("bpt_ammujob:unrestrain")

        if Config.EnableESXService then
            TriggerServerEvent("esx_service:disableService", "ammu")
        end

        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end
    end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
    if Config.EnableHandcuffTimer and handcuffTimer.active then
        ESX.ClearTimeout(handcuffTimer.task)
    end

    handcuffTimer.active = true

    handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
        ESX.ShowNotification(TranslateCap("unrestrained_timer"))
        TriggerEvent("bpt_ammujob:unrestrain")
        handcuffTimer.active = false
    end)
end
