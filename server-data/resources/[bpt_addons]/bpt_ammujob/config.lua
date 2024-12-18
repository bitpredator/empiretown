---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Armories = 21, BossActions = 22, Vehicles = 36 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableArmoryManagement = false
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

Config.Ammu = {

    AMMU = {

        Blip = {
            Coords = vector3(425.1, -979.5, 30.7),
            Sprite = 60,
            Display = 4,
            Scale = 1.2,
            Colour = 29,
        },

        Armories = {
            vector3(812.518677, -2159.010986, 29.616821),
        },

        Vehicles = {
            {
                Spawner = vector3(454.6, -1017.4, 28.4),
                InsideShop = vector3(444.553833, -1019.498901, 28.605835),
                SpawnPoints = {
                    { coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
                },
            },

            {
                Spawner = vector3(473.3, -1018.8, 28.0),
                InsideShop = vector3(228.5, -993.5, -99.0),
                SpawnPoints = {
                    { coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0 },
                },
            },
        },

        BossActions = {
            vector3(824.742859, -2150.386719, 29.616821),
        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        apprentice = {},

        gunsmith = {
            { model = "police3", price = 20000 },
        },

        armorychief = {
            { model = "policet", price = 18500 },
        },

        deputydirector = {
            { model = "riot", price = 70000 },
        },

        boss = {
            { model = "riot", price = 70000 },
        },
    },
}
