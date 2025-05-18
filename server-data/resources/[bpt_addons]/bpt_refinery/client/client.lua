local pedCoords = vec3(1076.650513, -1984.813232, 31.032227) -- Cambia con le tue coordinate
local pedHeading = 180.0

CreateThread(function()
    RequestModel("s_m_m_snowcop_01")
    while not HasModelLoaded("s_m_m_snowcop_01") do
        Wait(0)
    end

    local ped = CreatePed(0, "s_m_m_snowcop_01", pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "startFonderia",
            icon = "fas fa-fire",
            label = "Avvia lavorazione pietra",
            onSelect = function()
                TriggerServerEvent("fonderia:startLavorazione")
            end,
        },
        {
            name = "ritiraFonderia",
            icon = "fas fa-box",
            label = "Ritira materiali lavorati",
            onSelect = function()
                TriggerServerEvent("fonderia:ritiraMateriali")
            end,
        },
    })
end)

CreateThread(function()
    local blip = AddBlipForCoord(1076.650513, -1984.813232, 31.032227)
    SetBlipSprite(blip, 365)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fonderia")
    EndTextCommandSetBlipName(blip)
end)
