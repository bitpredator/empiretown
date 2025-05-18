fx_version("cerulean")
game("gta5")

author("bitpredator")
description("Sistema di Fonderia - EmpireTown")
version("2.0.0")

shared_script({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
})

client_scripts({
    "client./*lua",
})

lua54("yes")
