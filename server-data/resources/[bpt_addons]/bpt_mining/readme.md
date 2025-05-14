# EmpireTown - Miner Job ⛏️

This script adds a **fully RP-friendly mining job** for FiveM servers based on **ESX**, with integration for `ox_target` and `ox_inventory`.

## 🔧 Requirements

- **ESX Framework**
- [`ox_target`](https://github.com/overextended/ox_target)
- [`ox_inventory`](https://github.com/overextended/ox_inventory)

## ⚙️ Features

- Mining action triggered via `ox_target` at specific world coordinates
- Realistic jackhammer animation (`WORLD_HUMAN_CONST_DRILL`)
- Configurable random rewards upon mining completion
- Blip on the map to help players locate the mining zone
- Easy-to-edit configuration file (`config.lua`)

## 🎁 Rewardable Items (with drop chance)

| Item       | Drop Chance (%) |
|------------|-----------------|
| stone      | 100             |
| gunpowder  | 20              |
| gold       | 10              |
| steel      | 25              |
| iron       | 40              |
| copper     | 35              |
| diamond    | 5               |
| emerald    | 3               |

## 🚀 Installation

1. Download or clone this repository.
2. Place the folder in your server's `resources/[local]/empire_miner`.
3. Add the following line to your `server.cfg`:
4. Edit `config.lua` as needed to customize mining points and reward chances.

## 🗺️ Mining Zone

The mining area is located near Sandy Shores. A blip icon (pickaxe) is added to help players find it easily.

## ⚠️ Notice

> The jackhammer entity cleanup after mining is **temporarily disabled** due to object sync issues. It will be fixed in a future update.

## ✅ Roadmap (Coming Soon)

- Tool/item requirements to start mining  
- Improved jackhammer visuals  
- Job integration with paychecks or society earnings  
