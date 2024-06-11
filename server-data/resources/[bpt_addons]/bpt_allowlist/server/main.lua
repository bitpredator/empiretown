local allowList = {}

local function loadAllowList()
    allowList = {}

    local list = LoadResourceFile(GetCurrentResourceName(), "players.json")
    if list then
        allowList = json.decode(list)
    end
end

CreateThread(loadAllowList)

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local players = GetPlayers()
    if #players < Config.MinPlayer then
        return
    end

    deferrals.defer()

    local playerId, kickReason = source, TranslateCap("error")

    deferrals.update(TranslateCap("allowlist_check"))

    --Not for nothing was this 100 but even this is not the best solution.
    Wait(100)

    local identifier = ESX.GetIdentifier(playerId)

    if ESX.Table.SizeOf(allowList) == 0 then
        kickReason = "[BPT] " .. TranslateCap("allowlist_empty")
    elseif not identifier then
        kickReason = "[BPT] " .. TranslateCap("license_missing")
    elseif not allowList[identifier] then
        kickReason = "[BPT] " .. TranslateCap("not_allowlist")
    end

    if kickReason then
        return deferrals.done(kickReason)
    end

    deferrals.done()
end)

ESX.RegisterCommand("alrefresh", "admin", function(xPlayer, args)
    loadAllowList()
    print("[^2INFO^7] Allowlist ^5Refreshed^7!")
end, true, { help = TranslateCap("help_allowlist_load") })

ESX.RegisterCommand(
    "aladd",
    "admin",
    function(xPlayer, args, showError)
        local playerLicense = args.license:lower()

        if allowList[playerLicense] then
            showError("The player is already allowlisted on this server!")
        else
            allowList[playerLicense] = true
            SaveResourceFile(GetCurrentResourceName(), "players.json", json.encode(allowList))
            loadAllowList()
            return
        end
    end,
    true,
    {
        help = TranslateCap("help_allowlist_add"),
        validate = true,
        arguments = {
            { name = TranslateCap("license"), help = TranslateCap("help_license"), type = "string" },
        },
    }
)

ESX.RegisterCommand(
    "alremove",
    "admin",
    function(xPlayer, args, showError)
        local playerLicense = args.license:lower()

        if allowList[playerLicense] then
            allowList[playerLicense] = nil
            SaveResourceFile(GetCurrentResourceName(), "players.json", json.encode(allowList))
            loadAllowList()
        else
            showError(TranslateCap("identifier_not_allowlisted"))
            return
        end
    end,
    true,
    {
        help = TranslateCap("help_allowlist_remove"),
        validate = true,
        arguments = {
            { name = TranslateCap("license"), help = TranslateCap("help_license"), type = "string" },
        },
    }
)
