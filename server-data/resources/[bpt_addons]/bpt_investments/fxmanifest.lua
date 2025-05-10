fx_version("cerulean")
lua54("yes")
game("gta5")

author("bitpredator")
description("Sistema Investimenti in Borsa per ESX + ox_lib + ox_target")
version("1.0.9")

client_scripts({
    "client/*.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
})

shared_scripts({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "@ox_target/init.lua",
})

dependencies({
    "ox_lib",
    "ox_target",
    "es_extended",
})