ShowHelp = function(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

CreateBlip = function(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords, 0, 0)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    AddTextEntry(text, text)
    BeginTextCommandSetBlipName(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

TryMine = function(data, index)
    TriggerServerEvent("wasabi_mining:mineRock", data, index)
end
