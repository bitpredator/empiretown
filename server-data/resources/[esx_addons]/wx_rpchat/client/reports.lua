local ESX = exports["es_extended"]:getSharedObject()
local cooldown = false

RegisterNetEvent("wx_rpchat:send", function(id, name, message)
    local sourceID = PlayerId()
    local playerID = GetPlayerFromServerId(id)

    ESX.TriggerServerCallback("wx_rpchat:getPlayerGroup", function(group)
        if playerID ~= sourceID and (message == nil or message == "") then
            return
        end

        if playerID == sourceID then
            if cooldown then
                showChatMessage("ERROR", "You can send only one report every 15 seconds", "#922a2a", "#c72f2f")
                return
            end

            cooldown = true
            SetTimeout(15000, function()
                cooldown = false
            end)

            if message == "" or message == nil then
                showChatMessage("ERROR", "Report content cannot be empty", "#922a2a", "#c72f2f")
            else
                showChatMessage("SUCCESS", "Thank you for your report, one of our active admins will try to resolve it asap!", "#31BA4C", "#2FD951")
            end
        elseif group ~= "user" and message ~= nil and message ~= "" then
            showChatMessage("NEW REPORT", message, "#922a2a", "#c72f2f", id, name)
        end
    end)
end)

--- Funzione di utilità per mostrare i messaggi in chat
function showChatMessage(title, message, bgColor, borderColor, id, name)
    TriggerEvent("chat:addMessage", {
        template = string.format(
            [[
            <div style="padding: 0.3vw; height: auto; margin: 0.5vw; background-color: #222228ec; border-radius: 10px; padding-top: 0.35vw; border: 0.11vw solid #414146; box-shadow: 0px 0px 11px rgba(158, 158, 158, 0.35)">
                %s
                <font style="font-size: 14px; padding-left: 5px; color: #c7c5c5; margin: auto; font-weight:400">%s:</font>
                <font class="message" style="font-size: 14px; color: #a8a7a7; margin: auto; font-weight:400">%s</font>
            </div>
        ]],
            id
                    and name
                    and string.format(
                        [[
            <font style="padding: 0.15vw; margin: 0.22vw; background-color: #626066; padding-left: 1%%; border-radius: 8px; border: #9e9e9e solid 0.11vw; font-size: 12px; box-shadow: 0px 0px 11px rgba(158, 158, 158, 0.55)">
                <font style="font-weight: 600;">ID: %s</font>
            </font>
        ]],
                        id
                    )
                or "",
            title or "",
            message or ""
        ),
        args = {},
    })
end
