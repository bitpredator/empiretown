ESX = exports["es_extended"]:getSharedObject()

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'driving', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'driving', 'Driving', 'society_driving', 'society_driving', 'society_driving', {type = 'public'})

ESX.RegisterServerCallback('esx_drivingschooljob:getPlayerInventory', function(source, cb)
  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory
  cb({
    items      = items
  })
end)

RegisterNetEvent('esx_drivingschooljob:addLicense')
AddEventHandler('esx_drivingschooljob:addLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_drivingschooljob:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('esx_drivingschooljob:pay')
AddEventHandler('esx_drivingschooljob:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', ESX.Math.GroupDigits(price)))
end)