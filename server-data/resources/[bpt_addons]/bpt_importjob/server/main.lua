---@diagnostic disable: undefined-global

TriggerEvent("bpt_society:registerSociety", "import", TranslateCap("society_import"), "society_import", "society_import", "society_import", {
    type = "public",
})

RegisterNetEvent("bpt_importjob:confiscatePlayerItem")
AddEventHandler("bpt_importjob:confiscatePlayerItem", function(target, itemType, itemName, amount)
    local source = source
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if sourceXPlayer.job.name ~= "import" then
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit The Confuscation System!"):format(sourceXPlayer.source))
        return
    end

    if itemType == "item_standard" then
        local targetItem = targetXPlayer.getInventoryItem(itemName)
        local sourceItem = sourceXPlayer.getInventoryItem(itemName)

        -- does the target player have enough in their inventory?
        if targetItem.count > 0 and targetItem.count <= amount then
            -- can the player carry the said amount of x item?
            if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
                targetXPlayer.removeInventoryItem(itemName, amount)
                sourceXPlayer.addInventoryItem(itemName, amount)
                sourceXPlayer.showNotification(TranslateCap("you_confiscated", amount, sourceItem.label, targetXPlayer.name))
                targetXPlayer.showNotification(TranslateCap("got_confiscated", amount, sourceItem.label, sourceXPlayer.name))
            else
                sourceXPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        else
            sourceXPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    elseif itemType == "item_account" then
        local targetAccount = targetXPlayer.getAccount(itemName)

        -- does the target player have enough money?
        if targetAccount.money >= amount then
            targetXPlayer.removeAccountMoney(itemName, amount, "Confiscated")
            sourceXPlayer.addAccountMoney(itemName, amount, "Confiscated")

            sourceXPlayer.showNotification(TranslateCap("you_confiscated_account", amount, itemName, targetXPlayer.name))
            targetXPlayer.showNotification(TranslateCap("got_confiscated_account", amount, itemName, sourceXPlayer.name))
        else
            sourceXPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    elseif itemType == "item_weapon" then
        if amount == nil then
            amount = 0
        end

        -- does the target player have weapon?
        if targetXPlayer.hasWeapon(itemName) then
            targetXPlayer.removeWeapon(itemName)
            sourceXPlayer.addWeapon(itemName, amount)

            sourceXPlayer.showNotification(TranslateCap("you_confiscated_weapon", ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
            targetXPlayer.showNotification(TranslateCap("got_confiscated_weapon", ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
        else
            sourceXPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end
end)

RegisterNetEvent("bpt_importjob:handcuff")
AddEventHandler("bpt_importjob:handcuff", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:handcuff", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Handcuffs!"):format(xPlayer.source))
    end
end)

RegisterNetEvent("bpt_importjob:drag")
AddEventHandler("bpt_importjob:drag", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:drag", target, source)
    else
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Dragging!"):format(xPlayer.source))
    end
end)

RegisterNetEvent("bpt_importjob:putInVehicle")
AddEventHandler("bpt_importjob:putInVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:putInVehicle", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Garage!"):format(xPlayer.source))
    end
end)

RegisterNetEvent("bpt_importjob:OutVehicle")
AddEventHandler("bpt_importjob:OutVehicle", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "import" then
        TriggerClientEvent("bpt_importjob:OutVehicle", target)
    else
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Dragging Out Of Vehicle!"):format(xPlayer.source))
    end
end)

RegisterNetEvent("bpt_importjob:getStockItem")
AddEventHandler("bpt_importjob:getStockItem", function(itemName, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        -- is there enough in the society?
        if count > 0 and inventoryItem.count >= count then
            -- can the player carry the said amount of x item?
            if xPlayer.canCarryItem(itemName, count) then
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                xPlayer.showNotification(TranslateCap("have_withdrawn", count, inventoryItem.name))
            else
                xPlayer.showNotification(TranslateCap("quantity_invalid"))
            end
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end)
end)

RegisterNetEvent("bpt_importjob:putStockItems")
AddEventHandler("bpt_importjob:putStockItems", function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        -- does the player have enough of the item?
        if sourceItem.count >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            xPlayer.showNotification(TranslateCap("have_deposited", count, inventoryItem.name))
        else
            xPlayer.showNotification(TranslateCap("quantity_invalid"))
        end
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:getOtherPlayerData", function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    if notify then
        xPlayer.showNotification(TranslateCap("being_searched"))
    end

    if xPlayer then
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

            if xPlayer.get("sex") == "m" then
                data.sex = "male"
            else
                data.sex = "female"
            end
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
    end
end)

ESX.RegisterServerCallback("bpt_importjob:getVehicleInfos", function(source, cb, plate)
    local retrivedInfo = {
        plate = plate,
    }
    if Config.EnableESXIdentity then
        MySQL.single("SELECT users.firstname, users.lastname FROM owned_vehicles JOIN users ON owned_vehicles.owner = users.identifier WHERE plate = ?", { plate }, function(result)
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

ESX.RegisterServerCallback("bpt_importjob:getImportWeapons", function(source, cb)
    TriggerEvent("bpt_datastore:getSharedDataStore", "society_import", function(store)
        local weapons = store.get("weapons")

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:addImportWeapon", function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent("bpt_datastore:getSharedDataStore", "society_import", function(store)
        local weapons = store.get("weapons") or {}
        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1,
            })
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

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0,
            })
        end

        store.set("weapons", weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:buyJobVehicle", function(source, cb, vehicleProps, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = GetPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

    -- vehicle model not found
    if price == 0 then
        print(("[^3WARNING^7] Player ^5%s^7 Attempted To Buy Invalid Vehicle - ^5%s^7!"):format(source, vehicleProps.model))
        cb(false)
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price, "Job Vehicle Bought")

            MySQL.insert("INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (?, ?, ?, ?, ?, ?)", { xPlayer.identifier, json.encode(vehicleProps), vehicleProps.plate, type, xPlayer.job.name, true }, function(rowsChanged)
                cb(true)
            end)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback("bpt_importjob:storeNearbyVehicle", function(source, cb, plates)
    local xPlayer = ESX.GetPlayerFromId(source)

    local plate = MySQL.scalar.await("SELECT plate FROM owned_vehicles WHERE owner = ? AND plate IN (?) AND job = ?", { xPlayer.identifier, plates, xPlayer.job.name })

    if plate then
        MySQL.update("UPDATE owned_vehicles SET `stored` = true WHERE owner = ? AND plate = ? AND job = ?", { xPlayer.identifier, plate, xPlayer.job.name }, function(rowsChanged)
            if rowsChanged == 0 then
                cb(false)
            else
                cb(plate)
            end
        end)
    else
        cb(false)
    end
end)

function GetPriceFromHash(vehicleHash, jobGrade, type)
    local vehicles = Config.AuthorizedVehicles[type][jobGrade]

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if GetHashKey(vehicle.model) == vehicleHash then
            return vehicle.price
        end
    end

    return 0
end

ESX.RegisterServerCallback("bpt_importjob:getStockItems", function(source, cb)
    TriggerEvent("bpt_addoninventory:getSharedInventory", "society_import", function(inventory)
        cb(inventory.items)
    end)
end)

ESX.RegisterServerCallback("bpt_importjob:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    cb({ items = items })
end)

RegisterNetEvent("bpt_importjob:spawned")
AddEventHandler("bpt_importjob:spawned", function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer and xPlayer.job.name == "import" then
        Wait(5000)
        TriggerClientEvent("bpt_importjob:updateBlip", -1)
    end
end)

RegisterNetEvent("bpt_importjob:forceBlip")
AddEventHandler("bpt_importjob:forceBlip", function()
    for _, xPlayer in pairs(ESX.GetExtendedPlayers("job", "import")) do
        TriggerClientEvent("bpt_importjob:updateBlip", xPlayer.source)
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(5000)
        for _, xPlayer in pairs(ESX.GetExtendedPlayers("job", "import")) do
            TriggerClientEvent("bpt_importjob:updateBlip", xPlayer.source)
        end
    end
end)
