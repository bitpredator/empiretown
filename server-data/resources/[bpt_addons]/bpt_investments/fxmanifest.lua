fx_version("cerulean")
lua54("yes")
game("gta5")

author("bitpredator")
description("Sistema Investimenti in Borsa per ESX + ox_lib + ox_target")
version("1.0.0")

-- File principali
client_scripts({
    "@ox_lib/init.lua",
    "client/*.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua", -- solo se interagisci con DB
    "server/*.lua",
})

shared_scripts({
    "@es_extended/imports.lua",
})
