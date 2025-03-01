fx_version("adamant")
game("gta5")
description("bpt_farmer, introduces various collection points for the crafting system (not a job)")
author("bitpredator")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_script({
    "@es_extended/locale.lua",
    "client/*.lua",
    "locales/*.lua",
    "config.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "server/*.lua",
    "@oxmysql/lib/MySQL.lua",
    "locales/*.lua",
    "config.lua",
})
