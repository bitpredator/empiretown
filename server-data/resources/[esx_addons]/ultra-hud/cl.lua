local health = 0
local armor = 0
local food = 0
local thirst = 0
local oxygen = 100
local posi = "bottom"

ESX = nil

CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()
end)

AddEventHandler('playerSpawned', function()  -- Enable hud only after player spawn
	CreateThread(function()
		Wait(100)
		while true do 
			Wait(1000)
			if IsEntityDead(GetPlayerPed(-1)) then
				health = 0
			else
				health = math.ceil(GetEntityHealth(GetPlayerPed(-1)) - 100)
			end
			armor = math.ceil(GetPedArmour(GetPlayerPed(-1)))
			oxygen = math.ceil(GetPlayerUnderwaterTimeRemaining(PlayerId())) * 4

			
			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				food = status.getPercent()
			end)
			
			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				thirst = status.getPercent()
			end)
			
			Wait(100)

			SendNUIMessage({
				posi = posi,
				show = IsPauseMenuActive(),  -- Disable hud if settings menu is active
				health = health,
				armor = armor,
				food = food,
				thirst = thirst,
				oxygen = oxygen,
			})
		end
	end)
end)



