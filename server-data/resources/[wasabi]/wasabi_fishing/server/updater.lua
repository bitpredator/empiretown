local curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = "wasabi_fishing"

if Config.checkForUpdates then
	CreateThread(function()
		if GetCurrentResourceName() ~= "wasabi_fishing" then
			resourceName = "wasabi_fishing (" .. GetCurrentResourceName() .. ")"
		end
	end)

	CreateThread(function()
		while true do
			PerformHttpRequest(
				"https://api.github.com/repos/wasabirobby/wasabi_fishing/releases/latest",
				CheckVersion,
				"GET"
			)
			Wait(3600000)
		end
	end)

	CheckVersion = function(err, responseText, headers)
		local repoVersion, repoURL, repoBody = GetRepoInformations()

		CreateThread(function()
			if curVersion ~= repoVersion then
				Wait(4000)
				print("^0[^3WARNING^0] " .. resourceName .. " is ^1NOT ^0up to date!")
				print("^0[^3WARNING^0] Your Version: ^2" .. curVersion .. "^0")
				print("^0[^3WARNING^0] Latest Version: ^2" .. repoVersion .. "^0")
				print("^0[^3WARNING^0] Get the latest Version from: ^2" .. repoURL .. "^0")
				print("^0[^3WARNING^0] Changelog:^0")
				print("^1" .. repoBody .. "^0")
			else
				Wait(4000)
				print("^0[^2INFO^0] " .. resourceName .. " is up to date! (^2" .. curVersion .. "^0)")
			end
		end)
	end

	GetRepoInformations = function()
		local repoVersion, repoURL, repoBody = nil, nil, nil

		PerformHttpRequest(
			"https://api.github.com/repos/wasabirobby/wasabi_fishing/releases/latest",
			function(err, response, headers)
				if err == 200 then
					local data = json.decode(response)

					repoVersion = data.tag_name
					repoURL = data.html_url
					repoBody = data.body
				else
					repoVersion = curVersion
					repoURL = "https://github.com/wasabirobby/wasabi_fishing"
				end
			end,
			"GET"
		)

		repeat
			Wait(50)
		until repoVersion and repoURL and repoBody

		return repoVersion, repoURL, repoBody
	end
end
