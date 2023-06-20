local registeredStashes = {}
local ox_inventory = exports.ox_inventory

local function GenerateText(num)
	local str
	repeat str = {}
		for i = 1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local function GenerateSerial(text)
	if text and text:len() > 3 then
		return text
	end
	return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

RegisterServerEvent('bpt_wallet:openWallet')
AddEventHandler('bpt_wallet:openWallet', function(identifier)
	if not registeredStashes[identifier] then
        ox_inventory:RegisterStash('wal_'..identifier, 'Wallet', Config.WalletStorage.slots, Config.WalletStorage.weight, false)
        registeredStashes[identifier] = true
    end
end)

lib.callback.register('bpt_wallet:getNewIdentifier', function(source, slot)
	local newId = GenerateSerial()
	ox_inventory:SetMetadata(source, slot, {identifier = newId})
	ox_inventory:RegisterStash('wal_'..newId, 'Wallet', Config.WalletStorage.slots, Config.WalletStorage.weight, false)
	registeredStashes[newId] = true
	return newId
end)