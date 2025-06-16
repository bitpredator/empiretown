Citizen.CreateThread(function()
    RequestIpl("gabz_pillbox_milo_")

    local interiorCoords = vector3(311.2546, -592.4204, 42.32737)
    local interiorID = GetInteriorAtCoords(interiorCoords.x, interiorCoords.y, interiorCoords.z)

    if IsValidInterior(interiorID) then
        local iplsToRemove = {
            "rc12b_fixed",
            "rc12b_destroyed",
            "rc12b_default",
            "rc12b_hospitalinterior_lod",
            "rc12b_hospitalinterior",
        }

        for _, ipl in pairs(iplsToRemove) do
            RemoveIpl(ipl)
        end

        RefreshInterior(interiorID)
    end
end)
