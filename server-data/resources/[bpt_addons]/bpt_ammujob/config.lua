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
            Coords = vector3(812.043945, -2145.692383, 29.330444),
            Sprite = 110,
            Display = 4,
            Scale = 1.2,
            Colour = 17,
        },

        Armories = {
            vector3(812.518677, -2159.010986, 29.616821),
        },

        Vehicles = {
            {
                Spawner = vector3(821.274719, -2144.584717, 28.740601),
                InsideShop = vector3(832.193420, -2124.145020, 29.380981),
                SpawnPoints = {
                    { coords = vector3(818.452759, -2131.556152, 29.279907), heading = 90.0, radius = 6.0 },
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

        gunsmith = {},

        armorychief = {},

        deputydirector = {},

        boss = {
            { model = "stockade4", price = 15000 },
        },
    },
}
