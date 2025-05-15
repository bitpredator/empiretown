fx_version("cerulean")
game("gta5")

description("EmpireTown - Lavoro da Minatore")
author("bitpredator")
version("2.0.0")

dependencies({
    "ox_target",
    "ox_inventory",
    "es_extended",
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

shared_script("@es_extended/imports.lua")
