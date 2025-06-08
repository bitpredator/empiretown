local pedModel = `a_m_m_business_01`
local pedCoords = vector4(782.149475, 1281.257202, 360.294434, 272.125977)

CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    local ped = CreatePed(0, pedModel, pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedCoords.w, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "sell_items",
            label = "Vendi Merce",
            icon = "fa-solid fa-money-bill-wave",
            onSelect = function(data)
                TriggerServerEvent("custom_drugs:sellItems")
            end,
        },
    })
end)
