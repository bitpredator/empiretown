lib.callback.register('wasabi_mining:checkPick', function(source, itemname)
    local item = HasItem(source, itemname)
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_mining:getRockData', function(source)
    local data = Config.rocks[math.random(#Config.rocks)]
    return data
end)

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
	:gsub(",(%-?)$","%1"):reverse()
end

RegisterServerEvent("wasabi_mining:mineRock")
AddEventHandler("wasabi_mining:mineRock", function(data, index)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.miningAreas[index])
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 10 then
        KickPlayer(Strings.kicked)
        return
    end
    AddItem(source, data.item, 1)
    TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'success')
end)

RegisterServerEvent('wasabi_mining:axeBroke')
AddEventHandler('wasabi_mining:axeBroke', function()
    if HasItem(source, 'pickaxe') >= 1 then
        RemoveItem(source, 'pickaxe', 1)
    else
        Wait(2000)
        KickPlayer(source, Strings.kicked)
    end
end)
