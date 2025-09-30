---@diagnostic disable: undefined-global

-- Registrazione società
TriggerEvent("bpt_society:registerSociety", "import", TranslateCap("society_import"), "society_import", "society_import", "society_import", {
    type = "public",
})

--- Confisca item/armi/denaro
RegisterNetEvent("bpt_importjob:confiscatePlayerItem", function(target, itemType, itemName, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(target)

    if not xPlayer or xPlayer.job.name ~= "import" then
        return print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Confiscation!"):format(src))
    end

    if itemType == "item_standard" then
        local targetItem = tPlayer.getInventoryItem(itemName)
        if targetItem.count >= amount and amount > 0 then
            if xPlayer.canCarryItem(itemName, amount) then
                tPlayer.removeInventoryItem(itemName, amount)
                xPlayer.addInventoryItem(itemName, amount)
                xPlayer.showNotification(TranslateCap("you_confiscated", amount, targetItem.label, tPlayer.name))
                tPlayer.showNotification(TranslateCap("got_confiscated", amount, targetItem.label, xPlayer.name))
            else
                xPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    elseif itemType == "item_account" then
        local targetAccount = tPlayer.getAccount(itemName)
        if targetAccount.money >= amount then
            tPlayer.removeAccountMoney(itemName, amount, "Confiscated")
            xPlayer.addAccountMoney(itemName, amount, "Confiscated")
            xPlayer.showNotification(TranslateCap("you_confiscated_account", amount, itemName, tPlayer.name))
            tPlayer.showNotification(TranslateCap("got_confiscated_account", amount, itemName, xPlayer.name))
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    elseif itemType == "item_weapon" then
        if tPlayer.hasWeapon(itemName) then
            tPlayer.removeWeapon(itemName)
            xPlayer.addWeapon(itemName, amount or 0)
            xPlayer.showNotification(TranslateCap("you_confiscated_weapon", ESX.GetWeaponLabel(itemName), tPlayer.name, amount or 0))
            tPlayer.showNotification(TranslateCap("got_confiscated_weapon", ESX.GetWeaponLabel(itemName), amount or 0, xPlayer.name))
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end
end)

--- Azioni poliziesche base
RegisterNetEvent("bpt_importjob:handcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:handcuff", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 tried to exploit handcuff!"):format(source))
    end
end)

RegisterNetEvent("bpt_importjob:drag", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:drag", target, source)
    else
        print(("[^3WARNING^7] Player ^5%s^7 tried to exploit drag!"):format(source))
    end
end)

RegisterNetEvent("bpt_importjob:putInVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:putInVehicle", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 tried to exploit putInVehicle!"):format(source))
    end
end)

RegisterNetEvent("bpt_importjob:OutVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:OutVehicle", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 tried to exploit OutVehicle!"):format(source))
    end
end)

--- Stock Items
RegisterNetEvent("bpt_importjob:getStockItem", function(itemName, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        local item = inventory.getItem(itemName)
        if item.count >= count and count > 0 then
            if xPlayer.canCarryItem(itemName, count) then
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                xPlayer.showNotification(TranslateCap("have_withdrawn", count, item.label))
            else
                xPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end)
end)

RegisterNetEvent("bpt_importjob:putStockItems", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemName)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        if item.count >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            xPlayer.showNotification(TranslateCap("have_deposited", count, item.label))
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end)
end)

--- Callback: dati altri player
ESX.RegisterServerCallback("bpt_importjob:getOtherPlayerData", function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)
    if not xPlayer then
        return cb({})
    end

    if notify then
        xPlayer.showNotification(TranslateCap("being_searched"))
    end

    local data = {
        name = xPlayer.getName(),
        job = xPlayer.job.label,
        grade = xPlayer.job.grade_label,
        inventory = xPlayer.getInventory(),
        accounts = xPlayer.getAccounts(),
        weapons = xPlayer.getLoadout(),
    }

    if Config.EnableESXIdentity then
        data.dob = xPlayer.get("dateofbirth")
        data.height = xPlayer.get("height")
        data.sex = (xPlayer.get("sex") == "m" and "male" or "female")
    end

    TriggerEvent("bpt_status:getStatus", target, "drunk", function(status)
        if status then
            data.drunk = ESX.Math.Round(status.percent)
        end
    end)

    if Config.EnableLicenses then
        TriggerEvent("esx_license:getLicenses", target, function(licenses)
            data.licenses = licenses
            cb(data)
        end)
    else
        cb(data)
    end
end)

