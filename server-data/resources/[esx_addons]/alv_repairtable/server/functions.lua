function GetJob(source)
    if ESX then
        return ESX.GetPlayerFromId(source).getJob().name
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)

        return Player.PlayerData.job.name
    elseif Ox then
        local player = Ox.getPlayer(source)

        return player.getGroup() -- Haven't used OX Core too much before, seeing from documentation that police and sheriff were stored as a group so that's what I'll assume is the job.
    end
end

function ChargePlayer(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeMoney(amount)
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)

        Player.Functions.RemoveMoney(amount)
    elseif Ox then
        -- No money support for Ox setup at current date.
    end
end

function DiscordLog(webhook, title, message, data)
    if GetResourceState("alv_lib") == "missing" then
        local color, userName, avatarUrl

        if data.color then
            color = data.color
        else
            color = 16711680
        end
        if data.username then
            userName = data.username
        else
            username = "Alv.gg"
        end
        if data.avatarUrl then
            avatarUrl = data.avatarUrl
        else
            avatarUrl = "https://ih1.redbubble.net/image.971270805.6405/gbrf,6x6,f,540x540-pad,450x450,f8f8f8.jpg"
        end

        local embed = {
            {
                ["color"] = color,
                ["title"] = title,
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "Alv.gg - 2023",
                },
            },
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({ username = userName, avatar_url = avatarUrl, embeds = embed }), { ["Content-Type"] = "application/json" })
    else
        exports["alv_lib"]:SendLog(webhook, title, message, {
            color = Discord.Color,
            username = Discord.Username,
            avatarUrl = Discord.AvatarURL,
        })
    end
end
