fx_version("cerulean") -- If that doesn't work, try 'adamant' or 'bodacious' or whatever the latest version is.

game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_GAMEDATA")("audioconfig/aq46forgtebv6_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/aq46forgtebv6_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_aq46forgtebv6")
