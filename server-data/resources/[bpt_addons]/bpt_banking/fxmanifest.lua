fx_version("cerulean")

game("gta5")

description("A banking system that adds interactable banks and ATMs")
lua54("yes")
version("2.0.0")

shared_scripts({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
})

client_scripts({
    "client/main.lua",
})

ui_page("html/ui.html")

files({
    "html/**",
})

dependency("es_extended")
