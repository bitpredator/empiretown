ESX = exports["es_extended"]:getSharedObject()


lib.callback.register("z-phone:server:HasPhone", function(source)
    return xCore.HasItemByName(source, "phone")
end)

lib.callback.register("z-phone:server:GetWebhook", function(_)
    if WebHook ~= "" then
        return WebHook
    else
        print("Set your webhook to ensure that your camera will work!!!!!! Set this on line 10 of the server sided script!!!!!")
        return nil
    end
end)

lib.callback.register("z-phone:server:GetProfile", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end

    -- 🔑 Recupera citizenid dal tuo sistema xCore (se lo usi già altrove)
    local Player = xCore.GetPlayerBySource(source)
    if not Player then return nil end

    local profileData = MySQL.single.await([[
        SELECT citizenid, phone_number, avatar, inetmax_balance, 
               DATE_FORMAT(last_seen, '%d/%m/%Y %H:%i') as last_seen
        FROM zp_users
        WHERE citizenid = ?
        LIMIT 1
    ]], {
        Player.citizenid
    })

    return profileData
end)


