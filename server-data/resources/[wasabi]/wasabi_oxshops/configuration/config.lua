Config = {}
Config.Shops = {
    ['ambulance'] = { -- Job name
        label = 'Hospital Shop',
        blip = {
            enabled = true,
            coords = vec3(309.415375, -561.784607, 43.282104),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = 'ambulance'
        },
        locations = {
            stash = {
                string = '[E] - Access Inventory',
                coords = vec3(309.415375, -561.784607, 43.282104),
                range = 3.0
            },
            shop = {
                string = '[E] - Access Shop',
                coords = vec3(308.782410, -592.061523, 43.282104),
                range = 4.0
            }
        }
    }, -- Copy and paste this shop to create more
    
}