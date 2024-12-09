local vehicle

SetVehicleNeedsToBeHotwired(vehicle, false)
SetVehicleHasBeenOwnedByPlayer(vehicle, true)
SetEntityAsMissionEntity(vehicle, true, true)
SetVehicleIsStolen(vehicle, false)
SetVehicleIsWanted(vehicle, false)
SetVehRadioStation(vehicle, "OFF")
