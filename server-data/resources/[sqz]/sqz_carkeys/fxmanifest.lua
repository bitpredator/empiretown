game("gta5")
fx_version("cerulean")

author("Squizer#3020")
description("Script that allows you to lock vehicles.")
version("1.0.8")

shared_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "@es_extended/imports.lua",
    "config.lua",
})

client_scripts({
    "client/client.lua",
    "locales/*.lua",
})
server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/server.lua",
})
