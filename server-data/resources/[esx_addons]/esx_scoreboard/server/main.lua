local connectedPlayers = {}

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("esx_scoreboard:getConnectedPlayers", function(_, cb)
    cb(connectedPlayers)
end)

AddEventHandler("esx:playerLoaded", function(_, xPlayer)
    AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler("esx:playerDropped", function(playerId)
    connectedPlayers[playerId] = nil

    TriggerClientEvent("esx_scoreboard:updateConnectedPlayers", -1, connectedPlayers)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        UpdatePing()
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            AddPlayersToScoreboard()
        end)
    end
end)

function AddPlayerToScoreboard(xPlayer, update)
    local playerId = xPlayer.source

    connectedPlayers[playerId] = {}
    connectedPlayers[playerId].ping = GetPlayerPing(playerId)
    connectedPlayers[playerId].id = playerId
    connectedPlayers[playerId].name = GetPlayerName(playerId)

    if update then
        TriggerClientEvent("esx_scoreboard:updateConnectedPlayers", -1, connectedPlayers)
    end

    if xPlayer.permission_level == 0 then
        Citizen.CreateThread(function()
            Citizen.Wait(3000)
            TriggerClientEvent("esx_scoreboard:toggleID", playerId, false)
        end)
    end
end

function AddPlayersToScoreboard()
    local players = ESX.GetPlayers()

    for i = 1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        AddPlayerToScoreboard(xPlayer, false)
    end

    TriggerClientEvent("esx_scoreboard:updateConnectedPlayers", -1, connectedPlayers)
end

function UpdatePing()
    for k, v in pairs(connectedPlayers) do
        v.ping = GetPlayerPing(k)
        TriggerClientEvent("status:updatePing", k, v.ping)
    end
    TriggerClientEvent("esx_scoreboard:updatePing", -1, connectedPlayers)
end

RegisterCommand("screfresh", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "admin" then
        AddPlayersToScoreboard()
    else
        TriggerClientEvent("chatMessage", source, "[CONSOLE]", { 255, 0, 0 }, " ^0Shoma ^1Admin ^0nistid!")
    end
end, false)

RegisterCommand("sctoggle", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "admin" then
        TriggerClientEvent("esx_scoreboard:toggleID", source)
    else
        TriggerClientEvent("chatMessage", source, "[CONSOLE]", { 255, 0, 0 }, " ^0Shoma ^1Admin ^0nistid!")
    end
end, false)

-- Ping Kick
local limit = GetConvarInt("pingkick", 600)
local checkInterval = GetConvarInt("pingkick_interval", 5000)
local warningStr = GetConvar("pingkick_warning", "Il tuo ping è troppo alto. (%dms, Warning: %d/3)")
local reasonStr = GetConvar("pingkick_reason", "Sei stato espulso perché avevi un ping alto. (%dms)")

local pingHits = {}

print("Limit set to " .. limit)

local function CheckPing(player)
    CreateThread(function()
        if GetPlayerPed(player) == 0 then
            return
        end -- Don't do anything if player doesn't have a ped yet

        local name = GetPlayerName(player)
        local ping = GetPlayerPing(player)

        if pingHits[player] == nil then
            pingHits[player] = 0
        end

        if ping >= limit then
            pingHits[player] = pingHits[player] + 1

            print(name .. " was warned. (Ping: " .. ping .. "ms, Warning: " .. pingHits[player] .. "/3)")
            TriggerClientEvent("chat:addMessage", player, { args = { "Ping", warningStr:format(ping, pingHits[player]) } })
        elseif pingHits[player] > 0 then
            pingHits[player] = pingHits[player] - 1
        end

        if pingHits[player] == 3 then
            pingHits[player] = 0

            print(name .. " was kicked. (Ping: " .. ping .. "ms)")

            DropPlayer(player, reasonStr:format(ping))
        end
    end)
end

CreateThread(function() -- Loop trough all players and check their pings
    while true do
        for _, player in ipairs(GetPlayers()) do
            CheckPing(player)
        end

        Wait(checkInterval)
    end
end)

AddEventHandler("playerDropped", function()
    pingHits[source] = 0
end)
