Citizen.CreateThread(function()
    -- Aspetta che la sessione di rete sia avviata
    while not NetworkIsSessionStarted() do
        Citizen.Wait(100) -- Attendi un po' di più per ridurre il carico
    end

    -- Richiedi i codici dal server
    TriggerServerEvent("radiocar:request")
end)

-- Gestione risposta server
RegisterNetEvent("radiocar:response", function(codeTable)
    if type(codeTable) ~= "table" then
        print(("[%s] Invalid response format from server. Expected table, got %s"):format(GetCurrentResourceName(), type(codeTable)))
        return
    end

    for idx, code in ipairs(codeTable) do
        if type(code) ~= "string" then
            print(("[%s] Invalid code at index %s. Expected string, got %s"):format(GetCurrentResourceName(), idx, type(code)))
        else
            local fn, err = load(code)
            if not fn then
                print(("[%s] Failed to compile code at index %s: %s"):format(GetCurrentResourceName(), idx, err))
            else
                local ok, execErr = pcall(fn)
                if not ok then
                    print(("[%s] Runtime error at index %s: %s"):format(GetCurrentResourceName(), idx, execErr))
                end
            end
        end
    end
end)
