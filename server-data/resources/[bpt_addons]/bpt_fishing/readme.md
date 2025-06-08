# 🎣 bpt_fishing System for FiveM

A lightweight and fully configurable fishing activity script for ESX-based FiveM servers.  
Built with `ox_inventory` and `ox_target` support for an immersive and user-friendly experience.

---

## 📦 Features

- ✅ Requires **fishing rod** and **bait** (customizable items)
- 🌊 Players can fish at **designated fishing zones**
- 📍 **Blips** shown on the map to locate fishing areas
- 🐟 Fishable items: `tuna`, `salmon`, `trout`, `anchovy`, and `plastic_bag`
- 🎯 Success chance varies by water density (low / medium / high)
- 🌐 **Multilingual support** (`locales/en.lua`, `locales/it.lua`, etc.)
- 🧱 Configurable via `config.lua`

---

## 📁 Dependencies

- [ESX](https://github.com/esx-framework/esx-legacy)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)

---

## 🛠️ Installation

1. Download or clone this repository into your `resources` folder.
2. Add to your `server.cfg`:

   ```cfg
   ensure fishing

['fishing_rod'] = {
    label = 'Fishing Rod',
    weight = 500,
    stack = false,
    close = true,
    description = 'A sturdy fishing rod.'
},
['bait'] = {
    label = 'Bait',
    weight = 100,
    stack = true,
    close = true,
    description = 'Bait to attract fish.'
},
['tuna'] = { label = 'Tuna', weight = 800 },
['salmon'] = { label = 'Salmon', weight = 700 },
['trout'] = { label = 'Trout', weight = 600 },
['anchovy'] = { label = 'Anchovy', weight = 400 },
['plastic_bag'] = { label = 'Plastic Bag', weight = 200 },
