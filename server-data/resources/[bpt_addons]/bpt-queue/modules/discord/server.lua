if Config.Discord then
    CreateThread(function()
        -- Function to get the roles of a Discord user
        function GetUserRoles(discordid)
            local data = nil
            local colonIndex = string.find(discordid, ":")
            discordid = string.sub(discordid, colonIndex + 1)

            local url = string.format("https://discordapp.com/api/guilds/%s/members/%s", Config.Discord.serverid, discordid)

            -- Callback function for HTTP request
            local function handleResponse(statusCode, response, headers)
                if statusCode == 200 then
                    response = json.decode(response)
                    data = response["roles"]
                elseif statusCode == 404 then
                    data = false
                else
                    -- Generic error handling for other HTTP status codes
                    print("[ERROR] Discord API Error: Status code " .. statusCode)
                    data = false
                end
            end

            -- Make asynchronous HTTP request
            PerformHttpRequest(url, handleResponse, "GET", "", {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bot " .. Config.Discord.bottoken,
            })

            -- Add a timeout to prevent code from waiting forever
            local timeout = GetGameTimer() + 5000 -- Timeout after 5 seconds
            while data == nil do
                if GetGameTimer() > timeout then
                    print("[ERROR] Timeout while fetching Discord roles.")
                    return false
                end
                Wait(0)
            end

            return data
        end

        exports("GetUserRoles", GetUserRoles)
    end)
end
