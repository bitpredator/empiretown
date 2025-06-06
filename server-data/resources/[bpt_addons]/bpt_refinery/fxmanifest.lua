fx_version("cerulean")
game("gta5")

author("BPTNetwork")
description("Use the smelter to get rare materials from stone")
version("1.0.0")

shared_script({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "@ox_lib/init.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
})

client_scripts({
    "client/*lua",
})

lua54("yes")
