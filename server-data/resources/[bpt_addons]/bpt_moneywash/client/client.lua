local pedEntity = nil

CreateThread(function()
    local model = Config.RecyclingLocation.pedModel
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    pedEntity = CreatePed(4, model, Config.RecyclingLocation.coords.x, Config.RecyclingLocation.coords.y, Config.RecyclingLocation.coords.z - 1.0, Config.RecyclingLocation.heading, false, true)
    FreezeEntityPosition(pedEntity, true)
    SetEntityInvincible(pedEntity, true)
    SetBlockingOfNonTemporaryEvents(pedEntity, true)

    exports.ox_target:addLocalEntity(pedEntity, {
        {
            label = 'Ricicla denaro sporco',
            icon = 'fa-solid fa-recycle',
            onSelect = function()
                ExecuteCommand('ricicla')
            end
        },
        {
            label = 'Ritira denaro pulito',
            icon = 'fa-solid fa-money-bill-wave',
            onSelect = function()
                ExecuteCommand('ritira')
            end
        }
    })
end)
