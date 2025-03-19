function DebugPrint(msg)
    if Config.Debug then
        -- Using a timestamp to get more detailed information about when debugging is performed
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        print(string.format("^1[Debug] [%s]: ^2%s^0", timestamp, msg))
    end
end

if Config.DisableHardCap then
    -- Add a guard to prevent the event from being called multiple times accidentally
    local hardcapDisabled = false

    -- Event handler to prevent hardcap from starting
    AddEventHandler("onResourceStarting", function(resource)
        if resource == "hardcap" and not hardcapDisabled then
            -- Cancel launch of resource 'hardcap'
            CancelEvent()
            hardcapDisabled = true
            DebugPrint("Hardcap resource start has been canceled")
        end
    end)

    -- Create thread to stop 'hardcap' after 2 seconds, with error handling
    CreateThread(function()
        Wait(2000) -- Wait 2 seconds before stopping the resource

        -- Check if the 'hardcap' resource is active before trying to stop it
        if GetResourceState("hardcap") == "started" then
            StopResource("hardcap")
            DebugPrint("Hardcap has been stopped")
        else
            DebugPrint("Failed to stop Hardcap: Resource is not running")
        end
    end)
end
