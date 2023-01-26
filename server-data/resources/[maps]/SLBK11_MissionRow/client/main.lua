CreateThread(function()
	LoadInterior(GetInteriorAtCoords(440.84, -983.14, 30.69))
end)

CreateThread(function()
  while true do 
   Wait(0)
   SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
	 SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
   local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	 ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
	 RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
  end
end)