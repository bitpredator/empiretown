fx_version("cerulean")
game("gta5")

author("Bitpredator")
description("Automatic taxation system for vehicles")
version("2.0.0")

server_script({
    "@es_extended/locale.lua",
    "@es_extended/imports.lua",
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "locales/*.lua",
    "server/*.lua",
})
