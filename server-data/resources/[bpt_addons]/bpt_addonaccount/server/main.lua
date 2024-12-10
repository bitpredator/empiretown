---@diagnostic disable: undefined-global

local AccountsIndex, Accounts, SharedAccounts = {}, {}, {}

AddEventHandler("onResourceStart", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local accounts = MySQL.query.await(
			'SELECT * FROM addon_account LEFT JOIN addon_account_data ON addon_account.name = addon_account_data.account_name UNION SELECT * FROM addon_account RIGHT JOIN addon_account_data ON addon_account.name = addon_account_data.account_name')

		local newAccounts = {}
		for i = 1, #accounts do
			local account = accounts[i]
			if account.shared == 0 then
				if not Accounts[account.name] then
					AccountsIndex[#AccountsIndex + 1] = account.name
					Accounts[account.name] = {}
				end
				Accounts[account.name][#Accounts[account.name] + 1] = CreateAddonAccount(account.name, account.owner,
					account.money)
			else
				if account.money then
					SharedAccounts[account.name] = CreateAddonAccount(account.name, nil, account.money)
				else
					newAccounts[#newAccounts + 1] = { account.name, 0 }
				end
			end
		end
		GlobalState.SharedAccounts = SharedAccounts

		if next(newAccounts) then
			MySQL.prepare('INSERT INTO addon_account_data (account_name, money) VALUES (?, ?)', newAccounts)
			for i = 1, #newAccounts do
				local newAccount = newAccounts[i]
				SharedAccounts[newAccount[1]] = CreateAddonAccount(newAccount[1], nil, 0)
			end
			GlobalState.SharedAccounts = SharedAccounts
		end
	end
end)

function GetAccount(name, owner)
	for i = 1, #Accounts[name], 1 do
		if Accounts[name][i].owner == owner then
			return Accounts[name][i]
		end
	end
end

function GetSharedAccount(name)
	return SharedAccounts[name]
end

function AddSharedAccount(society, amount)
	-- society.name = job_name/society_name
	-- society.label = label for the job/account
	-- amount = if the shared account should start with x amount
	if type(society) ~= 'table' or not society?.name or not society?.label then return end

	-- check if account already exist?
	if SharedAccounts[society.name] ~= nil then return SharedAccounts[society.name] end

	-- addon account:
	local account = MySQL.insert.await("INSERT INTO `addon_account` (name, label, shared) VALUES (?, ?, ?)", {
		society.name, society.label, 1
	})
	if not account then return end

	-- if addon account inserted, insert addon account data:
	local account_data = MySQL.insert.await("INSERT INTO `addon_account_data` (account_name, money) VALUES (?, ?)", {
		society.name, (amount or 0)
	})
	if not account_data then return end

	-- if all data inserted successfully to sql:
	SharedAccounts[society.name] = CreateAddonAccount(society.name, nil, (amount or 0))

	return SharedAccounts[society.name]
end

AddEventHandler("bpt_addonaccount:getAccount", function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler("bpt_addonaccount:getSharedAccount", function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler("esx:playerLoaded", function(_, xPlayer)
	local addonAccounts = {}

	for i = 1, #AccountsIndex, 1 do
		local name    = AccountsIndex[i]
		local account = GetAccount(name, xPlayer.identifier)

		if account == nil then
			MySQL.insert("INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)",
				{ name, 0, xPlayer.identifier })

			account = CreateAddonAccount(name, xPlayer.identifier, 0)
			Accounts[name][#Accounts[name] + 1] = account
		end

		addonAccounts[#addonAccounts + 1] = account
	end

	xPlayer.set("addonAccounts", addonAccounts)
end)

RegisterNetEvent("bpt_addonaccount:refreshAccounts")
AddEventHandler("bpt_addonaccount:refreshAccounts", function()
	local addonAccounts = MySQL.query.await("SELECT * FROM addon_account")

	for i = 1, #addonAccounts, 1 do
		local name             = addonAccounts[i].name
		local shared           = addonAccounts[i].shared

		local addonAccountData = MySQL.query.await("SELECT * FROM addon_account_data WHERE account_name = ?", { name })

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			for j = 1, #addonAccountData, 1 do
				local addonAccount = CreateAddonAccount(name, addonAccountData[j].owner, addonAccountData[j].money)
				table.insert(Accounts[name], addonAccount)
			end
		else
			local money = nil

			if #addonAccountData == 0 then
				MySQL.insert("INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)",
					{ name, 0, nil })
				money = 0
			else
				money = addonAccountData[1].money
			end

			local addonAccount   = CreateAddonAccount(name, nil, money)
			SharedAccounts[name] = addonAccount
		end
	end
end)

exports("getAccount", GetAccount)

exports("getSharedAccount", GetSharedAccount)
