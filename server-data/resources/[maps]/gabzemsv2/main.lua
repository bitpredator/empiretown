CreateThread(function()
    -- Carica l'IPL dell'ospedale Pillbox Hill (Gabz)
    RequestIpl("gabz_pillbox_milo_")

    -- Coordinate interne dell'ospedale
    local interiorCoords = vector3(311.2546, -592.4204, 42.32737)
    local interiorID = GetInteriorAtCoords(311.2546, -592.4204, 42.32737)

    -- Verifica che l'interior sia valido
    if IsValidInterior(interiorID) then
        -- Rimuove IPL vanilla per evitare conflitti con Gabz Pillbox
        local iplsToRemove = {
            "rc12b_fixed",
            "rc12b_destroyed",
            "rc12b_default",
            "rc12b_hospitalinterior_lod",
            "rc12b_hospitalinterior",
        }

        for _, ipl in ipairs(iplsToRemove) do
            RemoveIpl(ipl)
        end

        -- Rinfresca l'interior per applicare le modifiche
        RefreshInterior(interiorID)
    else
        print("[WARNING] Invalid interior ID for Gabz Pillbox coordinates!")
    end
end)
