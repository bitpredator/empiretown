local playerPed

RegisterNetEvent("farmer:freeze")
AddEventHandler("farmer:freeze", function()
    playerPed = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(playerPed, true)
end)

RegisterNetEvent("farmer:unfreeze")
AddEventHandler("farmer:freeze", function()
    playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("farmer:anim")
AddEventHandler("farmer:anim", function()
    local lib, anim = "amb@prop_human_bum_bin@idle_b", "idle_d"
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 1.0, -3.0, 5000, 0, 0, false, false, false)
    end)
end)
