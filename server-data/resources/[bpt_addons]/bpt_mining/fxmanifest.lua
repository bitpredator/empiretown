fx_version("cerulean")
game("gta5")

description("EmpireTown - Lavoro da Minatore")
author("bitpredator")
version("2.0.0")

lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
})

client_scripts({
    "config.lua",
    "client/client.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/server.lua",
})

dependencies({
    "ox_target",
    "ox_lib",
    "ox_inventory",
    "es_extended",
})
