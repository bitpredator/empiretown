Config = {}
Config.Locale = 'it'
Config.BlipsEnabled = false
Config.SittingEnabled = true
Config.MaxBetNumbers = 4 -- limit to join game (4 digits default)

Config.Slots = { -- Only fill prop and offset data if Config.SittingEnabled = true 
  	{
		id = 0,
		x = 954.105469,
		y = 40.404400,
		z = 71.421265,
		prop = "vw_prop_casino_slot_07a",
		offsetX = -0.80,
		offsetY = -0.35,
		offsetZ = -0.70
	},
	{
		id = 1,
		x = 954.026367,
		y = 46.180225,
		z = 71.421265,
		prop = "vw_prop_casino_slot_04a",
		offsetX = 0.56,
		offsetY = 0.70,
		offsetZ = -0.70
	},
}
