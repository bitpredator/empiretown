local PED_MODEL = `cs_jewelass`
local PED_COORDS = vector4(383.7626, -826.6813, 28.3, 260.0)
local CLEAR_AREA_CENTER = vector3(387.1764, -828.0369, 29.3054)
local CLEAR_RADIUS = 47.0

-- Rimuove pedoni ogni 1000ms invece che ogni frame (ottimizzazione performance)
CreateThread(function()
    while true do
        ClearAreaOfPeds(CLEAR_AREA_CENTER.x, CLEAR_AREA_CENTER.y, CLEAR_AREA_CENTER.z, CLEAR_RADIUS, 5)
        Wait(1000)
    end
end)

-- Crea il ped una volta sola
CreateThread(function()
    RequestModel(PED_MODEL)
    while not HasModelLoaded(PED_MODEL) do
        Wait(10)
    end

    local ped = CreatePed(4, PED_MODEL, PED_COORDS.xyz, PED_COORDS.w, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
end)
