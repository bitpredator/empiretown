fx_version("adamant")
game("gta5")
description("Provides a way for players to RP as paramedics (heal/revive players)")
version("2.0.0")
lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
})

client_scripts({
    "client/*.lua",
})

dependencies({
    "es_extended",
    "esx_vehicleshop",
})
