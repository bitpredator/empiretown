fx_version("cerulean")
game("gta5")
lua54("yes")
description("esx-radialmenu")
version("1.0.8")

ui_page("html/index.html")

shared_scripts({
    "@es_extended/imports.lua",
    "config.lua",
})

client_scripts({
    "locales/*.lua",
    "client/*.lua",
})

server_scripts({
    "locales/*.lua",
    "server/*.lua",
})

files({
    "html/index.html",
    "html/css/main.css",
    "html/js/main.js",
    "html/js/RadialMenu.js",
})
