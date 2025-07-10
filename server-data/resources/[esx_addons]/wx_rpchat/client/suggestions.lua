CreateThread(function()
    for command, options in pairs(wx.Suggestions or {}) do
        local args = {}

        for name, help in pairs(options.argument or {}) do
            table.insert(args, {
                name = name,
                help = help,
            })
        end

        TriggerEvent("chat:addSuggestion", command, options.description or "", args)
    end
end)
