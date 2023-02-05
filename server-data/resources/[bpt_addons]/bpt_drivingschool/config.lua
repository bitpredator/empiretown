Config                            = {}

Config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MaxInService               = -1 -- How much people can be in service at once?
Config.EnablePlayerManagement     = true -- Enable society managing.
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'it'
Config.AuthorizedVehicles = {
	{model = 'blista', label = 'Blista'}
}

Config.Zones = {

	VehicleSpawner = {
		Pos   = {x = 213.534073, y = -1386.540649, z = 30.577271},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 36, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = 213.797806, y = -1373.551636, z = 30.577271},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 225.0
	},

	VehicleDeleter = {
		Pos   = {x = 213.797806, y = -1373.551636, z = 29.577271},
		Size  = {x = 3.0, y = 3.0, z = 0.25},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	},

	DrivingschoolActions = {
		Pos   = {x = 212.782425, y = -1399.833008, z = 30.577271},
		Size  = {x = 0.5, y = 0.5, z = 0.5},
		Color = {r = 204, g = 204, b = 0},
		Type  = 20, Rotate = true
	}
}
