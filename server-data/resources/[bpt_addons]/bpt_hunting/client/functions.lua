DrawText3D = function(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local _ = table.unpack(GetGameplayCamCoords())
	local scale = 0.30

	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(true)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		DrawText(_x, _y)
		local _ = (string.len(text)) / 650
	end
end
