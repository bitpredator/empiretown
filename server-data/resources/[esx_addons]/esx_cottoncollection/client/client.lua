local Keys = {
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
local PlayerData = {}
local Peds = {}
local cotton = nil
local cottonMarker = nil
local playerPedId = nil
local onAction = false

Citizen.CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()
    while ESX.GetPlayerData().job == nil do Wait(0) end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


-- Creating Cottons
Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(5)
		playerPedId = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPedId)
		if cotton == nil then
			local num = math.random(#Config.Cottons)
			cotton = Config.Cottons[num]
		else
			local cottonCoords = vector3(cotton.posX, cotton.posY, cotton.posZ)
			if GetDistanceBetweenCoords(playerCoords, cottonCoords) < 18.0 then
				cottonMarker = DrawMarker(cotton.type, cotton.posX, cotton.posY, cotton.posZ - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, cotton.scaleX, cotton.scaleY, cotton.scaleZ, cotton.r, cotton.g, cotton.b, cotton.a, cotton.bobUpAndDown, cotton.faceCamera, cotton.p19, cotton.rotate, cotton.texture, cotton.drawOnEnts)
				if GetDistanceBetweenCoords(playerCoords, cottonCoords) < 0.7 then
					Draw3DText2(cottonCoords.x, cottonCoords.y, cottonCoords.z - 0.3, "[E]")
					if IsControlPressed(1, Keys["E"]) and not onAction and not IsPedInAnyVehicle(playerPedId, false) then
						onAction = true
						TriggerEvent("mythic_progressbar:client:progress",
						{
							name = "pickCotton",
							duration = 2000,
							label = "Stai raccogliendo il cotone!",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, 
							animation = {
								animDict = "anim@mp_snowball",
								anim = "pickup_snowball",
							}
						},function(status)
							if not status then
								ESX.TriggerServerCallback("npc:cotton:giveItem", function(state) 
									if state then
										cotton = nil
										Citizen.Wait(100)
										onAction = false
									else
										Citizen.Wait(100)
										onAction = false
									end
								end)
							else
								onAction = false
							 exports["esx_notify"]:Notify("info", 3000, "Hai annullato la raccolta del cotone")
							end
						end)
					end
				end
			end
		end
 	end
 end)

--Creating Blips
Citizen.CreateThread(function()
	Citizen.Wait(5)
	for k,v in pairs(Config.Blips) do 
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.type)
		SetBlipAsFriendly(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.name)
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip, true)
	end
end)

-- Draw Text
function Draw3DText2(x, y, z, text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	local px,py,pz = table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	local scale = (1 / dist) *1
	local fov = (1 / GetGameplayCamFov()) * 100
		local scale = 1.2

	if onScreen then
		SetTextScale(0.0 * scale, 0.25 * scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
		local factor = (string.len(text)) / 370
		DrawRect(_x, _y + 0.0125, 0.030 + factor, 0.03, 0, 0, 0, 100)
	end
end

-- on resource stop 
AddEventHandler("onResourceStop", function(resourceName)
  	if (GetCurrentResourceName() ~= resourceName) then
    	return
  	end
	for i = 0, #Peds  do
		if Peds and Peds[i] ~= nil then
			DeletePed(Peds[i].pId)
		end
	end
	Peds = {}
	cotton = nil
	cottonMarker = nil
	playerPedId = nil
end)