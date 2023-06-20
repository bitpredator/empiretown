local walEquipped, walObj
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local justConnect = true

local function RemoveWal()
    if DoesEntityExist(walObj) then
        DeleteObject(walObj)
    end
    SetModelAsNoLongerNeeded(hash)
    walObj = nil
    walEquipped = nil
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if justConnect then
        Wait(4500)
        justConnect = nil
    end
    for _, v in pairs(changes) do
        if type(v) == 'table' then
            local count = ox_inventory:Search('count', Config.WalletItem)
        end
        if type(v) == 'boolean' then
            local count = ox_inventory:Search('count', Config.WalletItem)
            if count < 1 and WalEquipped then
                RemoveWal()
            end
        end
    end
end)

lib.onCache('ped', function(value)
    ped = value
end)

exports('openWallet', function(data, slot)
    if not slot?.metadata?.identifier then
        local identifier = lib.callback.await('bpt_wallet:getNewIdentifier', 100, data.slot)
        ox_inventory:openInventory('stash', 'wal_'..identifier)
    else
        TriggerServerEvent('bpt_wallet:openWallet', slot.metadata.identifier)
        ox_inventory:openInventory('stash', 'wal_'..slot.metadata.identifier)
    end
end)