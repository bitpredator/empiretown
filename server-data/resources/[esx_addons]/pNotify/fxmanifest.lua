fx_version("adamant")
game("gta5")
lua54("yes")
version("1.0.7")

ui_page("html/index.html")

client_script("cl_notify.lua")

files({
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
})

export("SetQueueMax")
export("SendNotification")
