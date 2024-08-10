Config = {
	UseLimitSystem = false, -- Enable if your esx uses limit system
	CraftingStopWithDistance = false, -- Crafting will stop when not near workbench
	ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)
	HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

	Categories = {
		["medical"] = {
			Label = "Ospedale",
			Image = "bandage",
			Jobs = { "ambulance" },
		},
		["import"] = {
			Label = "Import",
			Image = "Import",
			Jobs = { "import" },
		},
		["mechanic"] = {
			Label = "Meccanico",
			Image = "Mechanic",
			Jobs = { "mechanic" },
		},
		["ammu"] = {
			Label = "Armeria",
			Image = "ammu",
			Jobs = { "ammu" },
		},
		["unicorn"] = {
			Label = "Unicorn",
			Image = "unicorn",
			Jobs = { "unicorn" },
		},
		["dustman"] = {
			Label = "Dustman",
			Image = "dustman",
			Jobs = { "dustman" },
		},
		["ballas"] = {
			Label = "Ballas",
			Image = "ballas",
			Jobs = { "ballas" },
		},
		["baker"] = {
			Label = "Baker",
			Image = "baker",
			Jobs = { "baker" },
		},
		["fisherman"] = {
			Label = "fisherman",
			Image = "fisherman",
			Jobs = { "fisherman" },
		},
	},

	PermanentItems = { -- Items that dont get removed when crafting
		["wrench"] = true,
	},

	Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque
		["bandage"] = {
			Level = 0,
			Category = "medical",
			isGun = false,
			Jobs = { "ambulance" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 20,
			Ingredients = {
				["cottonforbandages"] = 2,
			},
		},

		["cottonforbandages"] = {
			Level = 0, -- From what level this item will be craftable
			Category = "import", -- The category item will be put in
			isGun = false, -- Specify if this is a gun so it will be added to the loadout
			Jobs = { "import" }, -- What jobs can craft this item, leaving {} allows any job
			JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
			Amount = 1, -- The amount that will be crafted
			SuccessRate = 100, -- 100% you will recieve the item
			requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
			Time = 20, -- Time in seconds it takes to craft this item
			Ingredients = { -- Ingredients needed to craft this item
				["cotton"] = 4, -- item name and count, adding items that dont exist in database will crash the script
			},
		},

		["ironsheet"] = {
			Level = 0,
			Category = "import",
			isGun = false,
			Jobs = { "import" },
			JobGrades = {},
			Amount = 5,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["iron"] = 1,
				["hammer"] = 1,
			},
		},

		["recycled_paper"] = {
			Level = 0,
			Category = "dustman",
			isGun = false,
			Jobs = { "dustman" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["paper"] = 2,
			},
		},

		["paper"] = {
			Level = 0,
			Category = "dustman",
			isGun = false,
			Jobs = { "dustman" },
			JobGrades = {},
			Amount = 6,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["newspaper"] = 1,
				["trash_burgershot"] = 1,
			},
		},

		["hammer"] = {
			Level = 0,
			Category = "import",
			isGun = false,
			Jobs = { "import" },
			JobGrades = {},
			Amount = 4,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["iron"] = 4,
				["wood"] = 1,
			},
		},

		["fixkit"] = {
			Level = 0,
			Category = "mechanic",
			isGun = false,
			Jobs = { "mechanic" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["ironsheet"] = 2,
				["hammer"] = 1,
			},
		},

		["almondmilk"] = {
			Level = 0,
			Category = "unicorn",
			isGun = false,
			Jobs = { "unicorn" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["ice"] = 2,
				["almonds"] = 5,
				["water"] = 1,
			},
		},

		["slicedchips"] = {
			Level = 0,
			Category = "unicorn",
			isGun = false,
			Jobs = { "unicorn" },
			JobGrades = {},
			Amount = 5,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 10,
			Ingredients = {
				["potato"] = 1,
				["water"] = 1,
			},
		},

		["iron"] = {
			Level = 0,
			Category = "dustman",
			isGun = false,
			Jobs = { "dustman" },
			JobGrades = {},
			Amount = 3,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 10,
			Ingredients = {
				["hammer"] = 1,
				["trash_can"] = 10,
			},
		},

		["cigarette_paper"] = {
			Level = 0,
			Category = "ballas",
			isGun = false,
			Jobs = { "ballas" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 10,
			Ingredients = {
				["recycled_paper"] = 1,
			},
		},

		["WEAPON_APPISTOL"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 180,
			Ingredients = {
				["copper"] = 1,
				["iron"] = 3,
				["wood"] = 1,
				["steel"] = 5,
			},
		},

		["WEAPON_PISTOL"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 180,
			Ingredients = {
				["copper"] = 1,
				["iron"] = 3,
				["wood"] = 1,
				["steel"] = 5,
			},
		},
		["ammo-sniper"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["copper"] = 1,
				["iron"] = 1,
				["gunpowder"] = 1,
				["gold"] = 1,
			},
		},

		["ammo-9"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["copper"] = 1,
				["iron"] = 1,
				["gunpowder"] = 1,
				["gold"] = 1,
			},
		},

		["WEAPON_KNIFE"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["iron"] = 1,
				["steel"] = 1,
				["wood"] = 1,
			},
		},

		["WEAPON_KNUCKLE"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["iron"] = 2,
				["gold"] = 1,
			},
		},

		["WEAPON_NIGHTSTICK"] = {
			Level = 10,
			Category = "ammu",
			isGun = false,
			Jobs = { "ammu" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["recycled_plastic"] = 10,
			},
		},

		["bread"] = {
			Level = 0,
			Category = "baker",
			isGun = false,
			Jobs = { "baker" },
			JobGrades = {},
			Amount = 5,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 200,
			Ingredients = {
				["flour"] = 1,
			},
		},

		["flour"] = {
			Level = 0,
			Category = "baker",
			isGun = false,
			Jobs = { "baker" },
			JobGrades = {},
			Amount = 1,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 120,
			Ingredients = {
				["grain"] = 10,
			},
		},

		["bread_deer"] = {
			Level = 0,
			Category = "unicorn",
			isGun = false,
			Jobs = { "unicorn" },
			JobGrades = {},
			Amount = 3,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 120,
			Ingredients = {
				["deer_meat"] = 1,
				["bread"] = 3,
			},
		},

		["salmon_fillet"] = {
			Level = 0,
			Category = "fisherman",
			isGun = false,
			Jobs = { "fisherman" },
			JobGrades = {},
			Amount = 2,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 60,
			Ingredients = {
				["salmon"] = 1,
			},
		},

		["recycled_plastic"] = {
			Level = 0,
			Category = "dustman",
			isGun = false,
			Jobs = { "dustman" },
			JobGrades = {},
			Amount = 2,
			SuccessRate = 100,
			requireBlueprint = false,
			Time = 30,
			Ingredients = {
				["plastic_bag"] = 1,
			},
		},
	},

	Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access
		{
			coords = vector3(1020.936279, -2404.628662, 30.122314),
			jobs = { "import" },
			blip = false,
			recipes = { "cottonforbandages", "hammer", "ironsheet" },
			radius = 1.0,
		},
		{
			coords = vector3(311.314301, -565.213196, 43.282104),
			jobs = { "ambulance" },
			blip = false,
			recipes = { "bandage" },
			radius = 1.0,
		},
		{
			coords = vector3(-323.551636, -129.626373, 39.002197),
			jobs = { "mechanic" },
			blip = false,
			recipes = { "fixkit" },
			radius = 1.0,
		},
		{
			coords = vector3(808.984619, -2159.630859, 29.616821),
			jobs = { "ammu" },
			blip = false,
			recipes = {
				"WEAPON_APPISTOL",
				"ammo-sniper",
				"ammo-9",
				"WEAPON_KNIFE",
				"WEAPON_KNUCKLE",
				"WEAPON_NIGHTSTICK",
				"WEAPON_PISTOL",
			},
			radius = 1.0,
		},
		{
			coords = vector3(129.217590, -1283.802246, 29.263062),
			jobs = { "unicorn" },
			blip = false,
			recipes = { "almondmilk", "slicedchips", "bread_deer" },
			radius = 1.0,
		},
		{
			coords = vector3(-416.993408, -1683.468140, 19.018311),
			jobs = { "dustman" },
			blip = false,
			recipes = { "recycled_paper", "paper", "recycled_plastic", "iron" },
			radius = 1.0,
		},
		{
			coords = vector3(83.156044, -1960.259277, 18.041016),
			jobs = { "ballas" },
			blip = false,
			recipes = { "cigarette_paper" },
			radius = 1.0,
		},
		{
			coords = vector3(2342.202148, 3144.817627, 48.202148),
			jobs = { "baker" },
			blip = false,
			recipes = { "flour", "bread" },
			radius = 1.0,
		},
		{
			coords = vector3(-316.549438, -2781.217529, 4.982422),
			jobs = { "fisherman" },
			blip = false,
			recipes = { "salmon_fillet" },
			radius = 1.0,
		},
	},
}

Config.Locale = "it"
