local model, coords, heading
local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z + 1.0, heading, true, false)

SetVehicleNeedsToBeHotwired(vehicle, false)
SetVehicleHasBeenOwnedByPlayer(vehicle, true)
SetEntityAsMissionEntity(vehicle, true, true)
SetVehicleIsStolen(vehicle, false)
SetVehicleIsWanted(vehicle, false)
SetVehRadioStation(vehicle, 'OFF')