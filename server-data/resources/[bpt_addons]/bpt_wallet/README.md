<h1 align='center'>bpt_wallet</a></h1>
<p align='center'><a href='https://discord.gg/ksGfNvDEfq'>Discord</a>

Copyright (C) 2022-2025 bitpredator

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

ATTENTION:
You are not authorized to change the name of the resource and the resources within it.

If you want to contribute you can open a pull request.

You are not authorized to sell this software (this is free project).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

This asset was created as a free wallet script using ox_inventory

## Installation

- Download this script
- Add wallet to inventory as it is in "Extra Information" below
- Put script in your `resources` directory
- ensure `bpt_wallet` *after* `ox_lib` but *before* `ox_inventory`

# Dependencies
 - ox_inventory

## Extra Information
Item to add to `ox_inventory/data/items.lua`
```
	['wallet'] = {
		label = 'Wallet',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'bpt_wallet.openWallet'
		}
	},
```