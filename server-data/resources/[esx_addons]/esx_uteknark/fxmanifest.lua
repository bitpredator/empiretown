fx_version("adamant")
game("gta5")
lua54("yes")
description("ESX UteKnark by DemmyDemon")

dependencies({ "es_extended", "oxmysql" })

shared_scripts({
    "@es_extended/locale.lua",
    "@es_extended/imports.lua",
    "locales/*.lua",
    "config.lua",
    "lib/octree.lua",
    "lib/growth.lua",
    "lib/cropstate.lua",
})
client_scripts({
    "lib/debug.lua",
    "cl_uteknark.lua",
})
server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "sv_uteknark.lua",
})
