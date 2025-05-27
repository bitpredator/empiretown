# 🔥 Illegal Item Selling System (FiveM - ESX + ox_target + ox_lib)

This script allows players to sell specific illegal items (e.g., `weed`, `emerald`) to a PED using `ox_target`. It includes a payment system in `black_money`, with a dynamic bonus based on the number of online police players.

## 💡 Features

- 🔫 Sell items to a specific PED using ox_target
- 💰 Receive payment in black_money
- 📈 Bonus calculated based on active police presence
- 📦 Fully configurable item list and base prices
- 🧠 Uses ESX, ox_target, and ox_lib (for notifications, dialogs, etc.)

## 📂 File Structure

- `client.lua`: Handles PED creation and interaction
- `server.lua`: Handles item validation, payment, and bonus logic
- `shared/config.lua`: Configuration for item prices and police jobs
- `fxmanifest.lua`: Dependency management and resource metadata

## ⚙️ Requirements

- [es_extended](https://github.com/esx-framework/es_extended)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_lib](https://github.com/overextended/ox_lib)

## 🚀 Installation

1. Clone or download this repository
2. Place it in your `resources/[local]` folder
3. Add `ensure your_resource_name` to your `server.cfg`
4. Adjust item names and prices in `shared/config.lua` to fit your server's economy

## 🛠️ Configuration Example

```lua
Config.SellItems = {
    weed = {price = 250},
    emerald = {price = 500}
}

Config.PoliceJobs = {'police', 'sheriff'}
Config.PoliceBonusPerUnit = 0.10 -- 10% extra per online police officer
