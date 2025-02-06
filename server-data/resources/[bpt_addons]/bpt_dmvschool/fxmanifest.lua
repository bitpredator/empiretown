fx_version("adamant")

game("gta5")

description("A DMV School for players to get their drivers license")

version("1.0.8")

lua54("yes")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/main.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/main.lua",
})

ui_page("html/ui_it.html")

files({
    "html/ui_it.html",
    "html/dmv.png",
    "html/styles.css",
    "html/questions_it.js",
    "html/scripts.js",
    "html/debounce.min.js",
})

dependencies({
    "es_extended",
    "esx_license",
})
