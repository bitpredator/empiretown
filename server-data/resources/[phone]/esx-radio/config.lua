Config = {}

Config.Item = {
    Require = true,
    name = "radio",
}

Config.KeyMappings = {
    Enabled = true,
    Key = "UP",
}

Config.ClientNotification = function(msg)
    ESX.ShowNotification(msg, false, false, 140)
end

Config.ServerNotification = function(msg, player)
    TriggerClientEvent("esx:showNotification", player, msg)
end

--- Resticts in index order
Config.RestrictedChannels = {
    { -- Channel 1
        police = true,
        ambulance = true,
    },
    { -- Channel 2
        police = true,
        ambulance = true,
    },
    { -- Channel 3
        police = true,
        ambulance = true,
    },
    { -- Channel 4
        police = true,
        ambulance = true,
    },
    { -- Channel 5
        police = true,
        ambulance = true,
    },
    { -- Channel 6
        police = true,
        ambulance = true,
    },
    { -- Channel 7
        police = true,
        ambulance = true,
    },
    { -- Channel 8
        police = true,
        ambulance = true,
    },
    { -- Channel 9
        police = true,
        ambulance = true,
    },
    { -- Channel 10
        police = true,
        ambulance = true,
    },
}

Config.MaxFrequency = 500

Config.messages = {
    ["not on radio"] = "You're not connected to a signal",
    ["on radio"] = "You're already connected to this signal",
    ["joined to radio"] = "You're connected to: ",
    ["restricted channel error"] = "You can not connect to this signal!",
    ["invalid radio"] = "This frequency is not available.",
    ["you on radio"] = "You're already connected to this channel",
    ["you leave"] = "You left the channel.",
    ["volume radio"] = "New volume ",
    ["decrease radio volume"] = "The radio is already set to maximum volume",
    ["increase radio volume"] = "The radio is already set to the lowest volume",
    ["increase decrease radio channel"] = "New channel ",
}
