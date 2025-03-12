local ESX = exports["es_extended"]:getSharedObject()

local foodPeds = {
    { model = "s_f_y_stripper_02", x = 112.68, y = -1288.3, z = 28.46, a = 238.85, animation = "mini@strip_club@private_dance@idle", animationName = "priv_dance_idle" },
    { model = "s_f_y_stripperlite", x = 111.99, y = -1286.03, z = 28.46, a = 308.8, animation = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName = "ld_girl_a_song_a_p1_f" },
    { model = "csb_stripper_01", x = 108.72, y = -1289.33, z = 28.86, a = 295.53, animation = "mini@strip_club@private_dance@part2", animationName = "priv_dance_p2" },
    { model = "s_f_y_stripper_01", x = 103.21, y = -1292.59, z = 29.26, a = 296.21, animation = "mini@strip_club@private_dance@part1", animationName = "priv_dance_p1" },
    { model = "s_f_y_stripper_02", x = 104.66, y = -1294.46, z = 29.26, a = 287.12, animation = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName = "ld_girl_a_song_a_p1_f" },
    { model = "a_f_y_topless_01", x = 102.26, y = -1289.92, z = 29.26, a = 292.05, animation = "mini@strip_club@private_dance@idle", animationName = "priv_dance_idle" },
}

local function loadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(500)
    end
    return modelHash
end

local function loadAnimationDict(animation)
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(500)
    end
end

ESX.TriggerServerCallback("callbackname", function(spawned)
    if not spawned then
        for _, v in ipairs(foodPeds) do
            -- Carica il modello del ped
            local modelHash = loadModel(v.model)
            -- Carica l'animazione
            loadAnimationDict(v.animation)

            -- Crea il ped
            local storePed = CreatePed(4, modelHash, v.x, v.y, v.z, v.a, true, true)

            -- Impostazioni ped
            SetBlockingOfNonTemporaryEvents(storePed, false)
            SetPedFleeAttributes(storePed, 0, false)
            SetPedArmour(storePed, 100)
            SetPedMaxHealth(storePed, 100)
            SetPedDiesWhenInjured(storePed, false)

            -- Task per far eseguire l'animazione al ped
            TaskPlayAnim(storePed, v.animation, v.animationName, 8.0, -8.0, -1, 49, 0, false, false, false)

            -- Rimuovi il modello dalla memoria quando non è più necessario
            SetModelAsNoLongerNeeded(modelHash)
        end
    end
end)
