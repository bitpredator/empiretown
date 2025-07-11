fx_version("cerulean")
game("gta5")

author("BPTNetwork")
description("Cuff Animation for ESX by BPTNetwork")
version("2.0.0")

shared_script("@es_extended/imports.lua")

server_scripts({
    "config.lua",
    "server/main.lua",
})

client_scripts({
    "config.lua",
    "client/main.lua",
})
