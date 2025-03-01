fx_version("cerulean")
game("gta5")

author("MEENO")
description("assign or remove the vehicle to a player via chat")

version("1.0.8")
server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
})

shared_scripts({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
})

client_scripts({
    "client/main.lua",
})

dependency({
    "es_extended",
    "esx_vehicleshop",
})
