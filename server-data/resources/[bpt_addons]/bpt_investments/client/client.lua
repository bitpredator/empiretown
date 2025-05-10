local borsaCoords = vector3(254.017578, 222.448349, 106.283569)

if exports.ox_target and exports.ox_target.addBoxZone then
    exports.ox_target:addBoxZone({
        coords = borsaCoords,
        size = vec3(1.5, 1.5, 2.0),
        rotation = 0.0,
        debug = false,
        options = {
            {
                name = "borsa_investimento",
                icon = "fa-solid fa-dollar-sign",
                label = "Investi in Borsa",
                onSelect = function()
                    ApriMenuInvestimento()
                end,
            },
        },
    })
else
    print("Errore: addBoxZone non è disponibile in ox_target.")
end

function ApriMenuInvestimento()
    local input = lib.inputDialog("Investimento in Borsa", {
        { type = "number", label = "Importo", placeholder = "Es. 1000", min = 100 },
    })

    if input then
        local amount = tonumber(input[1])
        if amount and amount > 0 then
            TriggerServerEvent("borsa:investi", amount)
        else
            lib.notify({
                title = "Errore",
                description = "Importo non valido.",
                type = "error",
            })
        end
    end
end

CreateThread(function()
    local model = `U_M_M_BankMan`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local pedCoords = vector4(254.01757, 222.44834, 106.283569 - 1.0, 153.070862)

    local ped = CreatePed(0, model, pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.w, false, false)

    SetEntityInvincible(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)
