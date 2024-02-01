fx_version("cerulean")
game("gta5")

author("Squizer#3020")
description("Script that allows you to borrow vehicles.")
version("1.0.0")

shared_script("@es_extended/imports.lua")

client_scripts({
    "warmenu.lua",
    "config.lua",
    "client.lua",
})

server_scripts({
    "config.lua",
    "server.lua",
})
