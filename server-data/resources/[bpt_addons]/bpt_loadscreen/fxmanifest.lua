fx_version("cerulean")
games({ "gta5" })

author("Bitpredator")
description("fivem loadscreen")
version("2.0.0")

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
    "video.mp4",
})
