UIMenuPercentagePanel = setmetatable({}, UIMenuPercentagePanel)
UIMenuPercentagePanel.__index = UIMenuPercentagePanel
UIMenuPercentagePanel.__call = function() return "UIMenuPanel", "UIMenuPercentagePanel" end

function UIMenuPercentagePanel.New(MinText, MaxText)
	_UIMenuPercentagePanel = {
		Data = {
			Enabled = true,
		},
		Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 76),
		ActiveBar = UIResRectangle.New(0, 0, 413, 10, 245, 245, 245, 255),
		BackgroundBar = UIResRectangle.New(0, 0, 413, 10, 87, 87, 87, 255),
		Text = {
			Min = UIResText.New(MinText or "0%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
			Max = UIResText.New("100%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
			Title = UIResText.New(MaxText or "Opacity", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
		},
		Audio = {Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil},
		ParentItem = nil,
	}

	return setmetatable(_UIMenuPercentagePanel, UIMenuPercentagePanel)
end

function UIMenuPercentagePanel:SetParentItem(Item) -- required
	if Item() == "UIMenuItem" then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end

function UIMenuPercentagePanel:Enabled(Enabled)
	if type(Enabled) == "boolean" then
		self.Data.Enabled = Enabled
	else
		return self.Data.Enabled
	end
end

function UIMenuPercentagePanel:Position(Y) -- required
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        self.ActiveBar:Position(ParentOffsetX + (ParentOffsetWidth/2) + 9, 50 + Y)
        self.BackgroundBar:Position(ParentOffsetX + (ParentOffsetWidth/2) + 9, 50 + Y)
        self.Text.Min:Position(ParentOffsetX + (ParentOffsetWidth/2) + 25, 15 + Y)
        self.Text.Max:Position(ParentOffsetX + (ParentOffsetWidth/2) + 398, 15 + Y)
        self.Text.Title:Position(ParentOffsetX + (ParentOffsetWidth/2) + 215.5, 15 + Y)
    end
end

function UIMenuPercentagePanel:Percentage(Value)
	if tonumber(Value) then
		local Percent = ((Value < 0.0) and 0.0) or ((Value > 1.0) and 1.0 or Value)
		self.ActiveBar:Size(self.BackgroundBar.Width * Percent, self.ActiveBar.Height)
	else
	    local SafeZone = {X = 0, Y = 0}
	    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
	       SafeZone = GetSafeZoneBounds()
	    end
	    
		local Progress = (math.round(GetControlNormal(0, 239) * 1920) - SafeZone.X) - self.ActiveBar.X
		return math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413))/self.BackgroundBar.Width, 2)
	end
end

function UIMenuPercentagePanel:UpdateParent(Percentage)
	local _, ParentType = self.ParentItem()
	if ParentType == "UIMenuListItem" then
		local PanelItemIndex = self.ParentItem:FindPanelItem()
		if PanelItemIndex then
			self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = Percentage
			self.ParentItem:Index(PanelItemIndex)
			self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
			self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
		else
			local PanelIndex = self.ParentItem:FindPanelIndex(self)
			for Index = 1, #self.ParentItem.Items do
				if type(self.ParentItem.Items[Index]) == "table" then
					if not self.ParentItem.Items[Index].Panels then self.ParentItem.Items[Index].Panels = {} end
					self.ParentItem.Items[Index].Panels[PanelIndex] = Percentage
				else
					self.ParentItem.Items[Index] = {Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = {[PanelIndex] = Percentage}}
				end
			end
			self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
			self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)		
		end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Percentage)
	end
end

function UIMenuPercentagePanel:Functions()

    local SafeZone = {X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
       SafeZone = GetSafeZoneBounds()
    end

    if IsMouseInBounds(self.BackgroundBar.X + SafeZone.X, self.BackgroundBar.Y - 4 + SafeZone.Y, self.BackgroundBar.Width, self.BackgroundBar.Height + 8) then
        if IsDisabledControlJustPressed(0, 24) then
            if not self.Pressed then
                self.Pressed = true
                Citizen.CreateThread(function()
                    self.Audio.Id = GetSoundId()
                    PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X + SafeZone.X, self.BackgroundBar.Y - 4 + SafeZone.Y, self.BackgroundBar.Width, self.BackgroundBar.Height + 8) do
                        Citizen.Wait(0)
                        local Progress = (math.round(GetControlNormal(0, 239) * 1920) - SafeZone.X) - self.ActiveBar.X
                        self.ActiveBar:Size(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)), self.ActiveBar.Height)
                    end
                    StopSound(self.Audio.Id)
                    ReleaseSoundId(self.Audio.Id)
                    self.Pressed = false
                end)
                Citizen.CreateThread(function()
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X + SafeZone.X, self.BackgroundBar.Y - 4 + SafeZone.Y, self.BackgroundBar.Width, self.BackgroundBar.Height + 8) do
                        Citizen.Wait(75)
                        local Progress = (math.round(GetControlNormal(0, 239) * 1920) - SafeZone.X) - self.ActiveBar.X
                        self:UpdateParent(math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413))/self.BackgroundBar.Width, 2))
                    end
                end)
            end
        end
    end
end

function UIMenuPercentagePanel:Draw() -- required
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 76)
        self.Background:Draw()
        self.BackgroundBar:Draw()
        self.ActiveBar:Draw()
        self.Text.Min:Draw()
        self.Text.Max:Draw()
        self.Text.Title:Draw()
        self:Functions()
    end
end