# bpt_society

## Installation
- Import `bpt_society.sql` in your database
- Add this in your `server.cfg`:

```
start bpt_society
```

## Explanation
ESX Society works with addon accounts named 'society_xxx', for example 'society_taxi' or 'society_realestateagent'. If you job grade is 'boss' the society money will be displayed in your hud.

## Usage
```lua
local society = 'taxi'
local amount  = 100

TriggerServerEvent('bpt_society:withdrawMoney', society, amount)
TriggerServerEvent('bpt_society:depositMoney', society, amount)
TriggerServerEvent('bpt_society:washMoney', society, amount)


TriggerEvent('bpt_society:openBossMenu', society, function (data, menu)
	menu.close()
end, {wash = false}) -- set custom options, e.g disable washing
```

# Legal
### License
bpt_society - societies for ESX

Copyright (C) 2024-2025 bitpredator

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
