-- Digital Store
Citizen.CreateThread(function()

  local ped = CreatePed(4, GetHashKey("s_f_y_clubbar_01"), 383.762634, -826.681335, 28.300000, false, true)
  FreezeEntityPosition(ped, true)
  SetEntityHeading(ped, 260.0 )
  SetEntityInvincible(ped, true)
  SetBlockingOfNonTemporaryEvents(ped, true)  
end)