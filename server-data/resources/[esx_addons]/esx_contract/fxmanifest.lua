fx_version("adamant")

game("gta5")

description("esx_contract")

version("1.0.8")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/*.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
})
