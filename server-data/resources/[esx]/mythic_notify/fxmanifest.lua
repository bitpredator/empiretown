fx_version("adamant")
game("gta5")
name("Mythic Framework Notification System")

version("1.0.1")

ui_page({
    "html/ui.html",
})

files({
    "html/ui.html",
    "html/js/app.js",
    "html/css/style.css",
})

client_scripts({
    "client/main.lua",
})

exports({
    "SendAlert",
    "SendUniqueAlert",
    "PersistentAlert",
})
