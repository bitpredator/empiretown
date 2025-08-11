-- Chiudiamo la loadscreen quando la mappa è pronta
AddEventHandler("onClientMapStart", function()
    -- Invia a NUI il comando di stop media
    SendNUIMessage({ action = "stopMedia" })
    -- Chiude la loadscreen di FiveM
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
end)
