local bluePlayerReady = false
local redPlayerReady = false
local fight = {}

ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("bpt_streetfight:join", function(betAmount, side)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if side == 0 then
		bluePlayerReady = true
	else
		redPlayerReady = true
	end

	local fighter = {
		id = source,
		amount = betAmount,
	}
	table.insert(fight, fighter)

	local balance = xPlayer.getAccount("money").money
	if (balance > betAmount) or betAmount == 0 then
		xPlayer.removeAccountMoney("money", betAmount)
		TriggerClientEvent("esx:showNotification", source, _U("successfully_signed"))
		if side == 0 then
			TriggerClientEvent("bpt_streetfight:playerJoined", -1, 1, source)
		else
			TriggerClientEvent("bpt_streetfight:playerJoined", -1, 2, source)
		end

		if redPlayerReady and bluePlayerReady then
			TriggerClientEvent("bpt_streetfight:startFight", -1, fight)
		end
	else
		TriggerClientEvent("esx:showNotification", source, _U("not_money"))
	end
end)

local count = 240
local _ = 0
function countdown(copyFight)
	for i = count, 0, -1 do
		_ = i
		Wait(1000)
	end

	if copyFight == fight then
		TriggerClientEvent("bpt_streetfight:fightFinished", -1, -2)
		fight = {}
		bluePlayerReady = false
		redPlayerReady = false
	end
end

RegisterServerEvent("bpt_streetfight:finishFight", function(looser)
	TriggerClientEvent("bpt_streetfight:fightFinished", -1, looser)
	fight = {}
	bluePlayerReady = false
	redPlayerReady = false
end)

RegisterServerEvent("bpt_streetfight:leaveFight", function(id)
	if bluePlayerReady or redPlayerReady then
		bluePlayerReady = false
		redPlayerReady = false
		fight = {}
		TriggerClientEvent("bpt_streetfight:playerLeaveFight", -1, id)
	end
end)

RegisterServerEvent("bpt_streetfight:pay", function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney("money", amount * 2)
end)

RegisterServerEvent("bpt_streetfight:raiseBet", function()
	TriggerClientEvent("bpt_streetfight:raiseActualBet", -1)
end)

RegisterServerEvent("bpt_streetfight:showWinner", function(id)
	TriggerClientEvent("bpt_streetfight:winnerText", -1, id)
end)
