fx_version("cerulean")
game("gta5")
lua54("yes")

description("Script di negozi da rifornire con vari items.")
author("bitpredator")
version("2.0.1")

shared_scripts({
    "@ox_lib/init.lua",
    "configuration/*.lua",
})

client_scripts({
    "client/*.lua",
})

server_scripts({
    "server/*.lua",
})

dependencies({
    "ox_inventory",
})
