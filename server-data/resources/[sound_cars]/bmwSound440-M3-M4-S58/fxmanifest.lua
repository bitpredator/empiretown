fx_version("cerulean") -- if that doesn't work, try 'adamant' or 'bodacious'

game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_GAMEDATA")("audioconfig/aq70bmws58_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/aq70bmws58_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_aq70bmws58")
