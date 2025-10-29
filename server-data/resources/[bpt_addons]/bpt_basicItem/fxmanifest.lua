fx_version("cerulean")
game("gta5")

description("fivem basic Item")
author("bitpredator")
version("2.0.1")
lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "client/*.lua",
    "config.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
    "config.lua",
})

dependency({
    "bpt_idcard",
    "ox_inventory",
})
