fx_version("adamant")
game("gta5")
description("bpt_cars - pack addon car")
author("bitpredator")
lua54("yes")
version("1.0.8")

files({
    -- bmw440
    "data/bmw440/handling.meta",
    "data/bmw440/vehicles.meta",
    "data/bmw440/carcols.meta",
    "data/bmw440/carvariations.meta",

    -- bmwm3e92
    "data/bmwm3e92/handling.meta",
    "data/bmwm3e92/vehicles.meta",
    "data/bmwm3e92/carcols.meta",
    "data/bmwm3e92/carvariations.meta",

    -- SkylineGT-R
    "data/SkylineGT-R/handling.meta",
    "data/SkylineGT-R/vehicles.meta",
    "data/SkylineGT-R/carcols.meta",
    "data/SkylineGT-R/carvariations.meta",

    -- mads14
    "data/mads14/handling.meta",
    "data/mads14/vehicles.meta",
    "data/mads14/carvariations.meta",

    -- Tmax500
    "data/Tmax500/handling.meta",
    "data/Tmax500/vehicles.meta",
    "data/Tmax500/carcols.meta",
    "data/Tmax500/carvariations.meta",

    -- Mercedes-BenzSLS
    "data/Mercedes-BenzSLS/handling.meta",
    "data/Mercedes-BenzSLS/vehicles.meta",
    "data/Mercedes-BenzSLS/carcols.meta",
    "data/Mercedes-BenzSLS/carvariations.meta",

    -- Ford-Mustang-mgt
    "data/Ford-Mustang-mgt/handling.meta",
    "data/Ford-Mustang-mgt/vehicles.meta",
    "data/Ford-Mustang-mgt/carcols.meta",
    "data/Ford-Mustang-mgt/carvariations.meta",
    "data/Ford-Mustang-mgt/dlctext.meta",

    -- stockade4
    "data/stockade4/handling.meta",
    "data/stockade4/vehicles.meta",
    "data/stockade4/carvariations.meta",

    -- KTM690
    "data/KTM690/handling.meta",
    "data/KTM690/vehicles.meta",
    "data/KTM690/carcols.meta",
    "data/KTM690/carvariations.meta",
    "data/KTM690/dlctext.meta",

    -- 69 charger
    "data/charger/handling.meta",
    "data/charger/vehicles.meta",
    "data/charger/carcols.meta",
    "data/charger/carvariations.meta",
    "data/charger/dlctext.meta",

})

-- bmw440
data_file("HANDLING_FILE")("data/bmw440/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/bmw440/vehicles.meta")
data_file("CARCOLS_FILE")("data/bmw440/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/bmw440/carvariations.meta")

-- bmwm3e92
data_file("HANDLING_FILE")("data/bmwm3e92/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/bmwm3e92/vehicles.meta")
data_file("CARCOLS_FILE")("data/bmwm3e92/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/bmwm3e92/carvariations.meta")

-- SkylineGT-R
data_file("HANDLING_FILE")("data/SkylineGT-R/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/SkylineGT-R/vehicles.meta")
data_file("CARCOLS_FILE")("data/SkylineGT-R/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/SkylineGT-R/carvariations.meta")

-- mads14
data_file("HANDLING_FILE")("data/mads14/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/mads14/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/mads14/carvariations.meta")

-- Tmax500
data_file("HANDLING_FILE")("data/Tmax500/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/Tmax500/vehicles.meta")
data_file("CARCOLS_FILE")("data/Tmax500/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/Tmax500/carvariations.meta")

-- Mercedes-BenzSLS
data_file("HANDLING_FILE")("data/Mercedes-BenzSLS/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/Mercedes-BenzSLS/vehicles.meta")
data_file("CARCOLS_FILE")("data/Mercedes-BenzSLS/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/Mercedes-BenzSLS/carvariations.meta")

-- Ford-Mustang-mgt
data_file("HANDLING_FILE")("data/Ford-Mustang-mgt/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/Ford-Mustang-mgt/vehicles.meta")
data_file("CARCOLS_FILE")("data/Ford-Mustang-mgt/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/Ford-Mustang-mgt/carvariations.meta")
data_file("DLCTEXT_FILE")("data/Ford-Mustang-mgt/dlctext.meta")

-- stockade4
data_file("HANDLING_FILE")("data/stockade4/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/stockade4/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/stockade4/carvariations.meta")

-- KTM690
data_file("HANDLING_FILE")("data/KTM690/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/KTM690/vehicles.meta")
data_file("CARCOLS_FILE")("data/KTM690/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/KTM690/carvariations.meta")
data_file("DLCTEXT_FILE")("data/KTM690/dlctext.meta")

-- charger 
data_file("HANDLING_FILE")("data/charger/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/charger/vehicles.meta")
data_file("CARCOLS_FILE")("data/charger/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/charger/carvariations.meta")
data_file("DLCTEXT_FILE")("data/charger/dlctext.meta")

client_script({
    "vehicle_names.lua",
})
