fx_version("cerulean")
game("gta5")
version("2.0.0")

description("Woodcutting Script with ESX, ox_inventory, ox_target, ox_lib")
author("Bitpredator")

shared_scripts({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "config.lua",
})

client_scripts({
    "client/*.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
})
