Config = {}

-- Change this only if you have ESX
Config.ESX = exports["es_extended"]:getSharedObject()

-- Debug
Config.Debug = false

-- Should this be opened only from command?
Config.EnableCommand = true

-- Command name
Config.CommandLabel = "carradio"

-- Key to open radio (nil = disabled)
Config.KeyForRadio = nil

-- Default music playing distance
Config.DistancePlaying = 50

-- If the engine is off, disable music until turned on
Config.DisableMusicAfterEngineIsOFF = false

-- Only the owner of the vehicle can play music
Config.OnlyOwnerOfTheCar = false

-- Radio can be used only in owned vehicles
Config.OnlyOwnedCars = false

-- Only vehicles with installed radios can use it
Config.OnlyCarWhoHaveRadio = false -- Requires manual implementation

-- Default music volume
Config.defaultVolume = 0.3

-- Allowed seats to control the radio
Config.AllowedSeats = {
    [-1] = true, -- Driver
    [0] = true,  -- Front passenger
}

-- Custom distance for specific vehicles (e.g., big speakers)
Config.CustomDistanceForVehicles = {
    -- [GetHashKey("bus")] = 25,
}

-- Blacklisted vehicles
Config.blacklistedCars = {
    -- Bikes
    `bmx`, `cruiser`, `fixter`, `scorcher`, `tribike`, `tribike2`, `tribike3`,

    -- Other
    `thruster`,
}

-- Whitelisted vehicles (if a category is disabled but you want exceptions)
Config.whitelistedCars = {
    -- Example: [GetHashKey("example_car")] = true,
}

-- Blacklisted vehicle categories
Config.blackListedCategories = {
    anyVehicle = true,
    anyBoat    = true,
    anyHeli    = false,
    anyPlane   = true,
    anyCopCar  = true,
    anySub     = false,
    anyTaxi    = true,
    anyTrain   = true,
}

-- Default radio stations (Max 6, otherwise HTML must be edited)
Config.defaultList = {
    { label = "Music 1", url = "" },
    { label = "Music 2", url = "" },
    { label = "Music 3", url = "" },
    { label = "Music 4", url = "" },
    { label = "Music 5", url = "" },
    { label = "Music 6", url = "" },
}
