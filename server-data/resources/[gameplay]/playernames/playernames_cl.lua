local mpGamerTags = {}
local mpGamerTagSettings = {}

local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16,
}

local templateStr = nil

local function makeSettings()
    return {
        alphas = {},
        colors = {},
        toggles = {},
        healthColor = false,
        wantedLevel = false,
        rename = false,
    }
end

local function getSettings(id)
    local idx = GetPlayerFromServerId(tonumber(id))
    if not mpGamerTagSettings[idx] then
        mpGamerTagSettings[idx] = makeSettings()
    end
    return mpGamerTagSettings[idx]
end

local function updatePlayerNames()
    SetTimeout(0, updatePlayerNames)

    if not templateStr then
        return
    end

    local playerPed = PlayerPedId()
    local localCoords = GetEntityCoords(playerPed)

    for _, i in ipairs(GetActivePlayers()) do
        if i ~= PlayerId() then
            local ped = GetPlayerPed(i)
            local pedCoords = GetEntityCoords(ped)
            local distance = #(pedCoords - localCoords)

            -- Crea tag se necessario
            if not mpGamerTags[i] or mpGamerTags[i].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[i].tag) then
                if mpGamerTags[i] then
                    RemoveMpGamerTag(mpGamerTags[i].tag)
                end

                mpGamerTags[i] = {
                    tag = CreateMpGamerTag(ped, formatPlayerNameTag(i, templateStr), false, false, "", 0),
                    ped = ped,
                }
            end

            local tag = mpGamerTags[i].tag
            local settings = getSettings(GetPlayerServerId(i))

            -- Rinomina se richiesto
            if settings.rename then
                SetMpGamerTagName(tag, formatPlayerNameTag(i, templateStr))
                settings.rename = false
            end

            local visible = distance < 250 and HasEntityClearLosToEntity(playerPed, ped, 17)

            SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, visible)
            SetMpGamerTagVisibility(tag, gtComponent.healthArmour, visible and IsPlayerTargettingEntity(PlayerId(), ped))
            SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, visible and NetworkIsPlayerTalking(i))

            SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
            SetMpGamerTagAlpha(tag, gtComponent.healthArmour, 255)

            -- Applica impostazioni personalizzate
            for k, v in pairs(settings.toggles) do
                SetMpGamerTagVisibility(tag, gtComponent[k], v)
            end
            for k, v in pairs(settings.alphas) do
                SetMpGamerTagAlpha(tag, gtComponent[k], v)
            end
            for k, v in pairs(settings.colors) do
                SetMpGamerTagColour(tag, gtComponent[k], v)
            end
            if settings.wantedLevel then
                SetMpGamerTagWantedLevel(tag, settings.wantedLevel)
            end
            if settings.healthColor then
                SetMpGamerTagHealthBarColour(tag, settings.healthColor)
            end
        elseif mpGamerTags[i] then
            RemoveMpGamerTag(mpGamerTags[i].tag)
            mpGamerTags[i] = nil
        end
    end
end

-- Gestione eventi
RegisterNetEvent("playernames:configure", function(id, key, ...)
    local args = table.pack(...)

    local s = getSettings(id)

    if key == "tglc" then
        s.toggles[args[1]] = args[2]
    elseif key == "seta" then
        s.alphas[args[1]] = args[2]
    elseif key == "setc" then
        s.colors[args[1]] = args[2]
    elseif key == "setw" then
        s.wantedLevel = args[1]
    elseif key == "sehc" then
        s.healthColor = args[1]
    elseif key == "rnme" then
        s.rename = true
    elseif key == "name" then
        s.serverName = args[1]
        s.rename = true
    elseif key == "tpl" then
        for _, v in pairs(mpGamerTagSettings) do
            v.rename = true
        end
        templateStr = args[1]
    end
end)

AddEventHandler("playernames:extendContext", function(i, cb)
    cb("serverName", getSettings(GetPlayerServerId(i)).serverName)
end)

AddEventHandler("onResourceStop", function(name)
    if name == GetCurrentResourceName() then
        for _, v in pairs(mpGamerTags) do
            RemoveMpGamerTag(v.tag)
        end
    end
end)

-- Inizializzazione
SetTimeout(0, function()
    TriggerServerEvent("playernames:init")
    updatePlayerNames()
end)
