ESX = exports["es_extended"]:getSharedObject()

do
	local origRegisterServerEvent = RegisterServerEvent
	local origEsxRegisterServerCallback = ESX.RegisterServerCallback

	RegisterServerEvent = function(eventName, ...)
		local endIdx = ("bpt_menu:"):len()

		if eventName:sub(1, endIdx) == "bpt_menu" then
			local oldEventName = ("bpt-PersonalMenu:%s"):format(eventName:sub(endIdx + 1))

			origRegisterServerEvent(oldEventName)
			AddEventHandler(oldEventName, function()
				DropPlayer(
					source,
					(
						"Server detected a potentially abusive behaviour.\n"
						.. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n"
						.. "- DEBUG INFO -\n"
						.. "Resource Name : %s\n"
						.. "Event Name : %s"
					):format(GetCurrentResourceName(), oldEventName)
				)
			end)
		end

		return origRegisterServerEvent(eventName, ...)
	end

	ESX.RegisterServerCallback = function(eventName, ...)
		local endIdx = ("bpt_menu:"):len()

		if eventName:sub(1, endIdx) == "bpt_menu" then
			local oldEventName = ("bpt-PersonalMenu:%s"):format(eventName:sub(endIdx + 1))

			origEsxRegisterServerCallback(oldEventName, function(source)
				DropPlayer(
					source,
					(
						"Server detected a potentially abusive behaviour.\n"
						.. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n"
						.. "- DEBUG INFO -\n"
						.. "Resource Name : %s\n"
						.. "Event Name : %s"
					):format(GetCurrentResourceName(), oldEventName)
				)
			end)
		end

		return origEsxRegisterServerCallback(eventName, ...)
	end
end

function getMaximumGrade(jobName)
	local p = promise.new()

	MySQL.Async.fetchScalar(
		"SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC",
		{ ["@job_name"] = jobName },
		function(result)
			p:resolve(result)
		end
	)

	local queryResult = Citizen.Await(p)

	return tonumber(queryResult)
end

function getAdminCommand(name)
	for i = 1, #Config.Admin do
		if Config.Admin[i].name == name then
			return i
		end
	end

	return false
end

function isAuthorized(index, group)
	for i = 1, #Config.Admin[index].groups do
		if Config.Admin[index].groups[i] == group then
			return true
		end
	end

	return false
end

ESX.RegisterServerCallback("bpt_menu:Bill_getBills", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM billing WHERE identifier = @identifier", {
		["@identifier"] = xPlayer.identifier,
	}, function(result)
		local bills = {}

		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount,
			}
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback("bpt_menu:Admin_getUsergroup", function(source, cb)
	cb(ESX.GetPlayerFromId(source).getGroup() or "user")
end)

local function makeTargetedEventFunction(fn)
	return function(target, ...)
		if tonumber(target) == -1 then
			return
		end
		fn(target, ...)
	end
end

-- Admin Menu --
RegisterServerEvent("bpt_menu:Admin_BringS")
AddEventHandler(
	"bpt_menu:Admin_BringS",
	makeTargetedEventFunction(function(playerId, target)
		local xPlayer = ESX.GetPlayerFromId(source)
		local plyGroup = xPlayer.getGroup()

		if isAuthorized(getAdminCommand("bring"), plyGroup) or isAuthorized(getAdminCommand("goto"), plyGroup) then
			TriggerClientEvent("bpt_menu:Admin_BringC", playerId, GetEntityCoords(GetPlayerPed(target)))
		end
	end)
)

RegisterServerEvent("bpt_menu:Admin_giveCash")
AddEventHandler("bpt_menu:Admin_giveCash", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand("givemoney"), plyGroup) then
		xPlayer.addAccountMoney("cash", amount)
		TriggerClientEvent("esx:showNotification", xPlayer.source, _U("received_money_cash"):format(amount))
	end
end)

RegisterServerEvent("bpt_menu:Admin_giveBank")
AddEventHandler("bpt_menu:Admin_giveBank", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand("givebank"), plyGroup) then
		xPlayer.addAccountMoney("bank", amount)
		TriggerClientEvent("esx:showNotification", xPlayer.source, _U("givebank"):format(amount))
	end
end)

RegisterServerEvent("bpt_menu:Admin_giveDirtyMoney")
AddEventHandler("bpt_menu:Admin_giveDirtyMoney", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand("givedirtymoney"), plyGroup) then
		xPlayer.addAccountMoney("black_money", amount)
		TriggerClientEvent("esx:showNotification", xPlayer.source, _U("givedirtymoney"):format(amount))
	end
end)

