fx_version("cerulean")
game("gta5")

author("Bitpredator")
description("Sistema di vendita illecita tramite ped (weed, emerald) con bonus polizia")
version("2.0.0")

lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "shared/config.lua",
})

client_scripts({
    "@ox_target/export.lua",
    "client/*.lua",
})

server_scripts({
    "@es_extended/imports.lua",
    "server/*.lua",
})

dependencies({
    "es_extended",
    "ox_target",
    "ox_lib",
})
