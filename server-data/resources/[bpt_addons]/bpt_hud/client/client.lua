-- ESX HUD Configurato
if Config.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

-- Attiva le opzioni configurate
CreateThread(function()
    Wait(2000)
    if Config.MenuOptions.ID then
        UIMessage("id", true)
    end
    if Config.Seatbelt then
        UIMessage("seatbelt", true)
    end
    if Config.MenuOptions.Stress then
        UIMessage("stress", true)
    end
    if Config.DisplayUserInfo then
        UIMessage("displayBalance", true)
    end
end)

-- Funzioni UI
local function toggleNuiFrame(shouldShow)
    UIMessage("setVisible", shouldShow)
    UIMessage("setUserId", GetPlayerServerId(PlayerId()))
    UIMessage("framework", true)
end

local function toggleVehHudFrame(shouldShow)
    UIMessage("setVehV", shouldShow)
end

-- Variabili
local ShowSeatbelt, Seatbelt, Loaded = false, false, false

-- Eventi
RegisterNetEvent("hud:client:ToggleShowSeatbelt", function()
    ShowSeatbelt = not ShowSeatbelt
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt", function()
    Seatbelt = not Seatbelt
end)

RegisterNetEvent("UIMessage", function(action, data)
    UIMessage(action, data)
end)

-- HUD Player
local function loadHud()
    toggleNuiFrame(true)
    CreateThread(function()
        local oldHealth, oldArmour, oldTalking
        while Loaded do
            local ped = PlayerPedId()
            local hp = GetEntityHealth(ped)
            local armour = GetPedArmour(ped)
            local talking = NetworkIsPlayerTalking(PlayerId())

            if hp ~= oldHealth or armour ~= oldArmour or talking ~= oldTalking then
                UIMessage("hudStats", {
                    hp = hp,
                    armour = armour,
                    micActive = talking,
                })
                oldHealth, oldArmour, oldTalking = hp, armour, talking
            end
            Wait(1000)
        end
    end)
end

-- HUD Veicolo
local function loadCarHud()
    CreateThread(function()
        while Loaded do
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local gear = GetVehicleCurrentGear(vehicle)
                local fuel = math.floor(GetVehicleFuelLevel(vehicle))
                local speed = math.floor(GetEntitySpeed(vehicle) * 3.6) -- KMH

                toggleVehHudFrame(true)
                UIMessage("vehHud", {
                    gear = gear,
                    fuel = fuel,
                    speed = speed,
                    seatbeltOn = Seatbelt,
                })
            else
                toggleVehHudFrame(false)
            end
            Wait(1000)
        end
    end)
end

-- HUD Status ESX
if Config.ESX then
    AddEventHandler("bpt_status:onTick", function(data)
        local hunger, thirst
        for i = 1, #data do
            if data[i].name == "thirst" then
                thirst = math.floor(data[i].percent)
            end
            if data[i].name == "hunger" then
                hunger = math.floor(data[i].percent)
            end
        end

        UIMessage("frameworkStatus", {
            hunger = hunger,
            thirst = thirst,
        })
    end)
end

-- HUD User Info (ESX)
local function loadUserInfo()
    if not Config.ESX or not Config.DisplayUserInfo then
        return
    end

    local society_money
    RegisterNetEvent("bpt_addonaccount:setMoney", function(society, money)
        if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == "boss" and "society_" .. ESX.PlayerData.job.name == society then
            society_money = money
        end
    end)

    CreateThread(function()
        local oldCash, oldBank, oldDirty, oldJob
        while Loaded do
            local xPlayer = ESX.GetPlayerData()
            local data = {
                job = string.format("%s - %s", xPlayer.job.label, xPlayer.job.grade_label),
                society_money = society_money,
            }

            for _, v in pairs(xPlayer.accounts) do
                if v.name == "money" then
                    data.cash = v.money
                elseif v.name == "bank" then
                    data.bank = v.money
                elseif v.name == "black_money" then
                    data.dirty_cash = v.money
                elseif v.name == "society_money" then
                    data.society_money = v.money
                end
            end

            if data.cash ~= oldCash or data.bank ~= oldBank or data.dirty_cash ~= oldDirty or data.job ~= oldJob then
                UIMessage("userInfo", data)
                oldCash, oldBank, oldDirty, oldJob = data.cash, data.bank, data.dirty_cash, data.job
            end
            Wait(1000)
        end
    end)
end

-- Escape Menu
local function escapeMenuLoop()
    CreateThread(function()
        while Loaded do
            toggleNuiFrame(not IsPauseMenuActive())
            Wait(1000)
        end
    end)
end

-- Avvio HUD (solo ESX)
CreateThread(function()
    print("Loading ESX Hud...")
    Wait(2000)
    Loaded = true
    loadHud()
    loadCarHud()
    loadUserInfo()
    if Config.EscapeMenuLoop then
        escapeMenuLoop()
    end
    print("ESX Hud Loaded!")
end)

-- Comando reload
RegisterCommand("reloadHud", function()
    Loaded = true
    loadHud()
    loadCarHud()
    loadUserInfo()
end, false)

-- Minimappa zoom
CreateThread(function()
    while true do
        Wait(1)
        local ped = PlayerPedId()
        if IsPedOnFoot(ped) or IsPedInAnyVehicle(ped, true) then
            SetRadarZoom(1100)
        end
    end
end)
