---@diagnostic disable: undefined-global

CreateThread(function()
    local pedModel = Config.NPC.model
    local pedCoords = Config.NPC.coords
    local pedHeading = Config.NPC.heading

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    local ped = CreatePed(0, pedModel, pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "startFoundry",
            icon = "fas fa-fire",
            label = TranslateCap("label_start"),
            onSelect = function()
                TriggerServerEvent("bpt_refinery:startProcessing")
            end,
        },
        {
            name = "withdrawFoundry",
            icon = "fas fa-box",
            label = TranslateCap("label_collect"),
            onSelect = function()
                TriggerServerEvent("bpt_refinery:collectMaterials")
            end,
        },
    })
end)

CreateThread(function()
    local pedCoords = Config.NPC.coords

    local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    SetBlipSprite(blip, 365)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TranslateCap("blip_name"))
    EndTextCommandSetBlipName(blip)
end)
