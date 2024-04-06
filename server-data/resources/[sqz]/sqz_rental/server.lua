local rentedVehicles = {}
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("sqz_carrental:RentVehicle")
AddEventHandler("sqz_carrental:RentVehicle", function(model, insurance, price, time, rentalIndex)
	time = time:gsub("min", "")
	time = tonumber(time)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price + Config.DownPayment then
		xPlayer.removeMoney(price + Config.DownPayment)
		xPlayer.showNotification(TranslateCap("you_paid") .. price .. "$")
		xPlayer.showNotification(TranslateCap("you_paid") .. Config.DownPayment .. TranslateCap("down_payment"))
		TriggerClientEvent("sqz_carrental:SpawnVehicle", source, model, insurance, price, time, rentalIndex)
	elseif xPlayer.getAccount("bank").money >= price + Config.DownPayment then
		xPlayer.removeAccountMoney("bank", price + Config.DownPayment)
		xPlayer.showNotification(
			TranslateCap("you_paid") .. Config.DownPayment .. TranslateCap("deposit_from_bank_account")
		)
		xPlayer.showNotification(TranslateCap("you_paid") .. price .. TranslateCap("bank_account"))
		TriggerClientEvent("sqz_carrental:SpawnVehicle", source, model, insurance, price, time, rentalIndex)
	else
		xPlayer.showNotification(TranslateCap("you_cant_rent"))
	end
end)

RegisterNetEvent("sqz_carrental:VehicleSpawned")
AddEventHandler("sqz_carrental:VehicleSpawned", function(plate, insurance, time, netId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not rentedVehicles[plate] then
		rentedVehicles[plate] = {
			owner = xPlayer.identifier,
			insurance = insurance,
			netId = netId,
			downPayment = Config.DownPayment,
		}
		SetTimeout(time * 60 * 1000 + 5000, function()
			local plate = GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(netId))
			if rentedVehicles[plate] then
				if GetPlayerPing(rentedVehicles[plate].owner) > 5 then
					CreateThread(function()
						while true do
							Wait(1000 * 60)
							if rentedVehicles[plate].downPayment >= Config.ExtraChargePerMinute then
								rentedVehicles[plate].downPayment = rentedVehicles[plate].downPayment
									- Config.ExtraChargePerMinute
							else
								if ESX.GetPlayerFromId(_source) then
									xPlayer.showNotification(TranslateCap("deposit_not_refunded"))
									xPlayer.showNotification(TranslateCap("vehicle_seized"))
								end
								DeleteEntity(NetworkGetEntityFromNetworkId(netId))
								rentedVehicles[plate] = nil
							end
						end
					end)
				else
					rentedVehicles[plate] = nil
					DeleteEntity(NetworkGetEntityFromNetworkId(netId))
				end
			end
		end)
	end
end)

RegisterNetEvent("sqz_carrental:ReturnVehicle")
AddEventHandler("sqz_carrental:ReturnVehicle", function(plate, damageIndex)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not rentedVehicles[plate] then
		xPlayer.showNotification(TranslateCap("vehicle_not_rented"))
		return
	end

	if rentedVehicles[plate].owner ~= xPlayer.identifier then
		xPlayer.showNotification(TranslateCap("you_cannot_return_vehicle"))
		return
	end

	if rentedVehicles[plate].insurance then
		damageIndex = 1
	end

	local moneyToGive = math.floor(rentedVehicles[plate].downPayment * damageIndex)

	if damageIndex < 1 then
		local reducedBy = Config.DownPayment - Config.DownPayment * damageIndex
		xPlayer.showNotification(TranslateCap("reduced_deposit") .. reducedBy .. (TranslateCap("damaged_vehicle")))
	end

	xPlayer.addAccountMoney("bank", moneyToGive)
	xPlayer.showNotification(TranslateCap("payment_amount") .. moneyToGive .. TranslateCap("been_returned"))
	TaskLeaveVehicle(GetPlayerPed(source), NetworkGetEntityFromNetworkId(rentedVehicles[plate].netId), 0)
	Wait(1700)
	DeleteEntity(NetworkGetEntityFromNetworkId(rentedVehicles[plate].netId))
	rentedVehicles[plate] = nil
	TriggerClientEvent("sqz_carrental:VehicleSuccessfulyReturned", xPlayer.source)
end)
