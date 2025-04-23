---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Governament = 21, BossActions = 22, Vehicles = 36 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableGovernamentManagement = false
Config.EnableESXIdentity = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses = true -- Enable if you're using esx_license.
Config.EnableHandcuffTimer = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer = 10 * 60000 -- 10 minutes.
Config.Locale = GetConvar("esx:locale", "it")
Config.OxInventory = ESX.GetConfig().OxInventory

Config.Governament = {

    GOVERNAMENT = {

        Blip = {
            Coords = vector3(-560.123047, -209.116486, 42.405884),
            Sprite = 478,
            Display = 4,
            Scale = 1.0,
            Colour = 21,
        },

        BossActions = {
            vector3(-560.123047, -209.116486, 42.405884),
        },

        Vehicles = {
            {
                Spawner = vector3(-516.435181, -254.294510, 35.632202),
                InsideShop = vector3(-514.061523, -263.841766, 35.430054),
                SpawnPoints = {
                    { coords = vector3(-514.061523, -263.841766, 35.430054), heading = 90.0, radius = 6.0 },
                },
            },
        },

        --        Governament = {
        --            vector3(1001.630798, -2403.217529, 30.172852),
        --        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        apprentice = {},

        gunsmith = {},

        governamentchief = {},

        deputydirector = {},

        boss = {
            { model = "slamvan", price = 15000 },
        },
    },
}
