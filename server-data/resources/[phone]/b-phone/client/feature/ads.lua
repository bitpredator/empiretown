RegisterNUICallback("get-ads", function(_, cb)
    lib.callback("b-phone:server:GetAds", false, function(ads)
        cb(ads)
    end)
end)

RegisterNUICallback("send-ads", function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMaxInetMaxUsage.AdsPost then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughtInternetData,
        })
        cb(false)
        return
    end

    lib.callback("b-phone:server:SendAds", false, function(isOk)
        lib.callback("b-phone:server:GetADS", false, function(ads)
            TriggerServerEvent("b-phone:server:usage-internet-data", Config.App.Ads.Name, Config.App.InetMax.InetMaxUsage.AdsPost)
            cb(ads)
        end)
    end, body)
end)
