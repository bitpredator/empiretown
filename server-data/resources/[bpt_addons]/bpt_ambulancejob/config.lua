---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).
Config.Debug = ESX.GetConfig().EnableDebug
Config.Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward = 8000 -- Revive reward, set to 0 if you don't want it enabled
Config.LoadIpl = false -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale = GetConvar("esx:locale", "it")

Config.DistressBlip = {
    Sprite = 310,
    Color = 48,
    Scale = 2.0,
}

Config.zoom = {
    min = 1,
    max = 6,
    step = 0.5,
}

Config.EarlyRespawnTimer = 60000 * 10 -- time til respawn is available
Config.BleedoutTimer = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement = true -- Enable society managing (If you are using bpt_society).

Config.RemoveWeaponsAfterRPDeath = false
Config.RemoveCashAfterRPDeath = false
Config.RemoveItemsAfterRPDeath = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine = true
Config.EarlyRespawnFineAmount = 5000

Config.OxInventory = ESX.GetConfig().OxInventory
Config.RespawnPoint = { coords = vector3(341.0, -1397.3, 32.5), heading = 48.5 }

Config.Hospitals = {

    CentralLosSantos = {

        Blip = {
            coords = vector3(292.05, -582.39, 43.18),
            sprite = 61,
            scale = 1.2,
            color = 2,
        },

        AmbulanceActions = {
            vector3(301.925293, -598.549438, 42.282104),
        },

        Vehicles = {
            {
                Spawner = vector3(338.123077, -575.947266, 28.791260),
                InsideShop = vector3(320.756042, -548.004395, 28.740601),
                Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(328.021973, -576.553833, 28.791260), heading = 227.6, radius = 4.0 },
                },
            },
        },

        Helicopters = {
            {
                Spawner = vector3(352.04, -588.39, 74.16),
                InsideShop = vector3(352.04, -588.39, 74.16),
                Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(352.04, -588.39, 74.16), heading = 142.7, radius = 10.0 },
                },
            },
        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        ambulance = {
            { model = "ambulance", price = 5000 },
        },

        doctor = {
            { model = "ambulance", price = 4500 },
        },

        chief_doctor = {
            { model = "ambulance", price = 3000 },
        },

        boss = {
            { model = "ambulance", price = 2000 },
        },
    },

    helicopter = {
        ambulance = {},

        doctor = {
            { model = "frogger2", price = 150000 },
        },

        chief_doctor = {
            { model = "frogger2", price = 150000 },
        },

        boss = {
            { model = "frogger2", price = 10000 },
        },
    },
}
