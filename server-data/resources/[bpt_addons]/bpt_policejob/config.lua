Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Cloakrooms = 20, Armories = 21, BossActions = 22, Vehicles = 36, Helicopters = 34 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableArmoryManagement = false
Config.EnableESXIdentity = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses = false -- Enable if you're using esx_license.
Config.EnableHandcuffTimer = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer = 10 * 60000 -- 10 minutes.
Config.EnableJobBlip = false -- Enable blips for cops on duty, requires esx_society.
Config.EnableESXService = false -- Enable esx service?
Config.MaxInService = -1 -- How many people can be in service at once? Set as -1 to have no limit
Config.EnableFinePresets = false -- Set to false to use a custom input fields for fines
Config.Locale = GetConvar("esx:locale", "it")
Config.OxInventory = ESX.GetConfig().OxInventory

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords = vector3(425.1, -979.5, 30.7),
			Sprite = 60,
			Display = 4,
			Scale = 1.2,
			Colour = 29,
		},

		Cloakrooms = {
			vector3(462.145050, -999.468140, 30.678345),
		},

		Armories = {
			vector3(487.239563, -996.949463, 30.678345),
		},

		Vehicles = {
			{
				Spawner = vector3(454.6, -1017.4, 28.4),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
					{ coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0 },
					{ coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0 },
					{ coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0 },
				},
			},

			{
				Spawner = vector3(473.3, -1018.8, 28.0),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0 },
					{ coords = vector3(484.1, -1023.1, 27.5), heading = 302.5, radius = 6.0 },
				},
			},
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 },
				},
			},
		},

		BossActions = {
			vector3(462.052734, -985.582397, 30.712036),
		},
	},
}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = "WEAPON_STUNGUN", price = 1500 },
		{ weapon = "WEAPON_FLASHLIGHT", price = 80 },
	},

	officer = {
		{ weapon = "WEAPON_ADVANCEDRIFLE", components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = "WEAPON_STUNGUN", price = 500 },
		{ weapon = "WEAPON_FLASHLIGHT", price = 0 },
	},

	sergeant = {
		{ weapon = "WEAPON_ADVANCEDRIFLE", components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = "WEAPON_PUMPSHOTGUN", components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = "WEAPON_STUNGUN", price = 500 },
		{ weapon = "WEAPON_FLASHLIGHT", price = 0 },
	},

	lieutenant = {
		{ weapon = "WEAPON_ADVANCEDRIFLE", components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = "WEAPON_PUMPSHOTGUN", components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = "WEAPON_STUNGUN", price = 500 },
		{ weapon = "WEAPON_FLASHLIGHT", price = 0 },
	},

	boss = {
		{ weapon = "WEAPON_ADVANCEDRIFLE", components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = "WEAPON_PUMPSHOTGUN", components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = "WEAPON_STUNGUN", price = 500 },
		{ weapon = "WEAPON_FLASHLIGHT", price = 0 },
	},
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {},

		officer = {
			{ model = "police3", price = 20000 },
		},

		sergeant = {
			{ model = "policet", price = 18500 },
			{ model = "policeb", price = 30500 },
		},

		lieutenant = {
			{ model = "riot", price = 70000 },
			{ model = "fbi2", price = 60000 },
		},

		boss = {
			{ model = "riot", price = 70000 },
			{ model = "fbi2", price = 60000 },
			{ model = "policet", price = 18500 },
			{ model = "policeb", price = 30500 },
			{ model = "police3", price = 20000 },
		},
	},

	helicopter = {
		recruit = {},

		officer = {},

		sergeant = {},

		lieutenant = {
			{ model = "polmav", props = { modLivery = 0 }, price = 200000 },
		},

		boss = {
			{ model = "polmav", props = { modLivery = 0 }, price = 100000 },
		},
	},
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	recruit = {
		male = {
			tshirt_1 = 59,
			tshirt_2 = 1,
			torso_1 = 55,
			torso_2 = 0,
			decals_1 = 0,
			decals_2 = 0,
			arms = 41,
			pants_1 = 25,
			pants_2 = 0,
			shoes_1 = 25,
			shoes_2 = 0,
			helmet_1 = 46,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
		female = {
			tshirt_1 = 36,
			tshirt_2 = 1,
			torso_1 = 48,
			torso_2 = 0,
			decals_1 = 0,
			decals_2 = 0,
			arms = 44,
			pants_1 = 34,
			pants_2 = 0,
			shoes_1 = 27,
			shoes_2 = 0,
			helmet_1 = 45,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
	},

	officer = {
		male = {
			tshirt_1 = 58,
			tshirt_2 = 0,
			torso_1 = 55,
			torso_2 = 0,
			decals_1 = 0,
			decals_2 = 0,
			arms = 41,
			pants_1 = 25,
			pants_2 = 0,
			shoes_1 = 25,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
		female = {
			tshirt_1 = 35,
			tshirt_2 = 0,
			torso_1 = 48,
			torso_2 = 0,
			decals_1 = 0,
			decals_2 = 0,
			arms = 44,
			pants_1 = 34,
			pants_2 = 0,
			shoes_1 = 27,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
	},

	sergeant = {
		male = {
			tshirt_1 = 58,
			tshirt_2 = 0,
			torso_1 = 55,
			torso_2 = 0,
			decals_1 = 8,
			decals_2 = 1,
			arms = 41,
			pants_1 = 25,
			pants_2 = 0,
			shoes_1 = 25,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
		female = {
			tshirt_1 = 35,
			tshirt_2 = 0,
			torso_1 = 48,
			torso_2 = 0,
			decals_1 = 7,
			decals_2 = 1,
			arms = 44,
			pants_1 = 34,
			pants_2 = 0,
			shoes_1 = 27,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
	},

	lieutenant = {
		male = {
			tshirt_1 = 58,
			tshirt_2 = 0,
			torso_1 = 55,
			torso_2 = 0,
			decals_1 = 8,
			decals_2 = 2,
			arms = 41,
			pants_1 = 25,
			pants_2 = 0,
			shoes_1 = 25,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
		female = {
			tshirt_1 = 35,
			tshirt_2 = 0,
			torso_1 = 48,
			torso_2 = 0,
			decals_1 = 7,
			decals_2 = 2,
			arms = 44,
			pants_1 = 34,
			pants_2 = 0,
			shoes_1 = 27,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
	},

	boss = {
		male = {
			tshirt_1 = 58,
			tshirt_2 = 0,
			torso_1 = 55,
			torso_2 = 0,
			decals_1 = 8,
			decals_2 = 3,
			arms = 41,
			pants_1 = 25,
			pants_2 = 0,
			shoes_1 = 25,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
		female = {
			tshirt_1 = 35,
			tshirt_2 = 0,
			torso_1 = 48,
			torso_2 = 0,
			decals_1 = 7,
			decals_2 = 3,
			arms = 44,
			pants_1 = 34,
			pants_2 = 0,
			shoes_1 = 27,
			shoes_2 = 0,
			helmet_1 = -1,
			helmet_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
			ears_1 = 2,
			ears_2 = 0,
		},
	},

	bullet_wear = {
		male = {
			bproof_1 = 11,
			bproof_2 = 1,
		},
		female = {
			bproof_1 = 13,
			bproof_2 = 1,
		},
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,
			tshirt_2 = 1,
		},
		female = {
			tshirt_1 = 36,
			tshirt_2 = 1,
		},
	},
}
