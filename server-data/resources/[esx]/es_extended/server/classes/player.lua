local GetPlayerPed = GetPlayerPed
local GetEntityCoords = GetEntityCoords

function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, name, coords, metadata)
	local targetOverrides = Config.PlayerFunctionOverride and Core.PlayerFunctionOverrides[Config.PlayerFunctionOverride] or {}
	
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	self.metadata = metadata
	if Config.Multichar then self.license = 'license'.. identifier:sub(identifier:find(':'), identifier:len()) else self.license = 'license:'..identifier end

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
	
	local stateBag = Player(self.source).state
	stateBag:set("identifier", self.identifier, true)
	stateBag:set("license", self.license, true)
	stateBag:set("job", self.job, true)
	stateBag:set("group", self.group, true)
	stateBag:set("name", self.name, true)
	stateBag:set("metadata", self.metadata, true)

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

    ---Sets the current player coords
    ---@param coords table | vector3 | vector4
    function self.setCoords(coords)
        local ped = GetPlayerPed(self.source)
        local vector = vector4(coords?.x, coords?.y, coords?.z, coords?.w or coords?.heading or 0.0)

        if not vector then return end

        SetEntityCoords(ped, vector.x, vector.y, vector.z, false, false, false, false)
        SetEntityHeading(ped, vector.w)
    end

	function self.getCoords(vector)
		local ped = GetPlayerPed(self.source)
		local coords = GetEntityCoords(ped)

		if vector then
			return coords
		else
			return {
				x = coords.x,
				y = coords.y,
				z = coords.z,
			}
		end
	end

    ---Kicks the current player out with the specified reason
    ---@param reason? string
    function self.kick(reason)
        DropPlayer(tostring(self.source), reason --[[@as string]])
    end

    ---Sets the current player money to the specified value
    ---@param money integer | number
    ---@return boolean
    function self.setMoney(money)
        money = ESX.Math.Round(money)
        return self.setAccountMoney("money", money)
    end

    ---Gets the current player money value
    ---@return integer | number
    function self.getMoney()
        return self.getAccount("money")?.money
    end

    ---Adds the specified value to the current player money
    ---@param money integer | number
    ---@param reason? string
    ---@return boolean
    function self.addMoney(money, reason)
        money = ESX.Math.Round(money)
        return self.addAccountMoney("money", money, reason)
    end

    ---Removes the specified value from the current player money
    ---@param money integer | number
    ---@param reason? string
    ---@return boolean
    function self.removeMoney(money, reason)
        money = ESX.Math.Round(money)
        return self.removeAccountMoney("money", money, reason)
    end

    ---Gets the current player identifier
    ---@return string
    function self.getIdentifier()
        return self.identifier
    end

	function self.setGroup(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
		self.group = newGroup
		Player(self.source).state:set("group", self.group, true)
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
	end

	function self.getGroup()
		return self.group
	end

	function self.set(k, v)
		self.variables[k] = v
		Player(self.source).state:set(k, v, true)
	end

	function self.get(k)
		return self.variables[k]
	end

	function self.getAccounts(minimal)
		if not minimal then
			return self.accounts
		end

		local minimalAccounts = {}

		for i=1, #self.accounts do
			minimalAccounts[self.accounts[i].name] = self.accounts[i].money
		end

		return minimalAccounts
	end

	function self.getAccount(account)
		for i=1, #self.accounts do
			if self.accounts[i].name == account then
				return self.accounts[i]
			end
		end
	end

	function self.getInventory(minimal)
		if minimal then
			local minimalInventory = {}

			for _, v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		end

		return self.inventory
	end

	function self.getJob()
		return self.job
	end

	function self.getLoadout(minimal)
		if not minimal then
			return self.loadout
		end
		local minimalLoadout = {}

		for _,v in ipairs(self.loadout) do
			minimalLoadout[v.name] = {ammo = v.ammo}
			if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

			if #v.components > 0 then
				local components = {}

				for _,component in ipairs(v.components) do
					if component ~= 'clip_default' then
						components[#components + 1] = component
					end
				end

				if #components > 0 then
					minimalLoadout[v.name].components = components
				end
			end
		end

		return minimalLoadout
	end

	function self.getName()
		return self.name
	end

	function self.setName(newName)
		self.name = newName
		Player(self.source).state:set("name", self.name, true)
	end

	function self.setAccountMoney(accountName, money, reason)
		reason = reason or 'unknown'
		if not tonumber(money) then
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
			return
		end
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				money = account.round and ESX.Math.Round(money) or money
				self.accounts[account.index].money = money

				self.triggerEvent('esx:setAccountMoney', account)
				TriggerEvent('esx:setAccountMoney', self.source, accountName, money, reason)
			else
				print(('[^1ERROR^7] Tried To Set Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
			end
		else
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
		end
	end

	function self.addAccountMoney(accountName, money, reason)
		reason = reason or 'Unknown'
		if not tonumber(money) then
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
			return
		end
		if money > 0 then
			local account = self.getAccount(accountName)
			if account then
				money = account.round and ESX.Math.Round(money) or money
				self.accounts[account.index].money += money

				self.triggerEvent('esx:setAccountMoney', account)
				TriggerEvent('esx:addAccountMoney', self.source, accountName, money, reason)
			else
				print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
			end
		else
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
		end
	end

	---Removes money from the specified account of the current player
    ---@param accountName string
    ---@param money integer | number
    ---@param reason? string
    ---@return boolean
    function self.removeAccountMoney(accountName, money, reason)
        money = tonumber(money) --[[@as number]]
        reason = reason or "Unknown"

        if not money or money <= 0 then
            print(("[^1ERROR^7] Tried to remove account ^5%s^0 for Player ^5%s^0 with an invalid value -> ^5%s^7"):format(accountName, self.playerId, money))
            return false
        end

        local account = self.getAccount(accountName)

        if not account then
            print(("[^1ERROR^7] Tried to remove money from an invalid account ^5%s^0 for Player ^5%s^0"):format(accountName, self.playerId))
            return false
        end

        money = account.round and ESX.Math.Round(money) or money
        self.accounts[account.index].money = self.accounts[account.index].money - money

        TriggerEvent("esx:removeAccountMoney", self.source, accountName, money, reason)
        self.triggerSafeEvent("esx:setAccountMoney", {account = account, accountName = accountName, money = self.accounts[account.index].money, reason = reason})

        return true
    end

    ---Gets the specified item data from the current player
    ---@param itemName string
    ---@return table?
    function self.getInventoryItem(itemName)
        local itemData

        for _, item in ipairs(self.inventory) do
            if item.name == itemName then
                itemData = item
                break
            end
        end

        return itemData
    end

    ---Adds the specified item to the current player
    ---@param itemName string
    ---@param itemCount? integer | number defaults to 1 if not provided
    ---@return boolean
    function self.addInventoryItem(itemName, itemCount)
        local item = self.getInventoryItem(itemName)

        if not item then return false end

        itemCount = type(itemCount) == "number" and ESX.Math.Round(itemCount) or 1
        item.count += itemCount
        self.weight += (item.weight * itemCount)

        TriggerEvent("esx:onAddInventoryItem", self.source, item.name, item.count)
        self.triggerSafeEvent("esx:addInventoryItem", {itemName = item.name, itemCount = item.count})

        return true
    end

	---Removes the specified item from the current player
    ---@param itemName string
    ---@param itemCount? integer | number defaults to 1 if not provided
    ---@return boolean
    function self.removeInventoryItem(itemName, itemCount)
        local item = self.getInventoryItem(itemName)

        if not item then return false end

        itemCount = type(itemCount) == "number" and ESX.Math.Round(itemCount) or 1

        local newCount = item.count - itemCount

        if newCount < 0 then print(("[^1ERROR^7] Tried to remove non-existance count(%s) of %s item for Player ^5%s^0"):format(itemCount, itemName, self.playerId)) return false end

        item.count = newCount
        self.weight = self.weight - (item.weight * itemCount)

        TriggerEvent("esx:onRemoveInventoryItem", self.source, item.name, item.count)
        self.triggerSafeEvent("esx:removeInventoryItem", {itemName = item.name, itemCount = item.count})

        return true
    end

    ---Set the specified item count for the current player
    ---@param itemName string
    ---@param itemCount integer | number
    ---@return boolean
    function self.setInventoryItem(itemName, itemCount)
        local item = self.getInventoryItem(itemName)
        itemCount = type(itemCount) == "number" and ESX.Math.Round(itemCount) --[[@as number]]

        if not item or not itemCount or itemCount <= 0 then return false end

        return itemCount > item.count and self.addInventoryItem(item.name, itemCount - item.count) or self.removeInventoryItem(item.name, item.count - itemCount)
    end

    ---Gets the current player inventory weight
    ---@return integer | number
    function self.getWeight()
        return self.weight
    end

    ---Gets the current player max inventory weight
    ---@return integer | number
    function self.getMaxWeight()
        return self.maxWeight
    end

    ---Sets the current player max inventory weight
    ---@param newWeight integer | number
    function self.setMaxWeight(newWeight)
        self.maxWeight = newWeight
        self.triggerSafeEvent("esx:setMaxWeight", {maxWeight = newWeight}, {server = true, client = true})
    end

    ---Checks if the current player does have enough space in inventory to carry the specified item count(s)
    ---@param itemName string
    ---@param itemCount integer | number
    ---@return boolean
    function self.canCarryItem(itemName, itemCount)
        if not ESX.Items[itemName] then print(("[^3WARNING^7] Item ^5'%s'^7 was used but does not exist!"):format(itemName)) return false end

        local currentWeight, itemWeight = self.weight, ESX.Items[itemName].weight
        local newWeight = currentWeight + (itemWeight * itemCount)

        return newWeight <= self.maxWeight
    end

    ---Checks if the current player does have enough space in inventory to carry the specified item count(s)
    ---@param itemName string
    ---@param itemCount integer | number
    ---@return boolean
    function self.canCarryItem(itemName, itemCount)
        if not ESX.Items[itemName] then print(("[^3WARNING^7] Item ^5'%s'^7 was used but does not exist!"):format(itemName)) return false end

        local currentWeight, itemWeight = self.weight, ESX.Items[itemName].weight
        local newWeight = currentWeight + (itemWeight * itemCount)

        return newWeight <= self.maxWeight
    end

	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	function self.setMaxWeight(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	function self.setJob(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job, lastJob)
			Player(self.source).state:set("job", self.job, true)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, job))
		end
	end

	function self.addWeapon(weaponName, ammo)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			GiveWeaponToPed(GetPlayerPed(self.source), joaat(weaponName), ammo, false, false)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	function self.addWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					self.loadout[loadoutNum].components[#self.loadout[loadoutNum].components + 1] = weaponComponent
					local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
					GiveWeaponComponentToPed(GetPlayerPed(self.source), joaat(weaponName), componentHash)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	---Adds ammo to the current player's specified weapon
    ---@param weaponName string
    ---@param ammoCount integer | number
    ---@return boolean
    function self.addWeaponAmmo(weaponName, ammoCount)
        local _, weapon = self.getWeapon(weaponName)

        if not weapon then return false end

        weapon.ammo += ammoCount
        SetPedAmmo(GetPlayerPed(self.source), joaat(weaponName), weapon.ammo)

        return true
    end

    ---Sets ammo to the current player's specified weapon
    ---@param weaponName string
    ---@param ammoCount integer | number
    ---@return boolean
    function self.updateWeaponAmmo(weaponName, ammoCount)
        local _, weapon = self.getWeapon(weaponName)

        if not weapon then return false end

        weapon.ammo = ammoCount
        SetPedAmmo(GetPlayerPed(self.source), joaat(weaponName), weapon.ammo)

        return true
    end

	---Sets tint to the current player's specified weapon
    ---@param weaponName string
    ---@param weaponTintIndex integer | number
    ---@return boolean
    function self.setWeaponTint(weaponName, weaponTintIndex)
        local loadoutNum, weapon = self.getWeapon(weaponName)

        if not weapon then return false end

        local _, weaponObject = ESX.GetWeapon(weaponName)

        if not weaponObject?.tints or weaponObject?.tints?[weaponTintIndex] then return false end

        self.loadout[loadoutNum].tintIndex = weaponTintIndex

        self.triggerSafeEvent("esx:setWeaponTint", {weaponName = weaponName, weaponTintIndex = weaponTintIndex})
        self.triggerSafeEvent("esx:addInventoryItem", {itemName = weaponObject.tints[weaponTintIndex], itemCount = false, showNotification = true})

        return true
    end

    ---Gets the tint index of the current player's specified weapon
    ---@param weaponName any
    ---@return integer | number
    function self.getWeaponTint(weaponName)
        local _, weapon = self.getWeapon(weaponName)

        return weapon?.tintIndex or 0
    end

	function self.removeWeapon(weaponName)
		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for _,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName)
			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	function self.removeWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

    ---Removes ammo from the current player's specified weapon
    ---@param weaponName string
    ---@param ammoCount integer | number
    ---@return boolean
    function self.removeWeaponAmmo(weaponName, ammoCount)
        local _, weapon = self.getWeapon(weaponName)

        if not weapon then return false end

        weapon.ammo = weapon.ammo - ammoCount
        self.updateWeaponAmmo(weaponName, weapon.ammo)

        return true
    end

	---Checks if the current player has the specified component for the weapon
    ---@param weaponName any
    ---@param weaponComponent any
    ---@return boolean
    function self.hasWeaponComponent(weaponName, weaponComponent)
        local _, weapon = self.getWeapon(weaponName)

        if weapon then
            for _, v in ipairs(weapon.components) do
                if v == weaponComponent then
                    return true
                end
            end
        end

        return false
    end

	function self.hasWeapon(weaponName)
		for _,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

    ---Checks if the current player has the specified item
    ---@param itemName string
    ---@return false | table, integer | number | nil
    function self.hasItem(itemName)
        for _, v in ipairs(self.inventory) do
            if (v.name == itemName) and (v.count >= 1) then
                return v, v.count
            end
        end

        return false
    end

	function self.getWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end
	end

	function self.showNotification(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	function self.showAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
		self.triggerEvent('esx:showAdvancedNotification', sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	end

	function self.showHelpNotification(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	function self.getMeta(index, subIndex)
		if index then

			if type(index) ~= "string" then
				return print("[^1ERROR^7] xPlayer.getMeta ^5index^7 should be ^5string^7!")
			end

			if self.metadata[index] then

				if subIndex and type(self.metadata[index]) == "table" then
					local _type = type(subIndex)

					if _type == "string" then
						if self.metadata[index][subIndex] then
							return self.metadata[index][subIndex]
						end
						return
					end

					if _type == "table" then
						local returnValues = {}
						for i = 1, #subIndex do
							if self.metadata[index][subIndex[i]] then
								returnValues[subIndex[i]] = self.metadata[index][subIndex[i]]
							else
								print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not esxist on ^5%s^7!"):format(subIndex[i], index))
							end
						end

						return returnValues
					end

				end

				return self.metadata[index]
			else
				return print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not exist!"):format(index))
			end

		end

		return self.metadata
	end

	function self.setMeta(index, value, subValue)
		if not index then
			return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 is Missing!")
		end

		if type(index) ~= "string" then
			return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 should be ^5string^7!")
		end

		if not value then
			return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 is Missing!"):format(value))
		end

		local _type = type(value)

		if not subValue then

			if _type ~= "number" and _type ~= "string" and _type ~= "table" then
				return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7!"):format(value))
			end

			self.metadata[index] = value
		else

			if _type ~= "string" then
				return print(("[^1ERROR^7] xPlayer.setMeta ^5value^7 should be ^5string^7 as a subIndex!"):format(value))
			end

			self.metadata[index][value] = subValue
		end


		self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
		Player(self.source).state:set('metadata', self.metadata, true)
	end

	function self.clearMeta(index)
		if not index then
			return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 is Missing!"):format(index))
		end

		if type(index) == 'table' then
			for _, val in pairs(index) do
				self.clearMeta(val)
			end

			return
		end

		if not self.metadata[index] then
			return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 not exist!"):format(index))
		end

		self.metadata[index] = nil
		self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
		Player(self.source).state:set('metadata', self.metadata, true)
	end

	for fnName,fn in pairs(targetOverrides) do
		self[fnName] = fn(self)
	end

	return self
end