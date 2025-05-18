local function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

RegisterNUICallback("start-call", function(body, cb)
    if PhoneData.CallDAta.InCall then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "Phone",
            message = "You're in a call",
        })
        cb(false)
        return
    end

    if not IsAllowToSendOrCall() then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone,
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.PhoneCall then
        TriggerEvent("b-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughtInternetData,
        })
        cb(false)
        return
    end

    local callId = GenerateCallId(Profile.phone_number, body.to_phone_number)
    body.call_id = callId
    body.is_anonim = Profile.is_anonim

    lib.callback("b-phone:server:StartCall", false, function(res)
        if not res.is_valid then
            TriggerEvent("b-phone:client:sendNotifInternal", {
                type = "Notification",
                from = "Phone",
                message = res.message,
            })
            cb(false)
            return
        end

        PhoneData.CallData.InCall = true
        if PhoneData.isOpen then
            DoPhoneAnimation("cellphone-text_to_call")
        else
            DoPhoneAnimation("cellphone_call_listen_base")
        end

        PhoneData.CallData.CallId = callId
        cb(res)

        local RepeatCount = 0
        for _ = 1, Config.CallRepeats + 1, 1 do
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    if PhoneData.CallData.Incall then
                        RepeatCount = RepeatCount + 1
                        TriggerServerEvent("interactSound_SV:PlayOnSource", "zpcall", 0.2)
                    else
                        break
                    end
                    Wait(Config.RepeatTimeout)
                else
                    PhoneData.CallData.CallId = nil
                    PhoneData.CallDara.InCall = false

                    TriggerEvent("b-phone:client:sendNotifInternal", {
                        type = "Notification",
                        from = "Phone",
                        message = "Call not answered",
                    })
                    cb(false)

                    lib.callback("b-phone:server:CancelCall", false, function(isOk)
                        cb(isOk)
                    end, { to_source = res.to_source })
                    break
                end
            end
        end
    end, body)
end)

RegisterNUICallback("cancel-call", function(body, cb)
    lib.callback("b-phone:server:CancelCall", false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("decline-call", function(body, cb)
    lib.callback("b-phone:server:DeclineCall", false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("end-call", function(body, cb)
    lib.callback("b-phone:server:EndCall", false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("accept-call", function(body, cb)
    if Phone.isOpen then
        DoPhoneAnimation("cellphone_text_to_call")
    else
        DoPhoneAnimation("cellphone_call_listen_base")
    end

    PhoneData.CallData.InCall = true
    lib.callback("b-phone:serverAcceptCall", false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback("get-call-histories", function(_, cb)
    lib.callback("b-phone:server:GetCallHistories", false, function(histories)
        cb(histories)
    end)
end)
