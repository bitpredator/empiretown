ESX = exports["es_extended"]:getSharedObject()

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

RegisterNetEvent("wasabi_oxshops:setProductPrice")
AddEventHandler("wasabi_oxshops:setProductPrice", function(shop, slot)
    local input = lib.inputDialog(Strings.sell_price, { Strings.amount_input })
    local price
    if not input then
        price = 0
    end
    price = tonumber(input[1])
    if price < 0 then
        price = 0
    end
    TriggerEvent("ox_inventory:closeInventory")
    TriggerServerEvent("wasabi_oxshops:setData", shop, slot, math.floor(price))
    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = "success",
    })
end)

local function createBlip(coords, sprite, color, text, scale)
    local x, y, z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.blip.enabled then
            createBlip(v.blip.coords, v.blip.sprite, v.blip.color, v.blip.string, v.blip.scale)
        end
    end
end)

CreateThread(function()
    local textUI, shopLoc, stashLoc = nil, nil, nil
    while true do
        local sleep = 1500
        local coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Shops) do
            local stashLoc = v.locations.stash.coords
            local shopLoc = v.locations.shop.coords
            local bossLoc
            local distStash = #(coords - stashLoc)
            local distShop = #(coords - shopLoc)
            local distBoss
            if bossLoc then
                distBoss = #(coords - bossLoc)
            end
            if distStash <= v.locations.stash.range and ESX.PlayerData.job.name == k then
                if not textUI then
                    lib.showTextUI(v.locations.stash.string)
                    textUI = true
                end
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory("stash", k)
                end
            elseif distShop <= v.locations.shop.range then
                if not textUI then
                    lib.showTextUI(v.locations.shop.string)
                    textUI = true
                end
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory("shop", { type = k, id = 1 })
                end
                sleep = 0
            elseif textUI then
                lib.hideTextUI()
                textUI = nil
            end
        end
        Wait(sleep)
    end
end)
