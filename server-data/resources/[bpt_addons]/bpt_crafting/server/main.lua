-- Get the ESX object
ESX = exports["es_extended"]:getSharedObject()

-- =========================
-- Crafting level functions
-- =========================
local function SetCraftingLevel(identifier, xp)
    MySQL.Async.execute("UPDATE users SET crafting_level = @xp WHERE identifier = @identifier", {
        ["@xp"] = xp,
        ["@identifier"] = identifier,
    })
end

local function GetCraftingLevel(identifier, cb)
    MySQL.Async.fetchScalar("SELECT crafting_level FROM users WHERE identifier = @identifier", {
        ["@identifier"] = identifier,
    }, function(xp)
        cb(tonumber(xp) or 0)
    end)
end

local function GiveCraftingLevel(identifier, xp)
    MySQL.Async.execute("UPDATE users SET crafting_level = crafting_level + @xp WHERE identifier = @identifier", {
        ["@xp"] = xp,
        ["@identifier"] = identifier,
    })
end

-- =========================
-- Events for XP management
-- =========================
RegisterServerEvent("bpt_crafting:setExperiance")
AddEventHandler("bpt_crafting:setExperiance", function(identifier, xp)
    SetCraftingLevel(identifier, xp)
end)

RegisterServerEvent("bpt_crafting:giveExperiance")
AddEventHandler("bpt_crafting:giveExperiance", function(identifier, xp)
    GiveCraftingLevel(identifier, xp)
end)

-- =========================
-- Crafting function
-- =========================
local function Craft(src, item, retrying)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local recipe = Config.Recipes[item]
    if not recipe then
        TriggerClientEvent("bpt_crafting:sendMessage", src, "Recipe not found!")
        return
    end

    local canCraft = true
    local count = recipe.Amount or 1

    -- Check ingredients only on first attempt
    if not retrying then
        for ingredient, qty in pairs(recipe.Ingredients) do
            if xPlayer.getInventoryItem(ingredient).count < qty then
                canCraft = false
                break
            end
        end
    end

    if canCraft then
        -- Remove ingredients
        for ingredient, qty in pairs(recipe.Ingredients) do
            if not Config.PermanentItems[ingredient] then
                xPlayer.removeInventoryItem(ingredient, qty)
            end
        end
        -- Start crafting client-side
        TriggerClientEvent("bpt_crafting:craftStart", src, item)
    else
        TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("not_enough_ingredients"))
    end
end

-- =========================
-- Item crafted event
-- =========================
RegisterServerEvent("bpt_crafting:itemCrafted")
AddEventHandler("bpt_crafting:itemCrafted", function(item)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return
    end

    local recipe = Config.Recipes[item]
    if not recipe then
        return
    end

    local count = recipe.Amount or 1
    local successChance = recipe.SuccessRate or 100

    if math.random(0, 100) <= successChance then
        -- Check inventory limits
        local canAdd = false
        if Config.UseLimitSystem then
            local xItem = xPlayer.getInventoryItem(item)
            canAdd = (xItem.count + count <= xItem.limit)
        else
            canAdd = xPlayer.canCarryItem(item, count)
        end

        if canAdd then
            xPlayer.addInventoryItem(item, count)
            GiveCraftingLevel(xPlayer.identifier, Config.ExperiancePerCraft)
            TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("item_crafted"))
        else
            TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("inv_limit_exceed"))
        end
    else
        TriggerClientEvent("bpt_crafting:sendMessage", src, TranslateCap("crafting_failed"))
    end
end)

-- =========================
-- Craft request from client
-- =========================
RegisterServerEvent("bpt_crafting:craft")
AddEventHandler("bpt_crafting:craft", function(item)
    Craft(source, item, false)
end)

-- =========================
-- ESX Callbacks
-- =========================
ESX.RegisterServerCallback("bpt_crafting:getXP", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        GetCraftingLevel(xPlayer.identifier, cb)
    else
        cb(0)
    end
end)

ESX.RegisterServerCallback("bpt_crafting:getItemNames", function(source, cb)
    local names = {}
    MySQL.Async.fetchAll("SELECT name, label FROM bpt_items", {}, function(results)
        for _, v in ipairs(results) do
            names[v.name] = v.label
        end
        cb(names)
    end)
end)
