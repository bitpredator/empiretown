return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			status = { hunger = 2100000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			}
		}
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 2000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['bread_deer'] = {
		label = 'panino con carne di cervo',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Hai mangiato un panino con carne di cervo'
		},
	},

	['cola'] = {
		label = 'eCola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with cola'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	
	['paper'] = {
		label = 'carta',
		weight = 100,
		stack = true,
		consume = 0
	},

	['fags'] = {
		label = 'pacchetto di sigarette usato',
		weight = 100,
		stack = true,
		consume = 0
	},

	['newspaper'] = {
		label = 'giornale rovinato',
		weight = 100,
		stack = true,
		consume = 0
	},

	['trash_burgershot'] = {
		label = 'scatola di burgershot usata',
		weight = 100,
		stack = true,
		consume = 0
	},
	
	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['recycled_paper'] = {
		label = 'carta riciclata',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['trash_can'] = {
		label = 'lattina usata',
		weight = 100,
		stack = true,
		close = false,
		consume = 0
	},

	['trash_chips'] = {
		label = 'busta di patatine usata',
		weight = 100,
		stack = true,
		close = false,
		consume = 0
	},

	['cotton'] = {
		label = 'cotone',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['cloth'] = {
		label = 'stoffa',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},
	
	['clothes'] = {
		label = 'abiti',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['cottonforbandages'] = {
		label = 'cotone per bende',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['gold'] = {
		label = 'Oro',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['diamond'] = {
		label = 'Diamante',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['emerald'] = {
		label = 'Smeraldo',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['copper'] = {
		label = 'Rame',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['iron'] = {
		label = 'Ferro',
		weight = 1,
		stack = true,
		close = false,
		consume = 0
	},

	['steel'] = {
		label = 'Acciaio',
		weight = 5,
		stack = true,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 0,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			usetime = 5000,
			cancel = true
		}
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['ironsheet'] = {
		label = 'lamiera di ferro',
		stack = true,
		weight = 1
	},

	['pickaxe'] = {
		label = 'Piccone',
		consume = 0,
	},

	['legno'] = {
		label = 'Legna',
		weight = 100,
		stack = true,
		close = false,
		consume = 0
	},

	['legnatagliata'] = {
		label = 'legno tagliato',
		weight = 100,
		stack = true,
		close = false,
		consume = 0
	},

	['hammer'] = {
		label = 'martello',
		consume = 0,
	},

	['fixkit'] = {
		label = 'kit di riparazione',
		consume = 0,
	},

	['almonds'] = {
		label = 'mandorla',
		weight = 100,
		stack = true,
	},

	['ice'] = {
		label = 'Ghiaccio',
		weight = 100,
		stack = true,
	},
	
	['cannabis'] = {
		label = 'cannabis',
		weight = 100,
		stack = true,
	},
   
    ['marijuana'] = {
	    label = 'marijuana',
	    weight = 100,
	    stack = true,
    },

	['apple'] = {
	    label = 'Mele',
	    weight = 100,
	    stack = true,
    },

	['milk'] = {
	    label = 'latte',
	    weight = 100,
	    stack = true,
    },

	['potato'] = {
	    label = 'Patate',
	    weight = 100,
	    stack = true,
    },

	['chips'] = {
	    label = 'Patatine fritte',
	    weight = 100,
	    stack = true, 
    },
    
	['slicedchips'] = {
	    label = 'Patate affettate',
	    weight = 100,
	    stack = true,
    },
	
	['fishingrod'] = {
	    label = 'canna da pesca',
	    weight = 100,
	    stack = true,
    },

	['fishbait'] = {
	    label = 'esca per pesci',
	    weight = 100,
	    stack = true,
    },

	['anchovy'] = {
	    label = 'acciuga',
	    weight = 100,
	    stack = true,
    },

	['trout'] = {
	    label = 'trota',
	    weight = 100,
	    stack = true,
    },

	['salmon'] = {
	    label = 'salmone',
	    weight = 100,
	    stack = true,
    },

	['tuna'] = {
	    label = 'tonno',
	    weight = 100,
	    stack = true,
    },

	['cigarette_paper'] = {
	    label = 'cartina per sigarette',
	    weight = 100,
	    stack = true,
    },

	['almondmilk'] = {
		label = 'Latte di mandorla',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'hai bevuto una bibita fresca'
		}
	},

	['backpack'] = {
		label = 'zainetto',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'wasabi_backpack.openBackpack'
		}
	},
	 
	['boar_meat'] = {
	    label = 'carne di cinghiale',
	    weight = 3000,
	    stack = true,
    },

	['pelt_mtnlion'] = {
	    label = 'Pelle di leone di montagna',
	    weight = 3000,
	    stack = true,
    },

	['deer_meat'] = {
	    label = 'carne di cervo',
	    weight = 3000,
	    stack = true,
    },

	['pelt_coyote'] = {
	    label = 'Pelle di coyote',
	    weight = 3000,
	    stack = true,
    },

	['rabbit_meat'] = {
	    label = 'carne di coniglio',
	    weight = 1000,
	    stack = true,
    },

	['gunpowder'] = {
	    label = 'polvere da sparo',
	    weight = 500,
	    stack = true,
    },

	['grain'] = {
	    label = 'grano',
	    weight = 100,
	    stack = true,
    },

	['bread'] = {
		label = 'panino vuoto',
		weight = 100,
		stack = true,
		consume = 0,
	},

	['flour'] = {
		label = 'farina',
		weight = 100,
		stack = true,
	},

	['fry_oil'] = {
		label = 'olio per friggere',
		weight = 100,
		stack = true,
	},

	['idcard'] = {
		label = 'carta d\'identità',
		weight = 1,
		stack = false,
	},

	['jobcard'] = {
		label = 'documento lavorativo',
		weight = 1,
		stack = false,
	},

	['dmvcard'] = {
		label = 'patente di guida',
		weight = 1,
		stack = false,
	},

	['licensecard'] = {
		label = 'porto d\'armi',
		weight = 1,
		stack = false,
	},

}
