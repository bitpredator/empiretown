fx_version("adamant")

game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_GAMEDATA")("audioconfig/strchrgrgen2_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/strchrgrgen2_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_strchrgrgen2")
