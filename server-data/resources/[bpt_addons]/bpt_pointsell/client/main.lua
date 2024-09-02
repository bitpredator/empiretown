local menuOpen = false
local inZoneSellShop = false
local inRangeMarkerSellShop = false
local cfgMarker = Config.Marker

--slow loop
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distSellShop = #(coords - Config.CircleZones.Dealer.coords)

        inRangeMarkerSellShop = false
        if distSellShop <= Config.Marker.Distance then
            inRangeMarkerSellShop = true
        end

        if distSellShop < 1 then
            inZoneSellShop = true
        else
            inZoneSellShop = false
            if menuOpen then
                menuOpen = false
            end
        end

        Wait(500)
    end
end)

--drawk marker
CreateThread(function()
    while true do
        local Sleep = 1500
        if inRangeMarkerSellShop then
            Sleep = 0
            local coordsMarker = Config.CircleZones.Dealer.coords
            local color = cfgMarker.Color
            DrawMarker(cfgMarker.Type, coordsMarker.x, coordsMarker.y, coordsMarker.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, cfgMarker.Size, color.r, color.g, color.b, color.a, false, true, 2, false, nil, nil, false)
        end
        Wait(Sleep)
    end
end)

--main loop
CreateThread(function()
    while true do
        local Sleep = 1500
        if inZoneSellShop and not menuOpen then
            Sleep = 0
            ESX.ShowHelpNotification(TranslateCap("dealer_prompt"), true)
            if IsControlJustPressed(0, 38) then
                OpenSellShop()
            end
        end
        Wait(Sleep)
    end
end)

function OpenSellShop()
    local elements = {
        { unselectable = true, icon = "fas fa-shopping-basket", title = TranslateCap("dealer_title") },
    }
    menuOpen = true

    for _, v in pairs(ESX.GetPlayerData().inventory) do
        local price = Config.DealerItems[v.name]

        if price and v.count > 0 then
            elements[#elements + 1] = {
                icon = "fas fa-shopping-basket",
                title = ('%s - <span style="color:green;">%s</span>'):format(v.label, TranslateCap("dealer_item", ESX.Math.GroupDigits(price))),
                name = v.name,
                price = price,
            }
        end
    end

    ESX.OpenContext("right", elements, function(menu, element)
        local elements2 = {
            { unselectable = true, icon = "fas fa-shopping-basket", title = element.title },
            { icon = "fas fa-shopping-basket", title = "Amount", input = true, inputType = "number", inputPlaceholder = "Amount you want to sell", inputValue = 0, inputMin = Config.SellMenu.Min, inputMax = Config.SellMenu.Max },
            { icon = "fas fa-check-double", title = "Confirm", val = "confirm" },
        }

        ESX.OpenContext("right", elements2, function(menu2, element2)
            ESX.CloseContext()
            local count = tonumber(menu2.eles[2].inputValue)

            if count < 1 then
                return
            end

            TriggerServerEvent("bpt_pointsell:sell", tostring(element.name), count)
        end, function()
            menuOpen = false
        end)
    end, function()
        menuOpen = false
    end)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.CloseContext()
        end
    end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
    local blip = AddBlipForRadius(coords, radius)

    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)

    -- create a blip in the middle
    blip = AddBlipForCoord(coords)

    SetBlipHighDetail(blip, true)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
end

CreateThread(function()
    for _, zone in pairs(Config.CircleZones) do
        CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
    end
end)
