fx_version 'adamant'
author 'bitpredator'
game 'gta5'

description 'bpt_cars'
lua54 'yes'
version '0.0.4'

files {
-- p911r
  'data/p911r/*.meta',
}

-- p911r
data_file 'DLCTEXT_FILE' 'data/p911r/dlctext.meta' 
data_file 'HANDLING_FILE' 'data/p911r/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/p911r/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/p911r/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/p911r/carvariations.meta'


client_script {
    'vehicle_names.lua'    -- Not Required, but you might as well add the cars to it (USE GAMENAME not ModelName)
}