fx_version("cerulean")
game("gta5")

author("Squizer - refactor by: bitpredator")
description("Script that allows you to borrow vehicles.")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_scripts({
    "warmenu.lua",
    "config.lua",
    "client.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
})

server_scripts({
    "config.lua",
    "server.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
})
