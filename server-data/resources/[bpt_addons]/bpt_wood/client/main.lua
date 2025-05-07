local raccoltaLegnaCoords = {
    vector3(-553.819763, 5370.711914, 70.359741),
    vector3(-554.874695, 5367.863770, 70.342896)
}

CreateThread(function()
    -- Ritardo per garantire che ox_target sia caricato
    Wait(500)
    for i, coords in ipairs(raccoltaLegnaCoords) do
        exports.ox_target:addBoxZone({
            coords = coords,
            size = vec3(1.5, 1.5, 2.0),
            rotation = 0.0,
            debug = false,
            options = {
                {
                    name = "raccogli_legna_" .. i,
                    icon = "fa-solid fa-tree",
                    label = "Taglia Legna",
                    onSelect = function()
                        if not IsEntityPlayingAnim(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 3) then
                            RaccogliLegna()
                        else
                            lib.notify({ title = "Attendere", description = "Stai già raccogliendo la legna.", type = "inform" })
                        end
                    end,
                },
            },
        })
    end
end)

function RaccogliLegna()
    local ped = PlayerPedId()

    -- Carica animazione
    local animDict = "melee@large_wpn@streamed_core"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    -- Carica modello ascia
    local axeModel = `prop_ld_fireaxe`
    RequestModel(axeModel)
    while not HasModelLoaded(axeModel) do Wait(10) end

    -- Crea ascia e attacca alla mano
    local axe = CreateObject(axeModel, GetEntityCoords(ped), true, true, false)
    AttachEntityToEntity(axe, ped, GetPedBoneIndex(ped, 57005), 0.13, 0.0, 0.0, 180.0, 0.0, 0.0, true, true, false, true, 1, true)

    -- Blocca movimento del ped
    FreezeEntityPosition(ped, true)
    lib.notify({ title = "Taglio legna", description = "Stai tagliando la legna...", type = "inform" })

    -- Simula 3 colpi di ascia
    for i = 1, 3 do
        TaskPlayAnim(ped, animDict, "ground_attack_on_spot", 8.0, -8.0, 1500, 1, 0, false, false, false)
        local coords = GetEntityCoords(ped)
        PlaySoundFromCoord(-1, "WOOD_SPLINTER", coords.x, coords.y, coords.z, "FAMILY_01_SOUNDSET", false, 0, false)
        Wait(1700)
        ClearPedTasks(ped)
        Wait(300)
    end

    -- Sblocca ped e rimuovi ascia
    FreezeEntityPosition(ped, false)
    DeleteEntity(axe)

    -- Dai la legna
    TriggerServerEvent("lavorolegno:riceviLegna")
end
