fx_version("bodacious")
game("gta5")

description("Radial Progress")

author("Karl Saunders")

version("1.0.8")

client_scripts({
	"config.lua",
	"utils.lua",
	"client.lua",
})

ui_page("ui/ui.html")

files({
	"ui/ui.html",
	"ui/fonts/*.ttf",
	"ui/css/*.css",
	"ui/js/*.js",
})

exports({
	"Start",
	"Custom",
	"Stop",
	"Static",
	"Linear",
	"MiniGame",
})
