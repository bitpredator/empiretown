# bpt_wallet

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
