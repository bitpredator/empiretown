fx_version("adamant")
game("gta5")
author("qalle-git; rework by: bitpredator")
lua54("yes")
version("1.0.8")
description("Jail Script With Working Job")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@es_extended/locale.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "locales/*.lua",
    "server/server.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "config.lua",
    "client/*.lua",
    "locales/*.lua",
})
