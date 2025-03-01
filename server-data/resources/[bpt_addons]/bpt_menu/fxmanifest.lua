fx_version("cerulean")
game("gta5")

lua54("yes")

author("bitpredator")
description("Roleplay personal menu supporting ESX")
version("1.0.8")

shared_scripts({
    "locale.lua",
    "locales/*.lua",
    "config.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua",
})

client_scripts({
    "dependencies/menu/RageUI.lua",
    "dependencies/menu/Menu.lua",
    "dependencies/menu/MenuController.lua",
    "dependencies/menu/elements/*.lua",
    "dependencies/menu/items/*.lua",
    "client/*.lua",
})

dependency("es_extended")
