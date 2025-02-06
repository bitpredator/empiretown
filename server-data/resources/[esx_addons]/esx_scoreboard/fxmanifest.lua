fx_version("cerulean")
games({ "gta5" })
version("1.0.8")
ui_page("html/scoreboard.html")

files({
    "html/*",
})

shared_script("@es_extended/imports.lua")

client_scripts({
    "client/main.lua",
})

server_scripts({
    "server/main.lua",
})
