fx_version("cerulean")
game("gta5")

description("Cool Radio for ESX, Coverted By Mycroft & Benzo")
version("1.0.8")
lua54("yes")

shared_scripts({
    "@es_extended/imports.lua",
    "config.lua",
})

server_script("server.lua")

client_scripts({ "client.lua" })

ui_page("html/ui.html")

files({
    "html/ui.html",
    "html/js/script.js",
    "html/css/style.css",
    "html/img/radio.png",
})
