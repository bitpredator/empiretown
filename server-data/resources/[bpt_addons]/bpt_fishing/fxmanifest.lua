fx_version("cerulean")
game("gta5")

author("Bitpredator")
description("Fishing Script Realistico (ESX + ox_inventory)")
version("2.0.0")

lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "@ox_lib/init.lua",
    "config.lua",
    "locales/*.lua",
})

client_scripts({
    "client/*.lua",
})

server_scripts({
    "server/*.lua",
})
