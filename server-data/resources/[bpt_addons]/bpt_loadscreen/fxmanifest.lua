fx_version("cerulean")
game("gta5")

author("Bitpredator")
description("Custom Loadscreen")
version("2.0.0")

loadscreen("index.html")
loadscreen_manual_shutdown("yes")
loadscreen_cursor("yes")

files({
    "index.html",
    "style.css",
    "script.js",
    "video.mp4",
    "intro.mp3",
})

client_script("client/*.lua")
