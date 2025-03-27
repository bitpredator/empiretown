ESX = exports["es_extended"]:getSharedObject()
local PlayerData = {}
local open = false
local closestSlotMachine = nil
local langaAparat = false
local wasNearSlot = false -- Variabile per prevenire il lampeggio

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(500)
    end

    if Config.BlipsEnabled then
        PlayerData = ESX.GetPlayerData()
        CreateBlip()
    end
end)

RegisterNetEvent("bpt_slots:enterBets")
AddEventHandler("bpt_slots:enterBets", function()
    local bets = KeyboardInput(TranslateCap('set_bet'), "", Config.MaxBetNumbers)
    if tonumber(bets) ~= nil then
        TriggerServerEvent('bpt_slots:BetsAndMoney', tonumber(bets))
    else
        unsit()
        TriggerEvent('esx:showNotification', TranslateCap('only_numbers'))
    end
end)

RegisterNetEvent("bpt_slots:UpdateSlots")
AddEventHandler("bpt_slots:UpdateSlots", function(lei)
    SetNuiFocus(true, true)
    open = true
    SendNUIMessage({
        showPacanele = "open",
        coinAmount = tonumber(lei)
    })
end)

RegisterNetEvent("bpt_slots:unsit")
AddEventHandler("bpt_slots:unsit", function()
    unsit()
end)

RegisterNUICallback('exitWith', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    open = false
    TriggerServerEvent("bpt_slots:PayOutRewards", data.coinAmount)
    if Config.SittingEnabled then
        unsit()
    end
end)

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    open = false
    while true do
        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)
        local found = false
        langaAparat = false

        for _, slot in ipairs(Config.Slots) do
            local dist = #(pedCoords - vector3(slot.x, slot.y, slot.z))
            if dist < 2 then
                found = true
                closestSlotMachine = slot
                langaAparat = true
                if open then
                    if not wasNearSlot then
                        ESX.ShowHelpNotification(TranslateCap('press_to_exit'))
                        wasNearSlot = true
                    end
                    DisablePlayerControlActions(true)
                else
                    if not wasNearSlot then
                        ESX.ShowHelpNotification(TranslateCap('press_to_join'))
                        wasNearSlot = true
                    end
                end
            end
        end

        if not found then
            wasNearSlot = false
            Citizen.Wait(1500) -- Aspetta di più se nessuna slot è vicina
        else
            Citizen.Wait(100) -- Controllo più frequente solo se vicino a una slot
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if langaAparat and IsControlJustReleased(0, 38) then -- Tasto "E"
            if Config.SittingEnabled then
                sit()
            else
                TriggerEvent('bpt_slots:enterBets')
            end
        end
    end
end)

function sit()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    for _, slot in pairs(Config.Slots) do
        if slot.id == closestSlotMachine.id then
            local prop = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(slot.prop), false)
            if DoesEntityExist(prop) then
                local pos = GetEntityCoords(prop)
                local id = pos.x .. pos.y .. pos.z
                ESX.TriggerServerCallback('bpt_slots:getPlace', function(occupied)
                    if occupied then
                        ESX.ShowNotification(TranslateCap('site_occupied'))
                    else
                        local playerPed = GetPlayerPed(-1)
                        lastPos = GetEntityCoords(playerPed)
                        currentSitObj = id
                        TriggerServerEvent('bpt_slots:takePlace', id)
                        TaskStartScenarioAtPosition(playerPed, 'PROP_HUMAN_SEAT_BENCH', pos.x + slot.offsetX, pos.y + slot.offsetY, pos.z - slot.offsetZ, GetEntityHeading(prop), 0, true, true)
                        TriggerEvent('bpt_slots:enterBets')
                    end
                end, id)
            end
        end
    end
end

function unsit()
    local playerPed = GetPlayerPed(-1)
    ClearPedTasks(playerPed)
    TriggerServerEvent('bpt_slots:leavePlace', currentSitObj)
    Citizen.Wait(4000)
end

function CreateBlip()
    for _, slot in ipairs(Config.Slots) do
        local blip = AddBlipForCoord(slot.x, slot.y, slot.z)
        SetBlipSprite(blip, 436)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 49)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TranslateCap('blip_name'))
        EndTextCommandSetBlipName(blip)
    end
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

function DisablePlayerControlActions(disable)
    local controlList = {
        {0, 1}, {0, 2}, {0, 24}, {0, 142}, {0, 106}
    }
    for _, control in ipairs(controlList) do
        DisableControlAction(control[1], control[2], disable)
    end
    DisablePlayerFiring(GetPlayerPed(-1), disable)
end
