local function GenerateCallId(caller, target)
    return math.ceil(((tonumber(caller) or 0) + (tonumber(target) or 0)) / 100)
end

RegisterNUICallback('start-call', function(body, cb)
    if PhoneData.CallData.InCall then
        TriggerEvent("z-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "Phone",
            message = "You're in a call!"
        })
        cb(false)
        return
    end

    if not IsAllowToSendOrCall() then
        TriggerEvent("z-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not Profile or not Profile.inetmax_balance or not Profile.phone_number then
        TriggerEvent("z-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "Phone",
            message = "Profilo non caricato. Riprova."
        })
        cb(false)
        return
    end

    if Profile.inetmax_balance < Config.App.InetMax.InetMaxUsage.PhoneCall then
        TriggerEvent("z-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughInternetData
        })
        cb(false)
        return
    end

    local callId = GenerateCallId(Profile.phone_number, body.to_phone_number)
    body.call_id = callId
    body.is_anonim = Profile.is_anonim or false

    lib.callback('z-phone:server:StartCall', false, function(res)
        if not res or not res.is_valid then
            TriggerEvent("z-phone:client:sendNotifInternal", {
                type = "Notification",
                from = "Phone",
                message = res and res.message or "Errore nella chiamata"
            })
            cb(false)
            return
        end

        PhoneData.CallData.InCall = true
        PhoneData.CallData.AnsweredCall = false
        PhoneData.CallData.CallId = callId

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        cb(res)

        local RepeatCount = 0
        while PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall do
            RepeatCount = RepeatCount + 1

            if RepeatCount <= Config.CallRepeats then
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'zpcall', 0.2)
                Wait(Config.RepeatTimeout)
            else
                PhoneData.CallData.CallId = nil
                PhoneData.CallData.InCall = false

                TriggerEvent("z-phone:client:sendNotifInternal", {
                    type = "Notification",
                    from = "Phone",
                    message = "Call not answered"
                })

                lib.callback('z-phone:server:CancelCall', false, function(isOk)
                    -- cb non richiamato qui per evitare duplicazioni
                end, { to_source = res.to_source })
                break
            end
        end
    end, body)
end)

RegisterNUICallback('cancel-call', function(body, cb)
    lib.callback('z-phone:server:CancelCall', false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('decline-call', function(body, cb)
    lib.callback('z-phone:server:DeclineCall', false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('end-call', function(body, cb)
    lib.callback('z-phone:server:EndCall', false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('accept-call', function(body, cb)
    if PhoneData.isOpen then
        DoPhoneAnimation('cellphone_text_to_call')
    else
        DoPhoneAnimation('cellphone_call_listen_base')
    end

    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = true

    lib.callback('z-phone:server:AcceptCall', false, function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('get-call-histories', function(_, cb)
    lib.callback('z-phone:server:GetCallHistories', false, function(histories)
        cb(histories or {})
    end)
end)

