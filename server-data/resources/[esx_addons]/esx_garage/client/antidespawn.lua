local model, coords, heading
local vehicle = CreateVehicle(model, GetEntityCoords(coords), GetEntityHeading(heading), 1, 0, false, false)

SetVehicleNeedsToBeHotwired(vehicle, false)
SetVehicleHasBeenOwnedByPlayer(vehicle, true)
SetEntityAsMissionEntity(vehicle, true, true)
SetVehicleIsStolen(vehicle, false)
SetVehicleIsWanted(vehicle, false)
SetVehRadioStation(vehicle, 'OFF')