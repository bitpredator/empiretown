-- Get the ESX object
ESX = exports["es_extended"]:getSharedObject()

-- Crafting level management functions
local function SetCraftingLevel(identifier, level)
    MySQL.Async.execute("UPDATE users SET crafting_level = @xp WHERE identifier = @identifier", {
        ["@xp"] = level,
        ["@identifier"] = identifier,
    })
end

local function GetCraftingLevel(identifier)
    return tonumber(MySQL.Sync.fetchScalar("SELECT crafting_level FROM users WHERE identifier = @identifier", {
        ["@identifier"] = identifier,
    })) or 0
end

local function GiveCraftingLevel(identifier, level)
    MySQL.Async.execute("UPDATE users SET crafting_level = crafting_level + @xp WHERE identifier = @identifier", {
        ["@xp"] = level,
        ["@identifier"] = identifier,
    })
end

-- Events for managing the crafting experience
RegisterServerEvent("bpt_crafting:setExperiance")
AddEventHandler("bpt_crafting:setExperiance", function(identifier, xp)
    SetCraftingLevel(identifier, xp)
end)

RegisterServerEvent("bpt_crafting:giveExperiance")
AddEventHandler("bpt_crafting:giveExperiance", function(identifier, xp)
    GiveCraftingLevel(identifier, xp)
end)

-- Crafting function
local function Craft(src, item, retrying)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local recipe = Config.Recipes[item]
    if not recipe then
        return
    end

    local canCraft = true
    local count = recipe.Amount

    if not retrying then
        for k, v in pairs(recipe.Ingredients) do
            if xPlayer.getInventoryItem(k).count < v then
                canCraft = false
                break
            end
        end
    end

    if canCraft then
        for k, v in pairs(recipe.Ingredients) do
            if not Config.PermanentItems[k] then
                xPlayer.removeInventoryItem(k, v)
            end
        end
        TriggerClientEvent("bpt_crafting:craftStart", src, item, count)
    else
        TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("not_enough_ingredients"))
    end
end

RegisterServerEvent("bpt_crafting:itemCrafted")
AddEventHandler("bpt_crafting:itemCrafted", function(item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local recipe = Config.Recipes[item]
    if not recipe then
        return
    end

    if math.random(0, 100) <= recipe.SuccessRate then
        if Config.UseLimitSystem then
            local xItem = xPlayer.getInventoryItem(item)
            if xItem.count + count <= xItem.limit then
                xPlayer.addInventoryItem(item, count)
                TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("item_crafted"))
                GiveCraftingLevel(xPlayer.identifier, Config.ExperiancePerCraft)
            else
                TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("inv_limit_exceed"))
            end
        elseif xPlayer.canCarryItem(item, count) then
            xPlayer.addInventoryItem(item, count)
            TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("item_crafted"))
            GiveCraftingLevel(xPlayer.identifier, Config.ExperiancePerCraft)
        else
            TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("inv_limit_exceed"))
        end
    else
        TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("crafting_failed"))
    end
end)

RegisterServerEvent("bpt_crafting:craft")
AddEventHandler("bpt_crafting:craft", function(item, retrying)
    Craft(source, item, retrying)
end)

-- Callbacks to get data
ESX.RegisterServerCallback("bpt_crafting:getXP", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(GetCraftingLevel(xPlayer.identifier))
    end
end)

ESX.RegisterServerCallback("bpt_crafting:getItemNames", function(_, cb)
    local names = {}
    MySQL.Async.fetchAll("SELECT name, label FROM bpt_items", {}, function(results)
        for _, v in ipairs(results) do
            names[v.name] = v.label
        end
        cb(names)
    end)
end)
