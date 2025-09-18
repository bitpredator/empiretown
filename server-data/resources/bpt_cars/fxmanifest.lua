fx_version("adamant")
game("gta5")
description("bpt_cars - pack addon car")
author("bitpredator")
lua54("yes")
version("2.0.0")

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

    -- 69 charger
    "data/charger/handling.meta",
    "data/charger/vehicles.meta",
    "data/charger/carcols.meta",
    "data/charger/carvariations.meta",
    "data/charger/dlctext.meta",

    -- gxa45
    "data/gxa45/handling.meta",
    "data/gxa45/vehicles.meta",
    "data/gxa45/carcols.meta",
    "data/gxa45/carvariations.meta",
    "data/gxa45/dlctext.meta",

    -- f_wide296
    "data/f_wide296/handling.meta",
    "data/f_wide296/vehicles.meta",
    "data/f_wide296/carvariations.meta",
    "data/f_wide296/dlctext.meta",
    "data/f_wide296/vehiclelayouts.meta",

    -- st3
    "data/st3/handling.meta",
    "data/st3/vehicles.meta",
    "data/st3/carcols.meta",
    "data/st3/carvariations.meta",
    "data/st3/dlctext.meta",

    -- porsche911turbos
    "data/porsche911turbos/handling.meta",
    "data/porsche911turbos/vehicles.meta",
    "data/porsche911turbos/carcols.meta",
    "data/porsche911turbos/carvariations.meta",

    -- pininfarina
    "data/25pininfarina/handling.meta",
    "data/25pininfarina/vehicles.meta",
    "data/25pininfarina/carvariations.meta",

    -- fiat-panda-supernova
    "data/fiat-panda-supernova/vehicles.meta",
    "data/fiat-panda-supernova/carvariations.meta",
    "data/fiat-panda-supernova/carcols.meta",
    "data/fiat-panda-supernova/handling.meta",
    "data/fiat-panda-supernova/vehiclelayouts.meta",

    -- fiat bravo
    "data/bravo/handling.meta",
    "data/bravo/vehicles.meta",
    "data/bravo/carcols.meta",
    "data/bravo/carvariations.meta",
    "data/bravo/dlctext.meta",
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

-- charger 69
data_file("HANDLING_FILE")("data/charger/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/charger/vehicles.meta")
data_file("CARCOLS_FILE")("data/charger/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/charger/carvariations.meta")
data_file("DLCTEXT_FILE")("data/charger/dlctext.meta")

-- gxa45
data_file("HANDLING_FILE")("data/gxa45/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/gxa45/vehicles.meta")
data_file("CARCOLS_FILE")("data/gxa45/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/gxa45/carvariations.meta")
data_file("DLCTEXT_FILE")("data/gxa45/dlctext.meta")

-- f_wide296
data_file("HANDLING_FILE")("data/f_wide296/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/f_wide296/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/f_wide296/carvariations.meta")
data_file("DLCTEXT_FILE")("data/f_wide296/dlctext.meta")
data_file("VEHICLE_LAYOUTS_FILE")("data/f_wide296/vehiclelayouts.meta")

-- st3
data_file("HANDLING_FILE")("data/st3/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/st3/vehicles.meta")
data_file("CARCOLS_FILE")("data/st3/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/st3/carvariations.meta")
data_file("DLCTEXT_FILE")("data/st3/dlctext.meta")

-- porsche911turbos
data_file("HANDLING_FILE")("data/porsche911turbos/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/porsche911turbos/vehicles.meta")
data_file("CARCOLS_FILE")("data/porsche911turbos/carcols.meta")
data_file("VEHICLE_VARIATION_FILE")("data/porsche911turbos/carvariations.meta")

-- 25pininfarina
data_file("HANDLING_FILE")("data/25pininfarina/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/25pininfarina/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/25pininfarina/carvariations.meta")

-- fiat-panda-supernova
data_file("HANDLING_FILE")("data/fiat-panda-supernova/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/fiat-panda-supernova/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/fiat-panda-supernova/carvariations.meta")
data_file("VEHICLE_LAYOUTS_FILE")("data/fiat-panda-supernova/vehiclelayouts.meta")
dat_file("VEHICLE_VARIATION_FILE")("data/fiat-panda-supernova/carvariations.meta")

-- Fiat bravo
data_file("HANDLING_FILE")("data/bravo/handling.meta")
data_file("VEHICLE_METADATA_FILE")("data/bravo/vehicles.meta")
data_file("VEHICLE_VARIATION_FILE")("data/bravo/carvariations.meta")
data_file("CARCOLS_FILE")("data/bravo/carcols.meta")
data_file("DLCTEXT_FILE")("data/bravo/dlctext.meta")

client_script({
    "vehicle_names.lua",
})
