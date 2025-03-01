fx_version("adamant")
game("gta5")
author("bitpredator")
description("bitpredator HUD")
version("1.0.8")
ui_page("web/build/index.html")

shared_script("shared/config.lua")

client_scripts({
    "client/*.lua",
})

server_scripts({
    -- "@vrp/lib/utils.lua", -- Enable if you are using vRP
    "server/*.lua",
})

files({
    "web/build/index.html",
    "web/build/**/*",
})
