---@diagnostic disable: undefined-global
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("vehicleTaxSystem:submitCategories", function(vehicleList)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    local totalTax = 0

    for _, vehicle in pairs(vehicleList) do
        local tax = Config.VehicleTaxes[vehicle.model] or 50 -- default tax se non definito
        totalTax = totalTax + tax
    end

    if xPlayer.getAccount("bank").money >= totalTax then
        xPlayer.removeAccountMoney("bank", totalTax)

        -- Versa le tasse nella società
        TriggerEvent("bpt_addonaccount:getSharedAccount", "society_government", function(account)
            if account then
                account.addMoney(totalTax)
            end
        end)

        TriggerClientEvent("esx:showNotification", source, TranslateCap("tax_paid", totalTax))
    else
        TriggerClientEvent("esx:showNotification", source, TranslateCap("not_enough_bank"))
    end
end)

-- Timer giornaliero per pagamento automatico
CreateThread(function()
    while true do
        local now = os.date("*t")
        local secondsToNextHour = 86400 - (now.hour * 3600 + now.min * 60 + now.sec)
        Wait(secondsToNextHour * 1000)

        if Config.AutoTaxEnabled then
            TriggerEvent("vehicleTaxSystem:runAutoTax")
        end
    end
end)

RegisterNetEvent("vehicleTaxSystem:runAutoTax", function()
    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        local vehicles = MySQL.query.await("SELECT model FROM owned_vehicles WHERE owner = ?", { xPlayer.identifier })

        local totalTax = 0
        for _, veh in pairs(vehicles) do
            local model = json.decode(veh.model).model
            local tax = Config.VehicleTaxes[model] or 50
            totalTax = totalTax + tax
        end

        if totalTax > 0 then
            if xPlayer.getAccount("bank").money >= totalTax then
                xPlayer.removeAccountMoney("bank", totalTax)

                TriggerEvent("bpt_addonaccount:getSharedAccount", "society_government", function(account)
                    if account then
                        account.addMoney(totalTax)
                    end
                end)

                xPlayer.showNotification(TranslateCap("tax_paid", totalTax))
            else
                xPlayer.showNotification(TranslateCap("not_enough_bank"))
            end
        end
    end
end)
