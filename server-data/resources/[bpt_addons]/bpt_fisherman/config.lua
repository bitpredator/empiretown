Config                            = {}
Config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.EnablePlayerManagement     = true -- Enable society managing.
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'it'

Config.AuthorizedVehicles = {
	{model = 'rumpo', label = 'Rumpo'}
}

Config.Zones = {

	VehicleSpawner = {
		Pos   = {x = -351.956055, y = -2790.316406, z = 5.993408},
		Size  = {x = 0.6, y = 0.6, z = 0.6},
		Color = {r = 204, g = 204, b = 0},
		Type  = 36, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = -363.270325, y = -2775.824219, z = 5.993408},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 225.0
	},

	VehicleDeleter = {
		Pos   = {x = -348.118683, y = -2760.224121, z = 5.027100},
		Size  = {x = 3.0, y = 3.0, z = 0.25},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	},

	FishermanActions = {
		Pos   = {x = -327.547241, y = -2769.125244, z = 5.201416},
		Size  = {x = 0.6, y = 0.6, z = 0.6},
		Color = {r = 204, g = 204, b = 0},
		Type  = 20, Rotate = true
	},

	Cloakroom = {
		Pos     = {x = -323.604401, y = -2784.065918, z = 5.201416},
		Size    = {x = 0.6, y = 0.6, z = 0.6},
		Color   = {r = 204, g = 204, b = 0},
		Type    = 21, Rotate = true
	}
}