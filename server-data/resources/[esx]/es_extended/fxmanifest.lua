fx_version 'adamant'

game 'gta5'

description 'ES Extended'

lua54 'yes'
version '0.0.4'

shared_scripts {
	'locale.lua',
	'locales/*.lua',
	'config.lua',
	'config.weapons.lua',
	'dependencies/async/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/common.lua',
	'server/classes/player.lua',
	'server/classes/overrides/*.lua',
	'server/functions.lua',
	'server/onesync.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'dependencies/cron/server/*.lua',
	'dependencies/hardcap/server/*.lua'
}

client_scripts {
	'client/common.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'dependencies/hardcap/client/*.lua'
}

files {
	'imports.lua',
	'locale.js'
}

dependencies {
	'/native:0x6AE51D4B',
	'oxmysql',
	'spawnmanager',
}