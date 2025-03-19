local Debug = Config.Debug
local JoinDelay = GetGameTimer() + tonumber(Config.JoinDelay)
local MaxPlayers = GetConvarInt("sv_maxclients")
local HostName = GetConvar("sv_hostname") ~= "default FXServer" and GetConvar("sv_hostname") or false
local jsonCard = json.decode(LoadResourceFile(GetCurrentResourceName(), "presentCard.json"))[1]

local prioritydata = {}
local queuelist = {}
local queuepositions = {}
local connectinglist = {}
local reconnectlist = {}
local playercount = 0

local randomEmojiStrings = { "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵" }

local function ChooseThreeRandomEmojis()
    local emojis = {}
    for i = 1, 3 do
        emojis[i] = randomEmojiStrings[math.random(1, #randomEmojiStrings)]
    end
    return table.concat(emojis)
end

local function DebugPrint(message)
    if Debug then
        print("[DEBUG]: " .. message)
    end
end

local function updateCard(data)
    local pCard = jsonCard
    local date = os.date("%a %b %d, %H:%M")
    pCard.body[1]["columns"][1]["items"][2]["columns"][1]["items"][1].text = string.format("Queue: %d/%d", data.pos, data.maxpos)
    pCard.body[1]["columns"][1]["items"][3].text = ChooseThreeRandomEmojis()
    pCard.body[1]["columns"][2]["items"][2]["columns"][1]["items"][1].text = date .. " EST"
    pCard.body[1]["columns"][2]["items"][2]["columns"][2]["items"][1].text = "Points: " .. tostring(data.points)
    return pCard
end

local function getPrioData(identifier)
    return prioritydata[identifier]
end
exports("getPrioData", getPrioData)

local function isInQueue(identifier)
    for pos, data in ipairs(queuelist) do
        if data.id == identifier then
            return pos, data
        end
    end
    return nil, nil
end
exports("isInQueue", isInQueue)

local function setQueuePos(identifier, newPos)
    if newPos <= 0 or newPos > #queuelist then
        return false
    end
    if not queuepositions[identifier] then
        return false
    end
    local currentPos = queuepositions[identifier]
    local data = queuelist[currentPos]
    if not data then
        return false
    end
    table.remove(queuelist, currentPos)
    table.insert(queuelist, newPos, data)
    queuepositions[identifier] = newPos
    return true
end
exports("setQueuePos", setQueuePos)

local function getQueuePos(identifier)
    return queuepositions[identifier]
end
exports("getQueuePos", getQueuePos)

local function updateQueuePositions()
    for k, v in ipairs(queuelist) do
        queuepositions[v.id] = k
    end
    return true
end

local function addToQueue(ids, points)
    local index = #queuelist + 1
    local currentTime = os.time()
    local data = {
        id = ids[Config.Identifier],
        ids = ids,
        points = points,
        qTime = os.time() - currentTime,
    }

    local newPos = index
    for pos, data in ipairs(queuelist) do
        if data.points >= points then
            newPos = pos + 1
        else
            newPos = pos
            break
        end
    end
    table.insert(queuelist, newPos, data)
    updateQueuePositions()

    return data
end

local function removeFromQueue(ids)
    local identifier = ids[Config.Identifier]
    for pos, data in ipairs(queuelist) do
        if identifier == data.id then
            queuepositions[identifier] = nil
            table.remove(queuelist, pos)
            updateQueuePositions()
            return true
        end
    end
    return false
end

local function isInConnecting(identifier)
    for pos, data in ipairs(connectinglist) do
        if identifier == data.id then
            return true, pos
        end
    end
    return false, false
end

local function addToConnecting(source, identifiers)
    if not source or not identifiers then
        return
    end
    local currentTime = os.time()
    local identifier = identifiers[Config.Identifier]
    local isConnecting, position = isInConnecting(identifier)

    if isConnecting then
        connectinglist[position] = {
            source = source,
            id = identifier,
            timeout = 0,
            cTime = os.time() - currentTime,
        }
    else
        table.insert(connectinglist, {
            source = source,
            id = identifier,
            timeout = 0,
            cTime = os.time() - currentTime,
        })
    end
    removeFromQueue(identifiers)
end

local function removeFromConnecting(identifier)
    for pos, data in ipairs(connectinglist) do
        if identifier == data.id then
            table.remove(connectinglist, pos)
            break
        end
    end
end

local function canJoin()
    return ((#connectinglist + playercount) < MaxPlayers) and (JoinDelay <= GetGameTimer())
end
exports("canJoin", canJoin)

local function getIdentifiers(src)
    if not src then
        return nil
    end
    local identifiers = {}
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        local index = tostring(id:match("(%w+):"))
        identifiers[index] = id
    end
    return identifiers
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    deferrals.defer()
    local source = source
    local identifiers = getIdentifiers(source)

    if isInConnecting(identifiers[Config.Identifier]) then
        removeFromConnecting(identifiers[Config.Identifier])
        Wait(500)
    end

    if Config.AntiSpam.enabled then
        deferrals.update(Lang.please_wait)
        Wait(math.random(Config.AntiSpam.time, Config.AntiSpam.time + 5000))
    end

    Wait(0)
    deferrals.update(Lang.checking_identifiers)

    if not identifiers then
        deferrals.done(Lang.ids_doesnt_exist)
        CancelEvent()
        return
    end

    Wait(0)
    for _, id in ipairs(Config.RequiredIdentifiers) do
        if not identifiers[id] then
            deferrals.done(string.format(Lang.id_doesnt_exist, id))
            CancelEvent()
            return
        end
    end

    Wait(0)
    deferrals.update(Lang.checking_roles)

    if Config.Discord.enabled then
        local playerroles = GetUserRoles(identifiers["discord"])
        if not playerroles then
            deferrals.done(Lang.join_discord)
            CancelEvent()
            return
        end

        local whitelisted = false
        local cIdentifier = identifiers[Config.Identifier]

        if prioritydata[cIdentifier] then
            prioritydata[cIdentifier] = {}
        end

        for _, role in pairs(playerroles) do
            if Config.Discord.roles[role] then
                if whitelisted then
                    prioritydata[cIdentifier].points = prioritydata[cIdentifier].points + Config.Discord.roles[role].points
                else
                    whitelisted = true
                    prioritydata[cIdentifier] = {}
                    prioritydata[cIdentifier].points = Config.Discord.roles[role].points
                    prioritydata[cIdentifier].name = Config.Discord.roles[role].name
                end
            end
        end

        if not whitelisted then
            deferrals.done(Lang.not_whitelisted)
            CancelEvent()
            return
        end

        if Config.ReconnectPrio.enabled then
            if reconnectlist[cIdentifier] then
                prioritydata[cIdentifier].points = prioritydata[cIdentifier].points + Config.ReconnectPrio.points
            end
        end
    end

    Wait(0)

    if canJoin() then
        addToConnecting(source, identifiers)
        deferrals.done()
        CancelEvent()
        return
    end

    Wait(0)

    if isInQueue(identifiers) then
        deferrals.done(Lang.already_in_queue)
        CancelEvent()
        return
    end

    Wait(0)

    local data = addToQueue(identifiers, prioritydata[identifiers[Config.Identifier]].points)
    if not data then
        deferrals.done(Lang.could_not_connect)
        CancelEvent()
        return
    end

    Wait(0)

    while data and queuepositions[data.id] do
        Wait(3000)

        if queuepositions[data.id] <= 1 and canJoin() then
            addToConnecting(source, data.ids)
            deferrals.update(Lang.joining_now)
            Wait(1000)
            deferrals.done()
            CancelEvent()
            return
        end

        local endpoint = GetPlayerEndpoint(source)
        if not endpoint then
            removeFromQueue(data.ids)
            deferrals.done(Lang.timed_out)
            CancelEvent()
            return
        end

        local displayCard = updateCard({
            pos = queuepositions[data.id],
            maxpos = #queuelist,
            qTime = data.qTime,
            points = data.points,
        })
        deferrals.presentCard(displayCard, function(data, rawdata) end)
    end

    deferrals.done()
end)

CreateThread(function()
    while true do
        Wait(5000)
        if #connectinglist < 1 then
            goto skipLoop
        end
        for pos, data in ipairs(connectinglist) do
            local endpoint = GetPlayerEndpoint(data.source)
            if not endpoint or data.cTime() >= Config.Timeout then
                removeFromConnecting(data.id)
                DebugPrint(string.format("%s has been timed out while connecting to server", data.id))
            end
        end
        ::skipLoop::

        local currentTime = os.time()
        for identifier, expire in pairs(reconnectlist) do
            if expire < currentTime then
                reconnectlist[identifier] = nil
            end
        end
    end
end)

AddEventHandler("playerJoining", function(source, oldid)
    local identifiers = getIdentifiers(source)
    playercount = playercount + 1
    removeFromConnecting(identifiers[Config.Identifier])
end)
