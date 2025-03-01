fx_version("cerulean")
games({ "gta5" })

author("Bitpredator")
description("fivem loadscreen")
version("1.0.8")

loadscreen("index.html")
loadscreen_manual_shutdown("yes")
client_script("client.lua")
server_script("server.lua")
loadscreen_cursor("yes")

files({
    "index.html",
    "css/style.css",
    "script/main.js",
    "song/*",
    "img/*",
})
