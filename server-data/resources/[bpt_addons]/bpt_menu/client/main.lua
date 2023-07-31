local plyPed
local RenderWalletMenu

local PersonalMenu = {
	ItemSelected = {},
	ItemIndex = {},
	WalletIndex = {},
	WalletList = {},
	BillData = {},
	DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
}

Player = {
	isDead = false,
	inAnim = false,
	crouched = false,
	handsup = false,
	pointing = false,
	noclip = false,
	godmode = false,
	ghostmode = false,
	showCoords = false,
	showName = false,
	gamerTags = {},
	group = 'user'
}

CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	RMenu.Add('rageui', 'personal', RageUI.CreateMenu(Config.MenuTitle, _U('mainmenu_subtitle'), 0, 0, 'commonmenu', 'interaction_bgd', 255, 255, 255, 255))
	RMenu.Add('personal', 'billing', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bills_title')))
	RMenu.Add('personal', 'admin', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('admin_title')), function()
		if Player.group ~= nil and (Player.group == 'mod' or Player.group == 'admin') then
			return true
		end

		return false
	end)

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('esx:onPlayerDeath', function()
	Player.isDead = true
	RageUI.CloseAll()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	Player.isDead = false
end)

-- Admin Menu --
RegisterNetEvent('bpt_menu:Admin_BringC')
AddEventHandler('bpt_menu:Admin_BringC', function(plyCoords)
	SetEntityCoords(plyPed, plyCoords)
end)

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.03)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500)
		return result
	else
		Wait(500)
		return nil
	end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function RenderPersonalMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #RMenu['personal'], 1 do
			local buttonLabel = RMenu['personal'][i].ButtonLabel or RMenu['personal'][i].Menu.Title

			if type(RMenu['personal'][i].Restriction) == 'function' then
				if RMenu['personal'][i].Restriction() then
					RageUI.Button(buttonLabel, nil, {RightLabel = "→→→"}, true, function() end, RMenu['personal'][i].Menu)
				else
					RageUI.Button(buttonLabel, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function() end, RMenu['personal'][i].Menu)
				end
			else
				RageUI.Button(buttonLabel, nil, {RightLabel = "→→→"}, true, function() end, RMenu['personal'][i].Menu)
			end
		end
	end)
end

function RenderBillingMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.BillData, 1 do
			RageUI.Button(PersonalMenu.BillData[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(PersonalMenu.BillData[i].amount)}, true, function(_, _, Selected)
				if (Selected) then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						ESX.TriggerServerCallback('bpt_menu:Bill_getBills', function(bills) PersonalMenu.BillData = bills end)
					end, PersonalMenu.BillData[i].id)
				end
			end)
		end
	end)
end

function RenderAdminMenu()
	RageUI.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #Config.Admin, 1 do
			local authorized = false

			for j = 1, #Config.Admin[i].groups, 1 do
				if Config.Admin[i].groups[j] == Player.group then
					authorized = true
				end
			end

			if authorized then
				RageUI.Button(Config.Admin[i].label, nil, {}, true, function(_, _, Selected)
					if (Selected) then
						Config.Admin[i].command()
					end
				end)
			else
				RageUI.Button(Config.Admin[i].label, nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function() end)
			end
		end
	end)
end

CreateThread(function()
	while true do
		Wait(0)

		if IsControlJustReleased(0, Config.Controls.OpenMenu.keyboard) and not Player.isDead then
			if not RageUI.Visible() then
				ESX.TriggerServerCallback('bpt_menu:Admin_getUsergroup', function(plyGroup)
					Player.group = plyGroup

					ESX.TriggerServerCallback('bpt_menu:Bill_getBills', function(bills)
						PersonalMenu.BillData = bills
						ESX.PlayerData = ESX.GetPlayerData()
						RageUI.Visible(RMenu.Get('rageui', 'personal'), true)
					end)
				end)
			end
		end

		if RageUI.Visible(RMenu.Get('rageui', 'personal')) then
			RenderPersonalMenu()
		end


		if RageUI.Visible(RMenu.Get('personal', 'wallet')) then
			RenderWalletMenu()
		end

		if RageUI.Visible(RMenu.Get('personal', 'billing')) then
			RenderBillingMenu()
		end

		if RageUI.Visible(RMenu.Get('personal', 'admin')) then
			if not RMenu.Settings('personal', 'admin', 'Restriction')() then
				RageUI.GoBack()
			end
			RenderAdminMenu()
		end
	end
end)

CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if IsControlJustReleased(0, Config.Controls.StopTasks.keyboard) and IsInputDisabled(2) and not Player.isDead then
			Player.handsup, Player.pointing = false, false
			ClearPedTasks(plyPed)
		end

		if Player.showCoords then
			local plyCoords = GetEntityCoords(plyPed, false)
			Text('~r~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. '\n~b~Y~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. '\n~y~Angle~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
		end

		if Player.noclip then
			local plyCoords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (Config.NoclipSpeed * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (Config.NoclipSpeed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
		end

		Wait(0)
	end
end)

CreateThread(function()
	while true do
		if Player.showName then
			for _, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
						Player.gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(Player.gamerTags[v])
						Player.gamerTags[v] = nil
					end
				end
			end
		end

		Wait(100)
	end
end)
