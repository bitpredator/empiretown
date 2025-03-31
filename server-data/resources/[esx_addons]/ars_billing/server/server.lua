---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("ars_billing:giveBillingItem", function(player, reason, society, amount)
    local src = source
    if not player or not reason or not society or not amount then
        return
    end
    if type(amount) ~= "number" or amount <= 0 then
        return
    end

    giveItem(src, player, reason, society, amount)
end)

RegisterNetEvent("ars_billing:payBill", function(method, data)
    local src = source
    if not method or not data then
        return
    end

    payBill(src, method, data)
end)

if not Config.CanDropItem then
    exports.ox_inventory:registerHook("swapItems", function(payload)
        if not payload or not payload.toInventory then
            return false
        end

        local canDrop = not string.find(payload.toInventory, "drop")
        return canDrop
    end, {})
end
