cfg = {
    esxLegacy = true,

    blip = {
        ['blipapple'] = vector3(2350.575928, 4734.632812, 34.789795),
        ['blipapplename'] = "Apple Farm",

    },

    job = {
        ['job'] = "farmer"
    },

    marker = {
        ['apple'] = vector3(2350.575928, 4734.632812, 34.789795)

    },

    translation = {
        ['apple'] = "Apple [E]",
        ['noapple'] = "You don't have apple",
        ['limit'] = "You have no place in inventory"
    },

}



Notify = function(msg)
    ESX.ShowNotification(msg)
end
