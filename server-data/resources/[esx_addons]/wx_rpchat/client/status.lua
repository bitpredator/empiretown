local ESX = exports["es_extended"]:getSharedObject()
local displayedMessages, playerStatuses = {}, {}
local playerLoaded = false
local myServerId = GetPlayerServerId(PlayerId())

-- Wait for ESX player loaded
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
    playerLoaded = true
end)

-- Notify wrapper
local function Notify(title, msg)
    lib.notify({ title = title, description = msg, type = "inform" })
end

-- Round vector3
local function roundVector3(vec)
    return vector3(ESX.Math.Round(vec.x), ESX.Math.Round(vec.y), ESX.Math.Round(vec.z))
end

-- Count how many /here texts player has active
local function getPlayerHereCount()
    local count = 0
    for _, v in pairs(displayedMessages) do
        if v.owner == myServerId then
            count = count + 1
        end
    end
    return count
end

RegisterCommand(wx.Commands["Here"], function()
    if not playerLoaded then
        return Notify("Error", "You must be spawned")
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local rounded = roundVector3(coords)

    local existing = displayedMessages[rounded]

    if existing and existing.owner ~= myServerId then
        return Notify("Error", "Another text is already placed here")
    end

    if existing and existing.owner == myServerId then
        TriggerServerEvent("chat:removeDisplayedMessage", rounded)
        return Notify("Success", "Text has been removed")
    end

    if getPlayerHereCount() >= wx.MaxHereTexts then
        return Notify("Error", "You can't place more than " .. wx.MaxHereTexts .. " texts")
    end

    local msg = table.concat(GetArguments(), " ")
    if msg == "" then
        return Notify("Error", "You must enter a message")
    end

    TriggerServerEvent("chat:SyncMessage", {
        owner = myServerId,
        coords = coords,
        message = msg,
    }, rounded)
end, false)

-- Server message sync handlers
RegisterNetEvent("chat:SetMessage", function(message, coords)
    displayedMessages[coords] = message
end)

RegisterNetEvent("chat:removeMessage", function(coords)
    displayedMessages[coords] = nil
end)

RegisterNetEvent("wx_rpchat:SetMessages", function(heres, statuses)
    displayedMessages = heres
    playerStatuses = statuses
end)

RegisterNetEvent("wx_rpchat:SetPlayerStatus", function(playerId, msg)
    playerStatuses[playerId] = msg
end)

RegisterNetEvent("wx_rpchat:RemovePlayerStatus", function(playerId)
    playerStatuses[playerId] = nil
end)

-- STATUS visual loop
CreateThread(function()
    while true do
        local sleep = 500
        local pedCoords = GetEntityCoords(PlayerPedId())

        for k, msg in pairs(playerStatuses) do
            local target = GetPlayerFromServerId(k)
            if target ~= -1 then
                local coords = GetEntityCoords(GetPlayerPed(target))
                local dist = #(coords - pedCoords)
                if k == myServerId or dist < 8.0 then
                    DrawText3D(coords.x, coords.y, coords.z, msg, wx.TransparentStatusHere)
                    sleep = 0
                end
            end
        end

        Wait(sleep)
    end
end)

-- HERE visual loop
CreateThread(function()
    TriggerServerEvent("wx_rpchat:RequestMessages")

    while true do
        local sleep = 135
        local pedCoords = GetEntityCoords(PlayerPedId())

        for _, v in pairs(displayedMessages) do
            if #(v.coords - pedCoords) < 5.5 then
                DrawText3D(v.coords.x, v.coords.y, v.coords.z, v.message, false)
                sleep = 0
            end
        end

        Wait(sleep)
    end
end)

-- Text3D unified draw
function DrawText3D(x, y, z, text, transparent)
    local _, screenX, screenY = World3dToScreen2d(x, y, z)
    RegisterFontFile("BBN")
    local fontId = RegisterFontId("BBN")
    SetTextScale(0.55, 0.31)
    SetTextFont(fontId)
    SetTextProportional(true)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextDropshadow(10, 100, 100, 100, 255)
    SetTextColour(255, 255, 255, 215)
    AddTextComponentString(text)
    DrawText(screenX, screenY)

    local factor = string.len(text) / 320
    if not transparent then
        DrawRect(screenX, screenY + 0.0135, 0.025 + factor, 0.03, 0, 0, 0, 68)
    end
end
