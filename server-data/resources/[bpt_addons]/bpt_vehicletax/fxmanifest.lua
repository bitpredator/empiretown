fx_version("adamant")
game("gta5")
description("property tax")
author("bitpredator")
version("1.0.8")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@es_extended/locale.lua",
    "@oxmysql/lib/MySQL.lua",
    "locales/*.lua",
    "server/*.lua",
})
