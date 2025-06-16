Citizen.CreateThread(function()
    RequestIpl("gabz_mrpd_milo_")

    local interiorCoords = vector3(451.0129, -993.3741, 29.1718)
    local interiorID = GetInteriorAtCoords(interiorCoords.x, interiorCoords.y, interiorCoords.z)

    if IsValidInterior(interiorID) then
        for i = 1, 31 do
            local propName = string.format("v_gabz_mrpd_rm%d", i)
            EnableInteriorProp(interiorID, propName)
        end
        RefreshInterior(interiorID)
    end
end)
