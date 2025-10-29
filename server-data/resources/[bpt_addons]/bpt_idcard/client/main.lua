ESX = exports["es_extended"]:getSharedObject()

local open = false

-- Evento per aprire la carta
RegisterNetEvent("bpt_idcard:open")
AddEventHandler("bpt_idcard:open", function(data, type)
    open = true
    SendNUIMessage({
        action = "open",
        array = data,
        type = type,
    })
    -- Mostra mouse e blocca controllo player
    SetNuiFocus(true, true)
end)

-- Chiudi NUI lato client
RegisterNUICallback("closeNUI", function(data, cb)
    open = false
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Tasti per chiudere la carta (ESC / BACKSPACE)
CreateThread(function()
    while true do
        Wait(0)
        if open and (IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177)) then
            SendNUIMessage({ action = "close" })
        end
    end
end)
