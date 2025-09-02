local chopping = false
local axeProp = nil

-- helper: carica anim dict
local function loadAnim(dict)
    RequestAnimDict(dict)
    local timeout = 500
    while not HasAnimDictLoaded(dict) and timeout > 0 do
        Wait(10)
        timeout = timeout - 1
    end
    return HasAnimDictLoaded(dict)
end

-- helper: carica modello
local function loadModel(model)
    local mHash = (type(model) == "number" and model) or GetHashKey(model)
    RequestModel(mHash)
    local timeout = 500
    while not HasModelLoaded(mHash) and timeout > 0 do
        Wait(10)
        timeout = timeout - 1
    end
    return HasModelLoaded(mHash) and mHash or nil
end

-- attach prop con placement (usa la tua PropPlacement)
local function attachAxePropToHand(ped)
    local propName = "prop_tool_fireaxe" -- come in rpemotes
    local propHash = loadModel(propName)
    if not propHash then
        return false
    end

    local coords = GetEntityCoords(ped)
    axeProp = CreateObject(propHash, coords.x, coords.y, coords.z, true, true, false)
    SetEntityAsMissionEntity(axeProp, true, true)

    local bone = 57005 -- mano destra
    -- PropPlacement: 0.0160, -0.3140, -0.0860, -97.1455, 165.0749, 13.9114
    local px, py, pz = 0.0160, -0.3140, -0.0860
    local rx, ry, rz = -97.1455, 165.0749, 13.9114

    AttachEntityToEntity(axeProp, ped, GetPedBoneIndex(ped, bone), px, py, pz, rx, ry, rz, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(propHash)
    return true
end

local function detachAndDeleteAxeProp()
    if axeProp and DoesEntityExist(axeProp) then
        DetachEntity(axeProp, true, true)
        DeleteObject(axeProp)
        axeProp = nil
    end
end

-- Zone + blip
CreateThread(function()
    for i, spot in pairs(Config.WoodSpots) do
        exports.ox_target:addSphereZone({
            coords = spot.coords,
            radius = 2.0,
            debug = false,
            options = {
                {
                    name = "woodcutting_" .. i,
                    label = "Taglia legna",
                    icon = "fa-solid fa-tree",
                    onSelect = function()
                        ChopWood(spot.coords)
                    end,
                },
            },
        })

        -- Blip mappa (usa Config.Blip)
        local blip = AddBlipForCoord(spot.coords.x, spot.coords.y, spot.coords.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Funzione principale: integra anim rpemotes "axe2"
function ChopWood(targetCoords)
    if chopping then
        return
    end

    -- verifica oggetto ascia nell'inventario (server callback)
    local hasAxe = lib.callback.await("woodcutting:checkAxe", false, Config.AxeItem)
    if not hasAxe then
        lib.notify({ title = "Errore", description = "Ti serve un'ascia nell'inventario!", type = "error" })
        return
    end

    chopping = true
    local ped = cache.ped

    -- toglie armi per tenere le mani libere (usiamo prop)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

    -- caricamento anim dict (rpemotes usa questo dict)
    local dict = "melee@large_wpn@streamed_core"
    local animName = "ground_attack_on_spot"
    if not loadAnim(dict) then
        lib.notify({ title = "Errore", description = "Animazione non disponibile: " .. dict, type = "error" })
        chopping = false
        return
    end

    -- attach prop ascia (prop_tool_fireaxe) con placement preso dal tuo snippet
    if not attachAxePropToHand(ped) then
        lib.notify({ title = "Errore", description = "Impossibile caricare il prop ascia.", type = "error" })
        chopping = false
        return
    end

    -- Loop anim in background finché dura la progress bar
    local start = GetGameTimer()
    local duration = Config.ChopDuration or 5000
    CreateThread(function()
        -- PlayAnim in loop: EmoteLoop = true -> duration -1 flag loop
        while chopping and (GetGameTimer() - start < duration) do
            if not IsEntityPlayingAnim(ped, dict, animName, 3) then
                -- flag 1 = loop; se vuoi upper-body-only prova 49 (ma ground_attack_on_spot è full-body)
                TaskPlayAnim(ped, dict, animName, 8.0, -8.0, -1, 1, 0.0, false, false, false)
            end
            -- puoi aggiungere effetti sonori/particelle qui se vuoi
            Wait(0)
        end
    end)

    -- progress bar (sincronizza il lavoro)
    local success = lib.progressBar({
        duration = duration,
        label = "Stai tagliando la legna...",
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, mouse = true },
    })

    -- stop
    chopping = false
    ClearPedTasks(ped)
    detachAndDeleteAxeProp()

    if success then
        TriggerServerEvent("woodcutting:giveWood")
    else
        lib.notify({ title = "Taglio annullato", type = "error" })
    end
end
