local ESX = exports["es_extended"]:getSharedObject()
local displayHeight = 1

-- Template di base
local function buildChatTemplate(id, label, labelStyle, messageTitle, messageContent)
    return {
        template = string.format(
            [[
            <div style="padding: 0.3vw; height: 1.5vw; margin: 0.5vw; background-color: #222228ec; border-radius: 10px; padding-top: 0.35vw; border: 0.11vw solid #414146; box-shadow: 0px 0px 11px rgba(158,158,158,0.35)">
                <font style="padding: 0.15vw; margin: 0.22vw; background-color: #626066; padding-left: 1%%; border-radius: 8px; border: #9e9e9e solid 0.11vw; font-size: 12px; box-shadow: 0px 0px 11px rgba(158,158,158,0.55)">
                    <b>ID: %s</b>
                </font>
                <font style="padding: 0.15vw; margin: 0.22vw; %s">
                    <b>%s</b>
                </font>
                <font style="font-size: 14px; padding-left: 5px; color: #c7c5c5;">%s:</font>
                <font class="message" style="font-size: 14px; color: #a8a7a7;">%s</font>
            </div>
        ]],
            id,
            labelStyle,
            label,
            messageTitle,
            messageContent
        ),
        args = {},
    }
end

local labelStyles = {
    ME = "background-color: #B05DCB; border: #CD4DF7 solid 0.11vw; box-shadow: 0px 0px 11px rgba(200, 90, 225, 0.55)",
    DO = "background-color: #D19035; border: #F0A53D solid 0.11vw; box-shadow: 0px 0px 11px rgba(255, 192, 50, 0.55)",
    TRY = "background-color: #42C1B1; border: #38E5CF solid 0.11vw; box-shadow: 0px 0px 11px rgba(77, 225, 225, 0.55)",
    DOC = "background-color: #DBAB3D; border: #F2BA3B solid 0.11vw; box-shadow: 0px 0px 11px rgba(255, 192, 50, 0.55)",
    ADMIN = "background-color: #922a2a; border: #c72f2f solid 0.11vw; box-shadow: 0px 0px 11px rgba(156, 21, 21, 0.55)",
}

-- Funzione per visualizzare messaggio se vicino
local function sendNearbyMessage(eventName, label, labelStyle)
    RegisterNetEvent(eventName, function(playerId, title, message)
        local sourceId = GetPlayerServerId(PlayerId())
        local target = GetPlayerFromServerId(playerId)
        if target == -1 then
            return
        end

        local srcPed, tgtPed = PlayerPedId(), GetPlayerPed(target)
        local srcCoords, tgtCoords = GetEntityCoords(srcPed), GetEntityCoords(tgtPed)
        if target == sourceId or #(srcCoords - tgtCoords) < 10.0 then
            local template = buildChatTemplate(sourceId, label, labelStyle, title, message)
            TriggerEvent("chat:addMessage", template)
        end
    end)
end

-- Applica i registri comuni
sendNearbyMessage("wx_rpchat:sendMe", "ME", labelStyles.ME)
sendNearbyMessage("wx_rpchat:sendDo", "DO", labelStyles.DO)
sendNearbyMessage("wx_rpchat:sendTry", "TRY", labelStyles.TRY)
sendNearbyMessage("wx_rpchat:sendDoc", "DOC", labelStyles.DOC)
