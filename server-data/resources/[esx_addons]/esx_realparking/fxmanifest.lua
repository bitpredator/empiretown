fx_version("adamant")
game("gta5")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "config.lua",
    "locales/*.lua",
    "client/main.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "@es_extended/locale.lua",
    "config.lua",
    "locales/*.lua",
    "server/main.lua",
})
