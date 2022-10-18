cfg = {
    esxLegacy = true,

    blip = {
        ['blipapple'] = vector3(2350.575928, 4734.632812, 34.789795),
        ['blipapplename'] = "Apple Farm",
        ['blippotato'] = vector3(2538.5693, 4810.2466, 33.7287),
        ['blippotatoname'] = "Potato Farm",

    },

    job = {
        ['job'] = "farmer"
    },

    marker = {
        ['apple'] = vector3(2350.575928, 4734.632812, 34.789795),
        ['potato'] = vector3(2530.0308, 4805.2065, 33.6990)

    },

    translation = {
        ['apple'] = "Apple [E]",
        ['potato'] = "Potato [E]",
        ['noapple'] = "You don't have apple",
        ['nopotato'] = "You don't have potato",
        ['limit'] = "You have no place in inventory"
    },

}



Notify = function(msg)
    ESX.ShowNotification(msg)
end
