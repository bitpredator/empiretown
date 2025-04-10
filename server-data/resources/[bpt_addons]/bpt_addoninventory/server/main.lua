if ESX.GetConfig().OxInventory then
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
            local stashes = MySQL.query.await('SELECT * FROM addon_inventory')

            for i = 1, #stashes do
                local stash = stashes[i]
                local jobStash = stash.name:find('society') and string.sub(stash.name, 9)
                exports.ox_inventory:RegisterStash(stash.name, stash.label, 100, 200000,
                    stash.shared == 0 and true or false, jobStash)
            end
        end
    end)

    return
end

Items = {}
local InventoriesIndex, Inventories, SharedInventories = {}, {}, {}

MySQL.ready(function()
    local items = MySQL.query.await('SELECT * FROM items')

    for i = 1, #items, 1 do
        Items[items[i].name] = items[i].label
    end

    local result = MySQL.query.await('SELECT * FROM addon_inventory')

    for i = 1, #result, 1 do
        local name    = result[i].name
        local _       = result[i].label
        local shared  = result[i].shared

        local result2 = MySQL.query.await('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
            ['@inventory_name'] = name
        })

        if shared == 0 then
            table.insert(InventoriesIndex, name)

            Inventories[name] = {}

            for j = 1, #result2, 1 do
                local itemName  = result2[j].name
                local itemCount = result2[j].count
                local itemOwner = result2[j].owner

                if items[itemOwner] == nil then
                    items[itemOwner] = {}
                end

                table.insert(items[itemOwner], {
                    name  = itemName,
                    count = itemCount,
                    label = Items[itemName]
                })
            end

            for k, v in pairs(items) do
                local addonInventory = CreateAddonInventory()
                table.insert(Inventories[name], addonInventory)
            end
        else

            for j = 1, #result2, 1 do
                table.insert(items, {
                    name  = result2[j].name,
                    count = result2[j].count,
                    label = Items[result2[j].name]
                })
            end

            local addonInventory          = CreateAddonInventory()
            SharedInventories[name]       = addonInventory
            GlobalState.SharedInventories = SharedInventories
        end
    end
end)

function GetInventory(name, owner)
    for i = 1, #Inventories[name], 1 do
        if Inventories[name][i].owner == owner then
            return Inventories[name][i]
        end
    end
end

function GetSharedInventory(name)
    return SharedInventories[name]
end

function AddSharedInventory(society)
    if type(society) ~= 'table' or not society?.name or not society?.label then return end
    -- society (array) containing name (string) and label (string)

    -- addon inventory:
    MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
        ['name'] = society.name,
        ['label'] = society.label,
        ['shared'] = 1
    })

    SharedInventories[society.name] = CreateAddonInventory()
end

AddEventHandler('bpt_addoninventory:getInventory', function(name, owner, cb)
    cb(GetInventory(name, owner))
end)

AddEventHandler('bpt_addoninventory:getSharedInventory', function(name, cb)
    cb(GetSharedInventory(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local addonInventories = {}

    for i = 1, #InventoriesIndex, 1 do
        local name      = InventoriesIndex[i]
        local inventory = GetInventory(name, xPlayer.identifier)

        if inventory == nil then
            inventory = CreateAddonInventory()
            table.insert(Inventories[name], inventory)
        end

        table.insert(addonInventories, inventory)
    end

    xPlayer.set('addonInventories', addonInventories)
end)
