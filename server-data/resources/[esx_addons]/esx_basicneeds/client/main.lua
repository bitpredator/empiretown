local IsDead = false
local IsAnimated = false

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('bpt_status:set', 'hunger', 500000)
	TriggerEvent('bpt_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('bpt_status:set', 'hunger', 1000000)
	TriggerEvent('bpt_status:set', 'thirst', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('bpt_status:loaded', function()
	TriggerEvent('bpt_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function()
		return Config.Visible
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('bpt_status:registerStatus', 'thirst', 1000000, '#0C98F1', function()
		return Config.Visible
	end, function(status)
		status.remove(75)
	end)
end)

AddEventHandler('bpt_status:onTick', function(data)
	local playerPed  = PlayerPedId()
	local prevHealth = GetEntityHealth(playerPed)
	local health     = prevHealth

	for _, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end

	if health ~= prevHealth then SetEntityHealth(playerPed, health) end
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)