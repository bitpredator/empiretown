fx_version("adamant")

game("gta5")
author("bitpredator")
description("bitpredator HUD")
version("1.0.8")

ui_page("html/ui.html")

shared_script("@es_extended/imports.lua")

files({
    "html/*.js",
})

client_scripts({
    "client/*.lua",
    "config.lua",
})
