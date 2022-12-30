fx_version 'adamant'

game 'gta5'

description 'bpt_streetfight'

version '0.0.3'

server_script {
    'server.lua',
    'config.lua'
}

client_script {
    'client.lua',
    'config.lua'
}

dependencies {
    'es_extended'
}