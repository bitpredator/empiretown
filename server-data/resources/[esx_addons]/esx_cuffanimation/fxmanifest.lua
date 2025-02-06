fx_version("adamant")

game("gta5")

description("esx_cuffanimation")
lua54("yes")
version("1.0.8")

shared_script '@es_extended/imports.lua'

server_scripts({
    "config.lua",
    "server/main.lua",
})

client_scripts({
    "config.lua",
    "client/main.lua",
})
