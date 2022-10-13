
local spawn = false					

AddEventHandler("playerSpawned", function () 
	if not spawn then
		ShutdownLoadingScreenNui()			
		spawn = true
	end
end)