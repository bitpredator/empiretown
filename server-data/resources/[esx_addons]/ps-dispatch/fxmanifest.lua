fx_version("cerulean")
game("gta5")

version("1.0.8")
description("https://github.com/Project-Sloth/ps-dispatch")

shared_scripts({
    "config.lua",
    "locales/locales.lua",
})

client_scripts({
    "client/*.lua",
})

server_script({
    "server/*.lua",
})

ui_page("ui/index.html")

files({
    "ui/index.html",
    "ui/app.js",
    "ui/style.css",
})
