fx_version("cerulean")
game("gta5")
lua54("yes")
author("bitpredator")
description("BPT Wallet for ox_inventory")
version("2.0.0")

client_scripts({
    "client/*.lua",
})

server_scripts({
    "server/*.lua",
})

shared_scripts({
    "@ox_lib/init.lua",
    "config.lua",
})

dependency({
    "ox_lib",
    "ox_inventory",
})
