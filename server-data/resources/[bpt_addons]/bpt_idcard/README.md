<h1 align='center'>bpt_idcard</a></h1>
<p align='center'><a href='https://discord.gg/Jrm2Z26ad3'>Discord Skull Network Italia</a>

Copyright (C) 2024 - 2025 bitpredator

## SCREENSHOTS
![screenshot](https://i.gyazo.com/645a490f474296a9c5ce2a05a16a33c9.png)
![screenshot](https://i.gyazo.com/f4c14b2efe6f0ff8c88098a4a524e8be.png)
![screenshot](https://i.gyazo.com/0aaeaa5b78cd2bef98ee9185bc5295c8.png)

## USAGE

Example on how to add a button-event since people don't want to learn:
https://pastebin.com/UPQRcAei

```lua
-- ### Event usages:

-- Look at your own ID-card
TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))

-- Show your ID-card to the closest person
local player, distance = ESX.Game.GetClosestPlayer()

if distance ~= -1 and distance <= 3.0 then
  TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
else
  ESX.ShowNotification('No players nearby')
end


-- Look at your own driver license
TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')

-- Show your driver license to the closest person
local player, distance = ESX.Game.GetClosestPlayer()

if distance ~= -1 and distance <= 3.0 then
  TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
else
  ESX.ShowNotification('No players nearby')
end


-- Look at your own firearms license
TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')

-- Show your firearms license to the closest person
local player, distance = ESX.Game.GetClosestPlayer()

if distance ~= -1 and distance <= 3.0 then
  TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
else
  ESX.ShowNotification('No players nearby')
end

-- ### A menu (THIS IS AN EXAMPLE)
function openMenu()
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'id_card_menu',
	{
		title    = 'ID menu',
		elements = {
			{label = 'Check your ID', value = 'checkID'},
			{label = 'Show your ID', value = 'showID'},
			{label = 'Check your driver license', value = 'checkDriver'},
			{label = 'Show your driver license', value = 'showDriver'},
			{label = 'Check your firearms license', value = 'checkFirearms'},
			{label = 'Show your firearms license', value = 'showFirearms'},
		}
	},
	function(data, menu)
		local val = data.current.value
		
		if val == 'checkID' then
			TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		elseif val == 'checkDriver' then
			TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		elseif val == 'checkFirearms' then
			TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
		else
			local player, distance = ESX.Game.GetClosestPlayer()
			
			if distance ~= -1 and distance <= 3.0 then
				if val == 'showID' then
				TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
				elseif val == 'showDriver' then
			TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
				elseif val == 'showFirearms' then
			TriggerServerEvent('bpt_idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
				end
			else
			  TriggerClientEvent("esx:showNotification", _source, TranslateCap("no_license_type"))
			end
		end
	end,
	function(data, menu)
		menu.close()
	end
)
end
```

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

ATTENTION:
You are not authorized to change the name of the resource and the resources within it.

If you want to contribute you can open a pull request.

You are not authorized to sell this software (this is free project).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.