Config = {}

-- If you are using ESX 1.2.0 or higher please leave this to false
Config.UsingOldESX = false

-- locale
Config.Locale = "it"

-- The key to save the car, default key is "E" (horn)
Config.KeyToSave = 51

-- Enable debug mode
Config.debug = false

-- Parking locations
Config.ParkingLocations = {
    parking = {
        x = -2032.338501, -- Central location X, Y, Z of the parking
        y =  -467.789001, -- Y
        z =  11.368530, -- Z
        size = 15.0, -- The parking range radius (Horizontal), set to 10000.0 then you can parking anywhere
        height = 10.0, -- The parking range radius (Vertical)
        name = "Public Parking", -- The name of the parking (blips)
        fee = 500, -- How much parking fee per day (Real life time), set 0 or false to disable
        enter = { x = -2032.338501, y = -467.789001, z = 11.368530 }, -- The entrance of the parking
        maxcar = 33, -- Max vehicles can save on this parking
        notify = true, -- Display the "Press E to save" notification, set to false can disable it
    },
    parking1 = {
        x = -327.73, -- Central location X, Y, Z of the parking
        y = -934.12, -- Y
        z = 31.08, -- Z
        size = 55.0, -- The parking range radius (Horizontal), set to 10000.0 then you can parking anywhere
        height = 10.0, -- The parking range radius (Vertical)
        name = "Public Parking", -- The name of the parking (blips)
        fee = 1000, -- How much parking fee per day (Real life time), set 0 or false to disable
        enter = { x = -279.25, y = -890.39, z = 30.08 }, -- The entrance of the parking
        maxcar = 500, -- Max vehicles can save on this parking
        notify = true, -- Display the "Press E to save" notification, set to false can disable it
    },
    parking2 = {
        x = -340.03,
        y = 285.19,
        z = 84.77,
        size = 15.0,
        height = 10.0,
        name = "Public Parking",
        fee = 500,
        enter = { x = -338.57, y = 267.16, z = 85.73 },
        maxcar = 10,
        notify = true,
    },
    parking3 = {
        x = 446.98,
        y = 246.07,
        z = 103.86,
        size = 25.0,
        height = 10.0,
        name = "Public Parking",
        fee = 800,
        enter = { x = 467.96, y = 265.07, z = 103.09 },
        maxcar = 20,
        notify = true,
    },
    parking4 = {
        x = 374.35,
        y = 279.49,
        z = 103.32,
        size = 20.0,
        height = 10.0,
        name = "Public Parking",
        fee = 700,
        enter = { x = 364.77, y = 298.98, z = 103.5 },
        maxcar = 15,
        notify = true,
    },
    parking5 = {
        x = 1038.013184,
        y = -764.663757,
        z = 57.924561,
        size = 30.0,
        height = 10.0,
        name = "Parcheggio Pubblico N°5 Zona Residenziale",
        fee = 500,
        enter = { x = 1038.013184, y = -764.663757, z = 57.924561 },
        maxcar = 18,
        notify = true,
    },
    parking6 = {
        x = 224.95384,
        y = -786.63293,
        z = 30.72888,
        size = 30.0,
        height = 10.0,
        name = "Parcheggio Pubblico N°6",
        fee = 600,
        enter = { x = 224.95384, y = -786.63293, z = 30.72888 },
        maxcar = 78,
        notify = true,
    },
}
