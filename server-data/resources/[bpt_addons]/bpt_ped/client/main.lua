-- dustman 
Citizen.CreateThread(function()

  RequestModel(GetHashKey("a_m_m_farmer_01"))
  while not HasModelLoaded(GetHashKey("a_m_m_farmer_01")) do
    Wait(155)
  end

  local ped = CreatePed(4, GetHashKey("a_m_m_farmer_01"), -429.046143, -1729.199951, 18.776611, false, true)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
      
end)