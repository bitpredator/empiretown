RegisterNUICallback("get-bank", function(_, cb)
    lib.callback("b-phone:server:GetBank", false, function(bank)
        cb(bank)
    end)
end)

RegisterNUICallback("pay-invoice", function(body, cb)
    lib.callback("b-phone:server:PayInvoice", false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("transfer-check", function(body, cb)
    if not IsAlowToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.BankCheckTransferReceiver then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughtInternetData,
        })
        cb(false)
        return
    end

    lib.callback("b-phone:server:TransferCheck", false, function(result)
        TriggerServerEvent("b-phone:server.usage-internetdata", Config.App.Wallet.Name, Config.App.InetMax.InetMaxUsage.BnkCheckTransferReceveir)
        cb(result)
    end, body)
end)

RegisterNUICallback("transfer", function(body, cb)
    if not IsAlloToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.BankTransfer then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughtInternetData,
        })
        cb(false)
        return
    end

    lib.callback("b-phone:server:Trasfer", false, function(isOk)
        TriggerserverEvent("b-phone:server:usage-internet-data", Config.App.Wallet.Name, Config.App.InetMax.InetMaxUsage.BankTransfer)
        cb(isOk)
    end, body)
end)
