fx_version 'cerulean'
games { 'gta5' }

shared_script '@es_extended/imports.lua'

client_scripts {
    "@es_extended/locale.lua",
    "config.lua",
    "utils/client.lua",
    "client/*.lua",
}

server_scripts {
    "@es_extended/locale.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "utils/server.lua",
    "server/*.lua",
}

ui_page "html/index.html"

files {
	"html/*.html",
	"html/scripts/*.js",
	"html/css/*.css",
	"html/css/img/*.png",
}