<h1 align='center'>bpt_vehicletax</a></h1>
<p align='center'><a href='https://discord.gg/Jrm2Z26ad3'>Discord Skull Network Italia</a>

Copyright (C) 2022 - 2025 bitpredator

# Vehicle Tax System for ESX

A fully automated vehicle tax system for ESX framework in FiveM.  
Players pay daily taxes on their owned vehicles based on vehicle categories.

## Features

- Automatic daily tax payment deducted from player's bank account.
- Tax rates configurable per vehicle category in `config.lua`.
- Taxes collected go directly to the `society_government` account.
- Retrieves vehicle data directly from the database (`owned_vehicles` table).
- Multilanguage support for notifications.
- Efficient periodic checks and tax application on the server side.

## Installation

1. Place the resource in your `resources` folder.
2. Add it to your `server.cfg`:
3. Configure `config.lua` to set tax rates, interval, and locale.
4. Make sure you have `es_extended` and `bpt_addonaccount` (or your addon account system) installed.

## Configuration

Edit the `config.lua` file to customize:

- Tax rates by vehicle category.
- Payment interval (default 86400 seconds = 24 hours).
- Language locale for messages.

## Usage

The system automatically charges players once per day for all owned vehicles.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Support

If you find any issues or want to contribute, feel free to open an issue or pull request on GitHub.
