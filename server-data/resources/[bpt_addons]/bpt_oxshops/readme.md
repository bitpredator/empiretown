# 🛒 BPT Ox Shops

An advanced and secure shop & stash system built for **FiveM ESX** framework using **ox_inventory**. Designed with performance and anti-abuse protections in mind.

## 🔧 Features

- Seamless integration with `ox_inventory`
- Dynamic shop & stash registration via config
- Individual item pricing and metadata support
- Job-restricted stash access
- Blip creation for shop locations
- Built-in server-side anti-exploit protections
- Client-side abuse monitoring
- Full support for ESX 1.9 / Legacy

## 🔐 Anti-Abuse System

This script includes basic anti-abuse protections:

- Server-side validation for `shop`, `price`, and `job` access
- Console alerts for suspicious behavior
- Automatic player kick on exploit attempts
- Client-side checks to prevent unintended event triggers

## 📁 Requirements

- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)
- [es_extended (ESX)](https://github.com/esx-framework/es_extended)
- `oxmysql` for inventory and metadata persistence

## 📂 Installation

1. Clone or download this repository into your `resources` folder.
2. Add this line to your `server.cfg`:


3. Configure your shops inside `config.lua`.

## ⚙️ Configuration

Inside `config.lua`, define shops like this:

```lua
Config.Shops = {
bakery = {
 label = "Bakery",
 locations = {
   shop = {
     coords = vec3(123.4, 456.7, 78.9),
     range = 2.5,
     string = "[E] Open Bakery Shop"
   },
   stash = {
     coords = vec3(120.0, 455.0, 78.9),
     range = 2.5,
     string = "[E] Open Bakery Stash"
   }
 },
 blip = {
   enabled = true,
   coords = vec3(123.4, 456.7, 78.9),
   sprite = 52,
   color = 25,
   scale = 0.8,
   string = "Bakery Shop"
 }
},
-- Add more shops as needed
}
