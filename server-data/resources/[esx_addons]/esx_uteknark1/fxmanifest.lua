fx_version("adamant")
game("gta5")
lua54("yes")
version("1.0.1")
description("ESX UteKnark by DemmyDemon - bitpredator rebuild")

dependencies({
    "es_extended",
    "mysql-async",
})

shared_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "lib/*.lua",
    "@es_extended/imports.lua",
})

client_scripts({
    "lib/debug.lua",
    "cl_uteknark.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "sv_uteknark.lua",
})
