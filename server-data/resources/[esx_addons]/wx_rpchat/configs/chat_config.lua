wx = {}

--[[ ███► GENERAL SETTINGS ◄███ ]]
--
wx.Logs = false -- Enable logging (requires webhook configuration)
wx.Reports = false -- Enable /report command
wx.AdminChat = true -- Enable /a admin chat
wx.AdCost = 1000 -- Cost for sending an ad (/ad), money removed from bank
wx.AdCooldown = 15000 -- Cooldown between /ad messages (in ms)
wx.MeDoDisplayTime = 5000 -- Duration of /me and /do 3D text (in ms)
wx.OnlyInicials = true -- Use initials in /me and /do (e.g. John Doe → J. D.)
wx.MaxHereTexts = 5 -- Max number of /here texts per player
wx.MaxDocCount = 60 -- Max /doc time allowed
wx.TransparentStatusHere = false -- Transparent background for /here and /status
wx.LOOCAdminPrefixes = true -- Prefix [ADMIN] in LOOC if player is staff

--[[ ███► AUTO MESSAGES ◄███ ]]
--
wx.AutoMessages = true
wx.AutoMessageInterval = 25 -- Interval in minutes
wx.AutoMessagesList = {
    "Discord ufficiale! https://discord.gg/Jrm2Z26ad3",
}

--[[ ███► COMMANDS CONFIG ◄███ ]]
--
wx.Commands = {
    ["Status"] = "status",
    ["Here"] = "here",
    ["Advertisement"] = "ad",
    ["EMS"] = "ems",
    ["Police"] = "police",
    ["Sheriff"] = "sheriff",
    ["Blackmarket"] = "bm",
    ["Twitter"] = "tweet",
    ["Staff Announcement"] = "staff",
    ["Job"] = "job",
}

--[[ ███► COMMAND SUGGESTIONS ◄███ ]]
--
wx.Suggestions = {
    ["/me"] = {
        description = "Visualizza un'azione del personaggio",
        argument = { ["MESSAGE"] = "[TESTO]" },
    },
    ["/do"] = {
        description = "Descrive una situazione o uno stato visibile",
        argument = { ["MESSAGE"] = "[TESTO]" },
    },
    ["/" .. wx.Commands["Advertisement"]] = {
        description = "Pubblica un annuncio globale per tutti (costo: $" .. wx.AdCost .. ")",
        argument = { ["MESSAGE"] = "[TESTO]" },
    },
    ["/report"] = {
        description = "Contatta lo staff per segnalazioni",
        argument = { ["REPORT CONTENT"] = "Descrivi il problema o l'abuso" },
    },
    ["/dm"] = {
        description = "[STAFF] Messaggio privato a un giocatore",
        argument = { ["ID"] = "ID del giocatore" },
    },
}

--[[ ███► JOBS CONFIG ◄███ ]]
--
wx.Jobs = {
    ["LSPD"] = "police",
    ["EMS"] = "ambulance",
    ["LSSD"] = "sheriff",
}

--[[ ███► STAFF GROUPS ◄███ ]]
--
wx.AdminGroups = {
    ["admin"] = true,
    ["mod"] = true,
    ["owner"] = true,
    ["staff"] = true,
    ["trial"] = true,
}

--[[ ███► NOTIFICATION FUNCTION ◄███ ]]
--
Notify = function(title, desc)
    lib.notify({
        title = title,
        description = desc,
        position = "top",
        style = {
            backgroundColor = "#1E1E2E",
            color = "#C1C2C5",
            [".description"] = {
                color = "#909296",
            },
        },
        icon = "comments",
        iconColor = "#457b9d",
    })
end
