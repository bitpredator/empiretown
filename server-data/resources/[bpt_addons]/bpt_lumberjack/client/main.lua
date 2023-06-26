Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local menuOpen = false

CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()
	while ESX.GetPlayerData().job == nil do
		Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

local spawnedWood = 0
local TreeWood = {}
local Collection, Processing = false, false

CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WoodField.coords, true) < 50 then
			SpawnTreeWood()
			Wait(500)
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WoodProcessing.coords, true) < 1 then
			if not Processing then
				ESX.ShowHelpNotification(_U('wood_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not Processing then

				if Config.LicenseEnable then
				else
					ProcessWood()
				end

			end
		else
			Wait(500)
		end
	end
end)

function ProcessingAnimation()
	local Animated = PlayerPedId()
	RequestAnimDict("timetable@floyd@clean_kitchen@base")
	Wait(1000)

	TaskPlayAnim(Animated, "timetable@floyd@clean_kitchen@base", "base", 10.0, 10.0, -1, 0, 0, false, false, false)
end

function ProcessWood()
	Processing = true
	ESX.ShowNotification(_U('wood_processingstarted'))
	TriggerServerEvent('bpt_woodcutter:processWood')
	local timeLeft = Config.Delays.WoodProcessing / 1000
	local playerPed = PlayerPedId()
	ProcessingAnimation()
	Wait(950)
	while timeLeft > 0 do
		
		Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WoodProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('wood_processingtoofar'))
			TriggerServerEvent('bpt_woodcutter:cancelProcessing')
			break
		end
	end

	Processing = false
end

function treecutter()
	local cut = PlayerPedId()
	
	RequestAnimDict("melee@hatchet@streamed_core")
	Wait(1200)

	TaskPlayAnim(cut, "melee@hatchet@streamed_core", "plyr_front_takedown_b", 6.0, -6.0, -1, 0, 0, false, false, false)
end

CreateThread(function()
	while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local treewood
		
		for i=1, #TreeWood, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(TreeWood[i]), false) < 1 then
				treewood = TreeWood[i], i
			end
		end

		if treewood and IsPedOnFoot(player) then

			if not Collection then
				ESX.ShowHelpNotification(_U('wood_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not Collection then
				ollection = true

				ESX.TriggerServerCallback('bpt_woodcutter:canPickUp', function(canPickUp)

					if canPickUp then
						GiveWeaponToPed(player, "WEAPON_HATCHET", 800, false, false)
						SetCurrentPedWeapon(player, GetHashKey("WEAPON_HATCHET"), false)
						treecutter()
						Wait(3000)
						Wait(400)
						ClearPedTasks(player)
						Wait(400)
						SetEntityRotation(treewood, 80.0, -0, 85.0, false, true)
						Wait(200)
						DeleteObject(treewood)
						RemoveWeaponFromPed(player, GetHashKey("WEAPON_HATCHET"), true, true)
						SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), false)
						TriggerServerEvent('bpt_woodcutter:pickedUpWood')
					else
						ESX.ShowNotification(_U('wood_inventoryfull'))
					end
					Collection = false

				end, 'wood')
			end

		else
			Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(TreeWood) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnTreeWood()
	while spawnedWood < 25 do
		Wait(0)
		local woodCoords = GenerateWoodCoords()

		ESX.Game.SpawnLocalObject('prop_tree_eng_oak_cr2', woodCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(TreeWood, obj)
			spawnedWood = spawnedWood + 1
		end)
	end
end

function ValidateWoodCoord(plantCoord)
	if spawnedWood > 0 then
		local validate = true

		for _, v in pairs(TreeWood) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WoodField.coords, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

function GenerateWoodCoords()
	while true do
		Wait(1)
		local woodCoordX, woodCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)
		woodCoordX = Config.CircleZones.WoodField.coords.x + modX
		woodCoordY = Config.CircleZones.WoodField.coords.y + modY
		local coordZ = GetCoordZ(woodCoordX, woodCoordY)
		local coord = vector3(woodCoordX, woodCoordY, coordZ)

		if ValidateWoodCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }
	for _, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

function CreateBlipCircle(coords, text, radius, color, sprite)
	local blip = AddBlipForRadius(coords, radius)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	-- create a blip in the middle
	blip = AddBlipForCoord(coords)
	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

CreateThread(function()
	for _,zone in pairs(Config.CircleZones) do
		CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	end
end)