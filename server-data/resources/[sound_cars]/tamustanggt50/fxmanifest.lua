fx_version("adamant")

game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_GAMEDATA")("audioconfig/tamustanggt50_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/tamustanggt50_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_tamustanggt50")
data_file("AUDIO_GAMEDATA")("audioconfig/tascmustanggt50_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/tascmustanggt50_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_tascmustanggt50")
