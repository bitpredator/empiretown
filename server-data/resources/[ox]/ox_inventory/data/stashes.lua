return {
	{
		coords = vec3(452.3, -991.4, 30.7),
		target = {
			loc = vec3(451.25, -994.28, 30.69),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open personal locker'
		},
		name = 'policelocker',
		label = 'Personal locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = shared.police
	},

	{
		coords = vec3(335.406586, -584.993408, 28.791260),
		target = {
			loc = vec3(335.406586, -584.993408, 28.791260),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},

	{
		coords = vec3(810.026367, -2159.353760, 29.616821),
		target = {
			loc = vec3(810.026367, -2159.353760, 29.616821),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Storage'
		},
		name = 'ammulocker',
		label = 'Storage',
		owner = false,
		slots = 70,
		weight = 70000,
		groups = {['ammu'] = 0}
	},

	{
		coords = vec3(129.507690, -1281.454956, 29.263062),
		target = {
			loc = vec3(129.507690, -1281.454956, 29.263062),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Storage'
		},
		name = 'unicornlocker',
		label = 'Storage',
		owner = false,
		slots = 70,
		weight = 70000,
		groups = {['unicorn'] = 0}
	},

	{
		coords = vec3(93.204399, -1291.833008, 29.263062),
		target = {
			loc = vec3(93.204399, -1291.833008, 29.263062),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Storage Personal'
		},
		name = 'unicornlocker',
		label = 'Storage Personal',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['unicorn'] = 0}
	},
}