--- Callback: info veicolo
ESX.RegisterServerCallback("bpt_importjob:getVehicleInfos", function(source, cb, plate)
    local retrivedInfo = { plate = plate }

    if Config.EnableESXIdentity then
        MySQL.single("SELECT u.firstname, u.lastname FROM owned_vehicles ov JOIN users u ON ov.owner = u.identifier WHERE plate = ?", { plate }, function(result)
            if result then
                retrivedInfo.owner = ("%s %s"):format(result.firstname, result.lastname)
            end
            cb(retrivedInfo)
        end)
    else
        MySQL.scalar("SELECT owner FROM owned_vehicles WHERE plate = ?", { plate }, function(owner)
            if owner then
                local xPlayer = ESX.GetPlayerFromIdentifier(owner)
                if xPlayer then
                    retrivedInfo.owner = xPlayer.getName()
                end
            end
            cb(retrivedInfo)
        end)
    end
end)

--- Callback: deposito armi
ESX.RegisterServerCallback("bpt_importjob:getImportWeapons", function(source, cb)
    TriggerEvent("bpt_datastore:getSharedDataStore", "society_import", function(store)
        cb(store.get("weapons") or {})
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:addImportWeapon", function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent("bpt_datastore:getSharedDataStore", "society_import", function(store)
        local weapons = store.get("weapons") or {}
        local found = false

        for _, w in ipairs(weapons) do
            if w.name == weaponName then
                w.count = w.count + 1
                found = true
                break
            end
        end

        if not found then
            table.insert(weapons, { name = weaponName, count = 1 })
        end

        store.set("weapons", weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:removeImportWeapon", function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent("bpt_datastore:getSharedDataStore", "society_import", function(store)
        local weapons = store.get("weapons") or {}

        for _, w in ipairs(weapons) do
            if w.name == weaponName and w.count > 0 then
                w.count = w.count - 1
                break
            end
        end

        store.set("weapons", weapons)
        cb()
    end)
end)

--- Callback: compra veicolo
ESX.RegisterServerCallback("bpt_importjob:buyJobVehicle", function(source, cb, vehicleProps, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = GetPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

    if price == 0 then
        print(("[^3WARNING^7] Player ^5%s^7 tried to buy invalid vehicle %s!"):format(source, vehicleProps.model))
        return cb(false)
    end

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price, "Job Vehicle Bought")
        MySQL.insert("INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, stored) VALUES (?, ?, ?, ?, ?, ?)", {
            xPlayer.identifier,
            json.encode(vehicleProps),
            vehicleProps.plate,
            type,
            xPlayer.job.name,
            true,
        }, function()
            cb(true)
        end)
    else
        cb(false)
    end
end)

--- Callback: parcheggio veicolo
ESX.RegisterServerCallback("bpt_importjob:storeNearbyVehicle", function(source, cb, plates)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = MySQL.scalar.await("SELECT plate FROM owned_vehicles WHERE owner = ? AND plate IN (?) AND job = ?", {
        xPlayer.identifier,
        plates,
        xPlayer.job.name,
    })

    if plate then
        MySQL.update("UPDATE owned_vehicles SET stored = true WHERE owner = ? AND plate = ? AND job = ?", {
            xPlayer.identifier,
            plate,
            xPlayer.job.name,
        }, function(rowsChanged)
            cb(rowsChanged > 0 and plate or false)
        end)
    else
        cb(false)
    end
end)

function GetPriceFromHash(vehicleHash, jobGrade, type)
    local vehicles = Config.AuthorizedVehicles[type][jobGrade]
    for _, veh in ipairs(vehicles) do
        if GetHashKey(veh.model) == vehicleHash then
            return veh.price
        end
    end
    return 0
end

--- Callback: stock items
ESX.RegisterServerCallback("bpt_importjob:getStockItems", function(source, cb)
    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        cb(inventory.items)
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb({ items = xPlayer.inventory })
end)

--- Aggiornamento blips
RegisterNetEvent("bpt_importjob:spawned", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "import" then
        Wait(3000)
        TriggerClientEvent("bpt_importjob:updateBlip", -1)
    end
end)

RegisterNetEvent("bpt_importjob:forceBlip", function()
    for _, xPlayer in pairs(ESX.GetExtendedPlayers("job", "import")) do
        TriggerClientEvent("bpt_importjob:updateBlip", xPlayer.source)
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(3000)
        for _, xPlayer in pairs(ESX.GetExtendedPlayers("job", "import")) do
            TriggerClientEvent("bpt_importjob:updateBlip", xPlayer.source)
        end
    end
end)
