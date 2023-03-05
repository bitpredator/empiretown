return {

	Import = {
		name = 'Negozio import',
		groups = {
			['import'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'pickaxe', price = 30 },
			{ name = 'almonds', price = 10 },
			{ name = 'fishingrod', price = 100},
			{ name = 'fishbait', price = 80}
		}, locations = {
			vec3(1017.389038, -2405.736328, 30.122314)
		}, targets = {

		}
	},

	Unicorn = {
		name = 'Negozio unicorn',
		groups = {
			['unicorn'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'water', price = 30 },
			{ name = 'ice',   price = 5  },
			{ name = 'fry_oil', price = 60 }
		}, locations = {
			vec3(132.408798, -1286.439575, 29.263062)
		}, targets = {

		}
	},

	VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	},

	DigitalStore = {
		name = 'Digital Store',
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'phone',   price = 3000 },
		}, locations = {
			vec3(385.885712, -826.523071, 29.296753)
		}, targets = {

		}
	},

	Backpacks = {
		name = 'Backpacks',
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'backpack',   price = 800 }
		}, locations = {
			vec3(-1131.481323, -1635.652710, 4.359009)
		}, targets = {

		}
	},

	DmvSchool = {
		name = 'Scuola Guida',
		groups = {
			['drivingschool'] = 4
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'dmvcard',   price = 10000 }
		}, locations = {
			vec3(214.694519, -1400.452759, 30.577271)
		}, targets = {

		}
	},

    Government = {
		name = 'Governo',
		blip = {
			id = 419, scale = 0.8
		}, inventory = {
			{ name = 'jobcard',   price = 3000 },
			{ name = 'idcard',   price = 3000 }
		}, locations = {
			vec3(-554.887939, -187.252747, 38.277710)
		}, targets = {

		}
	},
}
