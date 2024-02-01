fx_version("cerulean")
game("gta5")

name("LItemBasic")
description("fivem resource")
author("LQuatre")
version("1.0.0")
lua54("yes")

shared_scripts({
    "shared/*.lua",
    "@es_extended/imports.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "client/*.lua",
    "locales/*.lua",
    "shared/*.lua",
    "config.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
    "locales/*.lua",
    "shared/*.lua",
    "config.lua",
})

dependency("jsfour-idcard")
