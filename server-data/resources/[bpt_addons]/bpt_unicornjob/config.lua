Config = {}
Config.DrawDistance = 100.0

Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableMoneyWash = true
Config.MaxInService = -1
Config.Locale = 'it'

Config.AuthorizedVehicles = {
    { name = 'rentalbus',  label = 'Vanilla Unicorn Bus' },
}

Config.Blips = {
    Blip = {
      Pos     = { x = 129.246, y = -1299.363, z = 29.501 },
      Sprite  = 121,
      Display = 4,
      Scale   = 1.2,
      Colour  = 27,
    },
}

Config.Zones = {
    Cloakrooms = {
        Pos   = { x = 105.111, y = -1303.221, z = 27.788 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 187, b = 255 },
        Type  = 27,
    },

    Vehicles = {
        Pos          = { x = 137.177, y = -1278.757, z = 28.371 },
        SpawnPoint   = { x = 138.436, y = -1263.095, z = 28.626 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 23,
        Heading      = 207.43,
    },

    VehicleDeleters = {
        Pos   = { x = 133.203, y = -1265.573, z = 28.396 },
        Size  = { x = 3.0, y = 3.0, z = 0.2 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 1,
    },

    BossActions = {
        Pos   = { x = 94.951, y = -1294.021, z = 28.268 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 1,
    },
}

-----------------------
----- TELEPORTERS -----
Config.TeleportZones = {
EnterBuilding = {
    Pos       = { x = 132.608, y = -1293.978, z = 28.269 },
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Hint      = _U('e_to_enter_1'),
    Teleport  = { x = 126.742, y = -1278.386, z = 28.569 }
  
},

ExitBuilding = {
    Pos       = { x = 132.517, y = -1290.901, z = 28.269 },
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Hint      = _U('e_to_exit_1'),
    Teleport  = { x = 131.175, y = -1295.598, z = 28.569 },
  },
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
  barman_outfit = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 40,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 28,   ['pants_2'] = 2,
        ['shoes_1'] = 38,   ['shoes_2'] = 4,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 8,    ['torso_2'] = 2,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 5,
        ['pants_1'] = 44,   ['pants_2'] = 4,
        ['shoes_1'] = 0,    ['shoes_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 2
    }},
  dancer_outfit_1 = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 15,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 40,
        ['pants_1'] = 61,   ['pants_2'] = 9,
        ['shoes_1'] = 16,   ['shoes_2'] = 9,
        ['chain_1'] = 118,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 22,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 4,
        ['pants_1'] = 22,   ['pants_2'] = 0,
        ['shoes_1'] = 18,   ['shoes_2'] = 0,
        ['chain_1'] = 61,   ['chain_2'] = 1
    }}
}
