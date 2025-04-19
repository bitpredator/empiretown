---@diagnostic disable: undefined-global
local HasAlreadyEnteredMarker
local CurrentAction, CurrentActionMsg = nil, ""
local LastZone

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:onPlayerLogout")
AddEventHandler("esx:onPlayerLogout", function()
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

function DrawSub(msg, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
    CreateThread(function()
        Wait(0)

        BeginTextCommandBusyspinnerOn("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandBusyspinnerOn(type)
        Wait(time)

        BusyspinnerOff()
    end)
end

function OpenballasActionsMenu()
    local elements = {
        { unselectable = true, icon = "fas fa-ballas", title = TranslateCap("ballas") },
        { icon = "fas fa-box", title = TranslateCap("deposit_stock"), value = "put_stock" },
        { icon = "fas fa-box", title = TranslateCap("take_stock"), value = "get_stock" },
    }

    if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
        elements[#elements + 1] = {
            icon = "fas fa-wallet",
            title = TranslateCap("boss_actions"),
            value = "boss_actions",
        }
    end

    ESX.OpenContext("right", elements, function(_, element)
        if Config.OxInventory and (element.value == "put_stock" or element.value == "get_stock") then
            exports.ox_inventory:openInventory("stash", "society_ballas")
            return ESX.CloseContext()
        elseif element.value == "put_stock" then
            OpenPutStocksMenu()
        elseif element.value == "get_stock" then
            OpenGetStocksMenu()
        elseif element.value == "boss_actions" then
            TriggerEvent("bpt_society:openBossMenu", "ballas", function(_, menu)
                menu.close()
            end, { wash = false } )
        end
    end, function()
        CurrentAction = "ballas_actions_menu"
        CurrentActionMsg = TranslateCap("press_to_open")
        CurrentActionData = {}
    end)
end

AddEventHandler("bpt_ballasjob:hasEnteredMarker", function(zone)
    if zone == "BallasActions" then
        CurrentAction = "ballas_actions_menu"
        CurrentActionMsg = TranslateCap("press_to_open")
        CurrentActionData = {}
    end
end)

AddEventHandler("bpt_ballasjob:hasExitedMarker", function()
    ESX.CloseContext()
    CurrentAction = nil
end)

-- Create Blips
CreateThread(function()
    local blip = AddBlipForCoord(Config.Zones.BallasActions.Pos.x, Config.Zones.BallasActions.Pos.y, Config.Zones.BallasActions.Pos.z)

    SetBlipSprite(blip, 106)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(TranslateCap("blip_ballas"))
    EndTextCommandSetBlipName(blip)
end)

-- Enter / Exit marker events, and draw markers
CreateThread(function()
    while true do
        local sleep = 1500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "ballas" then
            local coords = GetEntityCoords(PlayerPedId())
            local isInMarker, currentZone = false

            for k, v in pairs(Config.Zones) do
                local zonePos = vector3(v.Pos.x, v.Pos.y, v.Pos.z)
                local distance = #(coords - zonePos)

                if v.Type ~= -1 and distance < Config.DrawDistance then
                    sleep = 0
                    if k == "" then
                        if k == "" then
                            DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
                        end
                    else
                        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
                    end
                end

                if distance < v.Size.x then
                    isInMarker, currentZone = true, k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker, LastZone = true, currentZone
                TriggerEvent("bpt_ballasjob:hasEnteredMarker", currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent("bpt_ballasjob:hasExitedMarker", LastZone)
            end
        end
        Wait(sleep)
    end
end)

-- Key Controls
CreateThread(function()
    while true do
        local sleep = 1500
        if CurrentAction and not ESX.PlayerData.dead then
            sleep = 0
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == "ballas" then
                if CurrentAction == "ballas_actions_menu" then
                    OpenballasActionsMenu()
                end

                CurrentAction = nil
            end
        end
        Wait(sleep)
    end
end)

RegisterCommand("ballasmenu", function()
    if not ESX.PlayerData.dead and Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.name == "ballas" then
        OpenMobileBallasActionsMenu()
    end
end, false)

RegisterKeyMapping("ballasmenu", "Open Ballas Menu", "keyboard", "f6")
