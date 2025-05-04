---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Tridentes = 21, BossActions = 22, Vehicles = 36 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableTridenteManagement = false
Config.EnableESXIdentity = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses = true -- Enable if you're using esx_license.
Config.EnableHandcuffTimer = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer = 10 * 60000 -- 10 minutes.
Config.EnableESXService = false -- Enable esx service?
Config.MaxInService = -1 -- How many people can be in service at once? Set as -1 to have no limit
Config.EnableFinePresets = false -- Set to false to use a custom input fields for fines
Config.Locale = GetConvar("esx:locale", "it")
Config.OxInventory = ESX.GetConfig().OxInventory

Config.Tridente = {

    TRIDENTE = {

        Blip = {
            Coords = vector3(812.043945, -2145.692383, 29.330444),
            Sprite = 110,
            Display = 4,
            Scale = 1.2,
            Colour = 17,
        },

        Tridentes = {
            vector3(-1866.263794, 2061.336182, 135.433716),
        },

        Vehicles = {
            {
                Spawner = vector3(-1906.443970, 2020.852783, 140.791992),
                InsideShop = vector3(-1906.443970, 2020.852783, 140.791992),
                SpawnPoints = {
                    { coords = vector3(-1906.443970, 2020.852783, 140.791992), heading = 45.0, radius = 6.0 },
                },
            },
        },

        BossActions = {
            vector3(-1875.850586, 2060.887939, 145.560425),
        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        apprentice = {
            { model = "kuruma2", price = 250000 },
        },

        gunsmith = {
            { model = "kuruma2", price = 250000 },
        },

        tridentechief = {
            { model = "kuruma2", price = 250000 },
        },

        deputydirector = {
            { model = "kuruma2", price = 250000 },
        },

        boss = {
            { model = "kuruma2", price = 250000 },
        },
    },
}
