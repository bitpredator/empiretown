RegisterNUICallback("new-or-continue-chat", function(body, cb)
	lib.callback("z-phone:server:StartOrContinueChatting", false, function(chatting)
		cb(chatting)
	end, body)
end)

RegisterNUICallback("get-chats", function(_, cb)
	lib.callback("z-phone:server:GetChats", false, function(chats)
		cb(chats)
	end)
end)

RegisterNUICallback("get-chatting", function(body, cb)
	lib.callback("z-phone:server:GetChatting", false, function(chatting)
		cb(chatting)
	end, body)
end)

RegisterNUICallback("send-chatting", function(body, cb)
	if not IsAllowToSendOrCall() then
		TriggerEvent("z-phone:client:sendNotifInternal", {
			type = "Notification",
			from = Config.App.InetMax.Name,
			message = Config.MsgSignalZone,
		})
		cb(false)
		return
	end

	-- 🔒 Se il profilo non è caricato, ricaricalo e blocca l'invio
	if not Profile then
		print("^1[Z-Phone] Profile non trovato, richiedo al server...^0")
		lib.callback("z-phone:server:GetProfile", false, function(data)
			if data then
				Profile = data
				print("^2[Z-Phone] Profile aggiornato^0")
			end
		end)
		cb(false)
		return
	end

	if (Profile.inetmax_balance or 0) < Config.App.InetMax.InetMaxUsage.MessageSend then
		TriggerEvent("z-phone:client:sendNotifInternal", {
			type = "Notification",
			from = Config.App.InetMax.Name,
			message = Config.MsgNotEnoughInternetData,
		})
		cb(false)
		return
	end

	lib.callback("z-phone:server:SendChatting", false, function(isOk)
		if isOk then
			TriggerServerEvent(
				"z-phone:server:usage-internet-data",
				Config.App.Message.Name,
				Config.App.InetMax.InetMaxUsage.MessageSend
			)
		end
		cb(isOk)
	end, body)
end)

RegisterNUICallback("delete-message", function(body, cb)
	lib.callback("z-phone:server:DeleteMessage", false, function(isOk)
		cb(isOk)
	end, body)
end)

RegisterNUICallback("create-group", function(body, cb)
	lib.callback("z-phone:server:CreateGroup", false, function(isOk)
		if isOk then
			TriggerEvent("z-phone:client:sendNotifInternal", {
				type = "Notification",
				from = "Message",
				message = "Group chat created!",
			})
		end
		cb(isOk)
	end, body)
end)
