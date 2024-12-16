local ox_inventory = exports.ox_inventory
lib.locale()

lib.callback.register("alv_repairtable:canUse", function(source, cb)
    for k, v in pairs(Config.RepairLocations) do
        if #(v.Location - GetEntityCoords(GetPlayerPed(source))) < 2.0 then
            if v.Jobs and type(v.Jobs == "table") and v.Jobs[GetJob(source)] then
                return true
            end
        end
    end

    return false
end)

lib.callback.register("alv_repairtable:getLoadout", function(source, cb)
    return ox_inventory:GetInventoryItems(source)
end)

lib.callback.register("alv_repairtable:getMetal", function(source, cb)
    return ox_inventory:GetItem(source, Config.MetalItem, nil, true)
end)

lib.callback.register("alv_repairtable:chargePlayer", function(source, cb)
    return ChargePlayer(source, Config.ChargePlayer)
end)

lib.callback.register("alv_repairtable:removeMetal", function(source, count)
    return ox_inventory:RemoveItem(source, Config.MetalItem, count)
end)

lib.callback.register("alv_repairtable:returnTable", function(source, count)
    ox_inventory:RemoveItem(source, "gun_table", 1)
    return true
end)

lib.callback.register("alv_repairtable:takeTable", function(source, type)
    if type == "pickup" then
        ox_inventory:AddItem(source, "gun_table", 1)
        return true
    elseif type == "place" then
        ox_inventory:RemoveItem(source, "gun_table", 1)
        return true
    end
end)

lib.callback.register("alv_repairtable:repairGun", function(source, slot, cb)
    if source and slot then
        local slot = tonumber(slot)
        ox_inventory:SetDurability(source, slot, 100)
        if GetPlayerIdentifierByType(source, "discord") then
            local DiscordName = "<@" .. string.sub(GetPlayerIdentifierByType(source, "discord"), 9, -1) .. ">"
        else
            local DiscordName = locale("not_found")
        end
        DiscordLog(Discord.RepairWebhook, GetPlayerName(source), DiscordName, locale("weapon_repaired"), locale("repaired_desc", ox_inventory:GetSlot(source, slot)))

        if Config.ChargePlayer then
            ChargePlayer(source, Config.ChargePlayer)
        end
        return true
    end
end)

lib.callback.register("alv_repairbench:getDurability", function(source, slot, cb)
    if source and slot then
        local slot = tonumber(slot)

        local items = ox_inventory:GetInventoryItems(source)

        for k, v in pairs(items) do
            if v.slot == slot then
                return v.metadata.durability
            end
        end
    end
end)
