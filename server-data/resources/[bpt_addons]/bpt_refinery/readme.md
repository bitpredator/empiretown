# 🔥 BPTNetwork - Refinery Job Script

A fully-featured **stone refinery job** for ESX-based FiveM servers. Process stones and obtain rare materials over time. Optimized for `ox_target`, `ox_lib`, and `ox_inventory`.

## ✨ Features

- NPC with target interaction (ox_target)
- Start refinery process with stone + bank money
- Delayed reward system (24h)
- Randomized rare item generation with configurable chances
- Pickup system with time check
- Fully configurable via `config.lua`
- Translatable with `@es_extended/locale.lua`

## 🛠️ Requirements

- ESX
- `ox_target`
- `ox_lib`
- `ox_inventory`
- MySQL (oxmysql or equivalent)

## 📦 Installation

1. Clone or download this repository
2. Add to your `server.cfg`:
   ```cfg
   ensure bpt_refinery
