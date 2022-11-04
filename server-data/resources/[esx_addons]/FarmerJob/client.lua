

if cfg.esxLegacy == false then
    ESX = nil -- ESX 
    CreateThread(function()
	    ESX = exports["es_extended"]:getSharedObject()
    end)
end

RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local blip = nil
local blipapple = nil
local apple = true

CreateThread(function()
	while true do
        Citizen.Wait(5000)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == cfg.job['job'] then
            if blip == nil then
                SetBlipSprite(blip, 89)
                SetBlipColour(blip, 37)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('blip')
                EndTextCommandSetBlipName(blip)
            end
			if blipapple == nil then
                blipapple = AddBlipForCoord(cfg.blip['blipapple'])
                AddTextEntry('blip', cfg.blip['blipapplename'])
                SetBlipSprite(blipapple, 76)
                SetBlipColour(blipapple, 1)
                SetBlipDisplay(blipapple, 4)
                SetBlipScale(blipapple, 1.0)
                SetBlipAsShortRange(blipapple, true)
                BeginTextCommandSetBlipName('blip')
                EndTextCommandSetBlipName(blipapple)
            end

        else
            if blip ~= nil then
                RemoveBlip(blip)
                blip = nil
            end
			if blipapple ~= nil then
                RemoveBlip(blipapple)
                blipapple = nil
            end
        end
    end
end)

CreateThread(function()
	while true do
        cas = 1000
		local playerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPedId())
        local pos = (cfg.marker['apple'])
		local dist = #(Coords - pos)
        if dist < 10 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == cfg.job['job'] then
                if apple then
                    apple = true
                    if apple == true then
                        cas = 5
                        ShowFloatingHelpNotification(cfg.translation['apple'], pos)
                        if IsControlJustPressed(0, 38) then
                            apple = true
                            TriggerServerEvent("apple:getapple")
							TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
							Wait(5000)
							ClearPedTasks(playerPed)

                        end
                    end
                end
            end
        end
        Wait(cas)
	end
end)

ShowFloatingHelpNotification = function(msg, pos)
    AddTextEntry('text', msg)
    SetFloatingHelpTextWorldPosition(1, pos.x, pos.y, pos.z)
    SetFloatingHelpTextStyle(2, 1, 25, -1, 3, 0)
    BeginTextCommandDisplayHelp('text')
    EndTextCommandDisplayHelp(2, false, false, -1)
end
-- IN TEST

zastavitkravu = function()
local player = PlayerPedId()
	if player then
		GetClosestPed(GetEntityCoords(PlayerPedId()), 5, true, true, true, true, 28)
		print("funguje")
	end
end

