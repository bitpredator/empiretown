CreateThread(function()
    if not HasStreamedTextureDictLoaded("BBN") then
        RegisterFontFile("BBN")
        -- Attendi che il font sia caricato (non obbligatorio, ma consigliato in contesti UI)
        local fontId = RegisterFontId("BBN")
        if fontId ~= -1 then
            print("[BBN Font] Successfully registered with ID:", fontId)
        else
            print("[BBN Font] Failed to register font.")
        end
    end
end)
