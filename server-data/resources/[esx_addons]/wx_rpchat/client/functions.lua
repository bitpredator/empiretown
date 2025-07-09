local displayHeight = 1
local fontId = nil

-- Carica il font una sola volta
Citizen.CreateThread(function()
    RegisterFontFile("BBN")
    fontId = RegisterFontId("BBN")
end)

-- Funzione generica per mostrare testo 3D temporaneo
function Display3DText(mePlayer, text, offset, yOffset)
    local displaying = true

    CreateThread(function()
        Wait(wx.MeDoDisplayTime or 5000)
        displaying = false
    end)

    CreateThread(function()
        displayHeight = displayHeight + 1
        while displaying do
            Wait(0)
            local playerCoords = GetEntityCoords(GetPlayerPed(mePlayer))
            local myCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - myCoords) < 25.0 then
                DrawText3DGeneral(playerCoords.x, playerCoords.y, playerCoords.z + offset + (displayHeight * 0.15) + yOffset, text, yOffset)
            end
        end
        displayHeight = displayHeight - 1
    end)
end

-- Funzione generica per disegnare testo 3D
function DrawText3DGeneral(x, y, z, text, variant)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen or not fontId then
        return
    end

    local p = GetGameplayCamCoords()
    local distance = #(vector3(x, y, z) - p)
    local scale = (1 / distance) * 2 * (1 / GetGameplayCamFov()) * 100

    SetTextFont(fontId)
    SetTextScale(0.33, 0.30)
    SetTextDropshadow(10, 100, 100, 100, 255)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370
    local rectOffset = 0.0135
    local rectWidth = 0.025 + factor
    local rectAlpha = 30

    -- Personalizza l’offset del rettangolo se necessario
    if variant == "doa" then
        rectOffset = 0.0145
        rectWidth = rectWidth + 0.005
    end

    DrawRect(_x, _y + rectOffset, rectWidth, 0.03, 0, 0, 0, rectAlpha)
end
