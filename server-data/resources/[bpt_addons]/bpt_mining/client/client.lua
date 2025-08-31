---@diagnostic disable: undefined-global
local mining = false

-- 🔧 Modelli possibili del martello pneumatico (aggiungine se ne scopri altri)
local JACKHAMMER_MODELS = {
    `prop_tool_jackham`,
    `prop_tool_jackhammer`, -- nel caso alcuni scenari/mapper usino questa variante
    `prop_constr_drill_01`, -- fallback: alcuni pack usano nomi diversi
    `prop_air_tool_02`, -- altro fallback comune in construction sets
}
local CLEANUP_RADIUS = 8.0
local DEBUG_JACKHAMMER = false

-- Utils: richiesta controllo + delete sicuro
local function DeleteEntitySafe(ent)
    if not DoesEntityExist(ent) then
        return
    end
    -- prova a prendere il controllo (network)
    NetworkRequestControlOfEntity(ent)
    local start = GetGameTimer()
    while not NetworkHasControlOfEntity(ent) and GetGameTimer() - start < 300 do
        NetworkRequestControlOfEntity(ent)
        Wait(0)
    end
    SetEntityAsMissionEntity(ent, true, true)
    DeleteEntity(ent)
    if DoesEntityExist(ent) then
        DeleteObject(ent)
    end
end

-- 🔥 Cleanup robusto: cerca in pool tutti gli oggetti vicini che matchano i modelli noti
local function RemoveNearbyJackhammers(radius)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local removed = 0

    local objects = GetGamePool("CObject")
    for _, obj in ipairs(objects) do
        if DoesEntityExist(obj) then
            local dist = #(GetEntityCoords(obj) - pcoords)
            if dist <= (radius or CLEANUP_RADIUS) then
                local model = GetEntityModel(obj)
                for _, hash in ipairs(JACKHAMMER_MODELS) do
                    if model == hash then
                        if DEBUG_JACKHAMMER then
                            print(("[miner] removing jackhammer obj=%s model=%s dist=%.2f"):format(obj, model, dist))
                        end
                        DeleteEntitySafe(obj)
                        removed += 1
                        break
                    end
                end
            end
        end
    end

    if DEBUG_JACKHAMMER and removed > 0 then
        print(("[miner] jackhammers removed: %d"):format(removed))
    end
end

-- Inizializza i punti mining con ox_target
CreateThread(function()
    for i, spot in pairs(Config.MiningSpots) do
        exports.ox_target:addBoxZone({
            coords = spot.coords,
            size = vec3(2, 2, 2),
            rotation = spot.heading,
            debug = false,
            options = {
                {
                    name = "mine_spot_" .. i,
                    icon = "fas fa-hammer",
                    label = "Estrai con il martello pneumatico",
                    onSelect = function()
                        if not mining then
                            StartMining(spot.coords)
                        end
                    end,
                },
            },
        })
    end
end)

-- Funzione mining con skill check
function StartMining(coords)
    local playerPed = PlayerPedId()
    mining = true

    -- Avvia scenario drilling
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CONST_DRILL", 0, true)
    FreezeEntityPosition(playerPed, true)

    -- Piccola attesa per “setup” visuale
    Wait(800)

    -- Skill check (puoi cambiare difficoltà/tasti)
    local success = lib.skillCheck({ "easy", "easy", "easy" }, { "E", "E", "E", "E" })

    -- Stop scenario
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    -- 🧹 Cleanup robusto in due pass (il prop a volte si “stacca” un frame dopo)
    Wait(200)
    RemoveNearbyJackhammers(CLEANUP_RADIUS)
    Wait(150)
    RemoveNearbyJackhammers(CLEANUP_RADIUS)

    -- Esito
    if success then
        TriggerServerEvent("empire_miner:giveItems")
        lib.notify({
            title = "Miniera",
            description = "Hai estratto con successo!",
            type = "success",
        })
    else
        lib.notify({
            title = "Miniera",
            description = "Hai fallito l'estrazione!",
            type = "error",
        })
    end

    mining = false
end

-- Blip in mappa
CreateThread(function()
    local blip = AddBlipForCoord(2950.5, 2796.3, 40.0)
    SetBlipSprite(blip, 318)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zona Mineraria")
    EndTextCommandSetBlipName(blip)
end)
