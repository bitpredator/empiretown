fx_version("cerulean")
game("gta5")

author("bitpredator")
description("BPT Inactive Job Removal")
version("1.0.9")
lua54("yes")

shared_scripts({
    "@ox_lib/init.lua",
    "@es_extended/imports.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/inactive_job_removal.lua",
})

dependencies({
    "es_extended",
    "oxmysql",
})
