fx_version("adamant")
game("gta5")
version("1.0.8")
ui_page("html/index.html")

shared_script("@es_extended/imports.lua")

server_script({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/*.lua",
})

client_script({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
})

files({
    "html/index.html",
    "html/assets/css/*.css",
    "html/assets/js/*.js",
    "html/assets/fonts/roboto/*.woff",
    "html/assets/fonts/roboto/*.woff2",
    "html/assets/fonts/justsignature/JustSignature.woff",
    "html/assets/images/*.png",
})
