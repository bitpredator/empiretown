---@diagnostic disable: undefined-global
local ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    table.wipe(ESX.PlayerData)
    ESX.PlayerLoaded = false
end)

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent("bpt_oxshops:setProductPrice", function(shop, slot)
    local input = lib.inputDialog(Strings.sell_price, { Strings.amount_input })
    local price = tonumber(input and input[1]) or 0

    if price < 0 then
        price = 0
    end

    TriggerEvent("ox_inventory:closeInventory")
    TriggerServerEvent("bpt_oxshops:setData", shop, slot, math.floor(price))

    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = "success",
    })
end)

RegisterNetEvent("bpt_oxshops:setProductPrice", function(shop, slot)
    if not ESX.PlayerLoaded or not ESX.PlayerData.job or ESX.PlayerData.job.name ~= shop then
        print("[ANTICHEAT-CLIENT] Evento setProductPrice richiamato in modo sospetto.")
        return
    end

    local input = lib.inputDialog(Strings.sell_price, { Strings.amount_input })
    local price = tonumber(input and input[1]) or 0

    if price < 0 then
        print("[ANTICHEAT-CLIENT] Prezzo negativo tentato, annullato.")
        return
    end

    TriggerEvent("ox_inventory:closeInventory")
    TriggerServerEvent("bpt_oxshops:setData", shop, slot, math.floor(price))

    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = "success",
    })
end)

local function createBlip(coords, sprite, color, label, scale)
    local x, y, z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
end

CreateThread(function()
    for _, shop in pairs(Config.Shops) do
        if shop.blip.enabled then
            createBlip(shop.blip.coords, shop.blip.sprite, shop.blip.color, shop.blip.string, shop.blip.scale)
        end
    end
end)

CreateThread(function()
    local textUIVisible = false

    while true do
        local sleep = 1500
        local coords = GetEntityCoords(PlayerPedId())

        for shopName, shopData in pairs(Config.Shops) do
            local stashData = shopData.locations.stash
            local shopLocData = shopData.locations.shop

            local distStash = #(coords - stashData.coords)
            local distShop = #(coords - shopLocData.coords)

            if distStash <= stashData.range and ESX.PlayerData.job and ESX.PlayerData.job.name == shopName then
                if not textUIVisible then
                    lib.showTextUI(stashData.string)
                    textUIVisible = true
                end
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory("stash", shopName)
                end
            elseif distShop <= shopLocData.range then
                if not textUIVisible then
                    lib.showTextUI(shopLocData.string)
                    textUIVisible = true
                end
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory("shop", { type = shopName, id = 1 })
                end
            elseif textUIVisible then
                lib.hideTextUI()
                textUIVisible = false
            end
        end

        Wait(sleep)
    end
end)
