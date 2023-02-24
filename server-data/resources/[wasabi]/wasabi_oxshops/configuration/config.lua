Config = {}
Config.Shops = {
    ['import'] = { -- Job name
        label = 'negozio import',
        blip = {
            enabled = true,
            coords = vec3(-707.419800, -914.479126, 19.203613),
            sprite = 279,
            color = 8,
            scale = 0.7,
            string = 'import'
        },
        bossMenu = {
            enabled = true, -- Enable boss menu?
            coords = vec3(-709.621948, -906.461548, 19.203613), -- Location of boss menu
            string = '[E] - Access Boss Menu', -- Text UI label string
            range = 3.0, -- Distance to allow access/prompt with text UI
        },
        locations = {
            stash = {
                string = '[E] - Access Inventory',
                coords = vec3(-707.419800, -914.479126, 19.203613),
                range = 3.0
            },
            shop = {
                string = '[E] - Access Shop',
                coords = vec3(-707.419800, -914.479126, 19.203613),
                range = 4.0
            }
        }
    }, -- Copy and paste this shop to create more
    
}
