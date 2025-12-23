local ESX = exports["es_extended"]:getSharedObject()
local swapHooks, createHooks = {}, {}

CreateThread(function()
    for name in pairs(Config.Shops) do
        TriggerEvent("bpt_society:registerSociety", name, name, "society_" .. name, "society_" .. name, "society_" .. name, { type = "public" })
    end
end)

CreateThread(function()
    while GetResourceState("ox_inventory") ~= "started" do
        Wait(1000)
    end

    for shopName, shopData in pairs(Config.Shops) do
        exports.ox_inventory:RegisterStash(shopName, shopData.label .. " " .. Strings.inventory, 50, 100000)

        local items = exports.ox_inventory:GetInventoryItems(shopName, false)
        local stashItems = {}

        if items and next(items) then
            for _, item in pairs(items) do
                if item.name then
                    local price = 0
                    if item.metadata and item.metadata.shopData and item.metadata.shopData.price then
                        price = item.metadata.shopData.price
                    end

                    stashItems[#stashItems + 1] = {
                        name = item.name,
                        metadata = item.metadata,
                        count = item.count,
                        price = price,
                    }
                end
            end
        end

        local coords = shopData.locations.shop.coords
        exports.ox_inventory:RegisterShop(shopName, {
            name = shopData.label,
            inventory = stashItems,
            locations = { vec3(coords[1], coords[2], coords[3]) },
        })

        swapHooks[shopName] = exports.ox_inventory:registerHook("swapItems", function(payload)
            if payload.fromInventory == shopName then
                TriggerEvent("bpt_oxshops:refreshShop", shopName)
            elseif payload.toInventory == shopName and tonumber(payload.fromInventory) then
                TriggerClientEvent("bpt_oxshops:setProductPrice", payload.fromInventory, shopName, payload.toSlot)
            end
        end, {})

        createHooks[shopName] = exports.ox_inventory:registerHook("createItem", function(payload)
            local metadata = payload.metadata
            if metadata and metadata.shopData then
                local shop = metadata.shopData.shop
                local price = metadata.shopData.price
                exports.ox_inventory:RemoveItem(shop, payload.item.name, payload.count)

                TriggerEvent("bpt_addonaccount:getSharedAccount", "society_" .. shop, function(account)
                    if account then
                        account.addMoney(price)
                    end
                end)
            end
        end, {})
    end
end)

RegisterServerEvent("bpt_oxshops:refreshShop", function(shop)
    Wait(250)

    local items = exports.ox_inventory:GetInventoryItems(shop, false)
    local stashItems = {}

    if items and next(items) then
        for _, item in pairs(items) do
            if item.name and item.metadata and item.metadata.shopData then
                stashItems[#stashItems + 1] = {
                    name = item.name,
                    metadata = item.metadata,
                    count = item.count,
                    price = item.metadata.shopData.price,
                }
            end
        end
    end

    local coords = Config.Shops[shop].locations.shop.coords
    exports.ox_inventory:RegisterShop(shop, {
        name = Config.Shops[shop].label,
        inventory = stashItems,
        locations = { vec3(coords[1], coords[2], coords[3]) },
    })
end)

RegisterServerEvent("bpt_oxshops:setData", function(shop, slot, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer or not Config.Shops[shop] or xPlayer.job.name ~= shop then
        print(("[ANTICHEAT] %s ha tentato di settare dati per shop '%s' senza permessi."):format(GetPlayerName(src), shop))
        return DropPlayer(src, "Comportamento non autorizzato rilevato.")
    end

    if type(price) ~= "number" or price < 0 or price > 100000 then
        print(("[ANTICHEAT] %s ha tentato di impostare un prezzo anomalo: %s. Shop: %s"):format(GetPlayerName(src), price, shop))
        return DropPlayer(src, "Tentativo di exploit rilevato.")
    end

    local item = exports.ox_inventory:GetSlot(shop, slot)
    if not item then
        print(("[ANTICHEAT] %s ha inviato dati per uno slot non valido (%s) in shop '%s'."):format(GetPlayerName(src), slot, shop))
        return
    end

    local metadata = item.metadata or {}
    metadata.shopData = {
        shop = shop,
        price = math.floor(price),
    }
    exports.ox_inventory:SetMetadata(shop, slot, metadata)
    TriggerEvent("bpt_oxshops:refreshShop", shop)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    for _, hook in pairs(swapHooks) do
        exports.ox_inventory:removeHooks(hook)
    end
    for _, hook in pairs(createHooks) do
        exports.ox_inventory:removeHooks(hook)
    end
end)
