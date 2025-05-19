RegisterNUICallback("loops-login", function(body, cb)
    lib.callback("b-phone:server:LoopsLogin", false, function(res)
        cb(res)
    end, body)
end)

RegisterNUICallback("loops-signup", function(body, cb)
    lib.callback("b-phone:server:LoopsSignup", false, function(res)
        cb(res)
    end, body)
end)

RegisterNUICallback("get-tweets", function(_, cb)
    lib.callback("b-phone:server:GetTweets", false, function(tweets)
        cb(tweets)
    end)
end)

RegisterNUICallback("send-tweet", function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.LoopsPostTweet then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughInternetData,
        })
        cb(false)
        return
    end

    lib.callback("b-phone:server:SendTweet", false, function(isOk)
        TriggerServerEvent("b-phone:server:usage-internet-data", Config.App.Loops.Name, Config.App.InetMax.InetMaxUsage.LoopsPostTweet)
        lib.callback("b-phone:server:GetTweets", false, function(tweets)
            cb(tweets)
        end)
    end, body)
end)

RegisterNUICallback("get-tweet-comments", function(body, cb)
    lib.callback("b-phone:server:GetComments", false, function(comments)
        cb(comments)
    end, body)
end)

RegisterNUICallback("send-tweet-comments", function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.LoopsPostComment then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughInternetData,
        })
        cb(false)
        return
    end

    lib.callback("b-phone:server:SendTweetComment", false, function(isOk)
        TriggerServerEvent("b-phone:server:usage-internet-data", Config.App.Loops.Name, Config.App.InetMax.InetMaxUsage.LoopsPostComment)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("update-loops-profile", function(body, cb)
    lib.callback("b-phone:server:UpdateLoopsProfile", false, function(profile)
        cb(profile)
    end, body)
end)

RegisterNUICallback("get-loops-profile", function(body, cb)
    lib.callback("b-phone:server:GetLoopsProfile", false, function(profile)
        cb(profile)
    end, body)
end)

RegisterNUICallback("loops-logout", function(_, cb)
    lib.callback("b-phone:server:UpdateLoopsLogout", false, function(isOk)
        cb(isOk)
    end)
end)
