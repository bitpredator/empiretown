RegisterServerEvent("chat:init")
RegisterServerEvent("chat:addTemplate")
RegisterServerEvent("chat:addMessage")
RegisterServerEvent("chat:addSuggestion")
RegisterServerEvent("chat:removeSuggestion")
RegisterServerEvent("_chat:messageEntered")
RegisterServerEvent("chat:clear")
RegisterServerEvent("__cfx_internal:commandFallback")

AddEventHandler("_chat:messageEntered", function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent("chatMessage", source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent("chatMessage", -1, author, { 255, 255, 255 }, message)
    end

    print(author .. ": " .. message)
end)

AddEventHandler("__cfx_internal:commandFallback", function(command)
    local name = GetPlayerName(source)

    TriggerEvent("chatMessage", source, name, "/" .. command)

    if not WasEventCanceled() then
        TriggerClientEvent("chatMessage", -1, name, { 255, 255, 255 }, "/" .. command)
    end

    CancelEvent()
end)
