fx_version("cerulean")
game("gta5")

description("Script di pesca ricreativo - ESX + ox_inventory")
author("BPTNetwork")
version("1.0.0")

-- File script
client_scripts({
    "config.lua",
    "client/*.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/*.lua",
})

shared_script({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
})

dependencies({
    "es_extended",
    "ox_inventory",
})
