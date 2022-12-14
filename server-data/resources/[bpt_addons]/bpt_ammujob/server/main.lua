local lastPlayerSuccess = {}

if Config.MaxInService ~= -1 then
    TriggerEvent('esx_service:activateService', 'ammu', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'ammu', 'Ammu', 'society_ammu', 'society_ammu', 'society_ammu', {
    type = 'public'
})

RegisterNetEvent('bpt_ammujob:success')
AddEventHandler('bpt_ammujob:success', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local timeNow = os.clock()

    if xPlayer.job.name == 'ammu' then
        if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
            lastPlayerSuccess[source] = timeNow

            if xPlayer.job.grade >= 3 then
                total = total * 2
            end

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ammu', function(account)
                if account then
                    local playerMoney = ESX.Math.Round(total / 100 * 30)
                    local societyMoney = ESX.Math.Round(total / 100 * 70)

                    xPlayer.addMoney(playerMoney, "Ammu Fair")
                    account.addMoney(societyMoney)

                    xPlayer.showNotification(_U('comp_earned', societyMoney, playerMoney))
                else
                    xPlayer.addMoney(total, "Ammu Fair")
                    xPlayer.showNotification(_U('have_earned', total))
                end
            end)
        end
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted to ^5bpt_ammujob:success^7 (cheating)'):format(source))
    end
end)

ESX.RegisterServerCallback("bpt_ammujob:SpawnVehicle", function(source, cb, model , props)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "ammu" then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to Exploit Vehicle Spawing!!'):format(source))
        return
    end
    local SpawnPoint = vector3(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z)
    ESX.OneSync.SpawnVehicle(joaat(model), SpawnPoint, Config.Zones.VehicleSpawnPoint.Heading, props, function(vehicle)
        local vehicle = NetworkGetEntityFromNetworkId(vehicle)
        while GetVehicleNumberPlateText(vehicle) ~= props.plate do
            Wait(0)
        end
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)
    cb()
end)

ESX.RegisterServerCallback('bpt_ammujob:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
	local minItems = xPlayer.getInventory(true)
	cb(next(minItems) ~= nil and items or false)
end)