-- Grade Menu --
RegisterServerEvent("bpt_menu:Boss_promoteplayer")
AddEventHandler(
	"bpt_menu:Boss_promoteplayer",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob = sourceXPlayer.getJob()

		if sourceJob.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob = targetXPlayer.getJob()

			if sourceJob.name == targetJob.name then
				local newGrade = tonumber(targetJob.grade) + 1

				if newGrade ~= getMaximumGrade(targetJob.name) then
					targetXPlayer.setJob(targetJob.name, newGrade)
					TriggerClientEvent(
						"esx:showNotification",
						sourceXPlayer.source,
						_U("promoted"):format(targetXPlayer.name)
					)
					TriggerClientEvent("esx:showNotification", target, _U("you_promoted"):format(sourceXPlayer.name))
				else
					TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
				end
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_dismissplayer")
AddEventHandler(
	"bpt_menu:Boss_dismissplayer",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob = sourceXPlayer.getJob()

		if sourceJob.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob = targetXPlayer.getJob()

			if sourceJob.name == targetJob.name then
				local newGrade = tonumber(targetJob.grade) - 1

				if newGrade >= 0 then
					targetXPlayer.setJob(targetJob.name, newGrade)
					TriggerClientEvent(
						"esx:showNotification",
						sourceXPlayer.source,
						_U("you_been_relegated"):format(targetXPlayer.name)
					)
					TriggerClientEvent("esx:showNotification", target, _U("demoted_from"):format(sourceXPlayer.name))
				else
					TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_downgrade"))
				end
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_recruitplayer")
AddEventHandler(
	"bpt_menu:Boss_recruitplayer",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob = sourceXPlayer.getJob()

		if sourceJob.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)

			targetXPlayer.setJob(sourceJob.name, 0)
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("you_hired"):format(targetXPlayer.name))
			TriggerClientEvent("esx:showNotification", target, _U("you_hired_by"):format(sourceXPlayer.name))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_fireplayer")
AddEventHandler(
	"bpt_menu:Boss_fireplayer",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob = sourceXPlayer.getJob()

		if sourceJob.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob = targetXPlayer.getJob()

			if sourceJob.name == targetJob.name then
				targetXPlayer.setJob("unemployed", 0)
				TriggerClientEvent(
					"esx:showNotification",
					sourceXPlayer.source,
					_U("you_fired"):format(targetXPlayer.name)
				)
				TriggerClientEvent("esx:showNotification", target, _U("you_were_fired"):format(sourceXPlayer.name))
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_promoteplayer2")
AddEventHandler(
	"bpt_menu:Boss_promoteplayer2",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob2 = sourceXPlayer.getJob2()

		if sourceJob2.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob2 = targetXPlayer.getJob2()

			if sourceJob2.name == targetJob2.name then
				local newGrade = tonumber(targetJob2.grade) + 1

				if newGrade ~= getMaximumGrade(targetJob2.name) then
					targetXPlayer.setJob2(targetJob2.name, newGrade)
					TriggerClientEvent(
						"esx:showNotification",
						sourceXPlayer.source,
						_U("promoted"):format(targetXPlayer.name)
					)
					TriggerClientEvent("esx:showNotification", target, _U("you_promoted"):format(sourceXPlayer.name))
				else
					TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
				end
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_dismissplayer2")
AddEventHandler(
	"bpt_menu:Boss_dismissplayer2",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob2 = sourceXPlayer.getJob2()

		if sourceJob2.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob2 = targetXPlayer.getJob2()

			if sourceJob2.name == targetJob2.name then
				local newGrade = tonumber(targetJob2.grade) - 1

				if newGrade >= 0 then
					targetXPlayer.setJob2(targetJob2.name, newGrade)
					TriggerClientEvent(
						"esx:showNotification",
						sourceXPlayer.source,
						_("you_been_relegated"):format(targetXPlayer.name)
					)
					TriggerClientEvent("esx:showNotification", target, _U("demoted_from"):format(sourceXPlayer.name))
				else
					TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_downgrade"))
				end
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_recruitplayer2")
AddEventHandler(
	"bpt_menu:Boss_recruitplayer2",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob2 = sourceXPlayer.getJob2()

		if sourceJob2.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)

			targetXPlayer.setJob2(sourceJob2.name, 0)
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("you_hired"):format(targetXPlayer.name))
			TriggerClientEvent("esx:showNotification", target, _U("you_hired_by"):format(sourceXPlayer.name))
		end
	end)
)

RegisterServerEvent("bpt_menu:Boss_fireplayer2")
AddEventHandler(
	"bpt_menu:Boss_fireplayer2",
	makeTargetedEventFunction(function(target)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local sourceJob2 = sourceXPlayer.getJob2()

		if sourceJob2.grade_name == "boss" then
			local targetXPlayer = ESX.GetPlayerFromId(target)
			local targetJob2 = targetXPlayer.getJob2()

			if sourceJob2.name == targetJob2.name then
				targetXPlayer.setJob2("unemployed2", 0)
				TriggerClientEvent(
					"esx:showNotification",
					sourceXPlayer.source,
					_U("you_fired"):format(targetXPlayer.name)
				)
				TriggerClientEvent("esx:showNotification", target, _U("you_were_fired"):format(sourceXPlayer.name))
			else
				TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("player_not_your_company"))
			end
		else
			TriggerClientEvent("esx:showNotification", sourceXPlayer.source, _U("not_permission"))
		end
	end)
)
