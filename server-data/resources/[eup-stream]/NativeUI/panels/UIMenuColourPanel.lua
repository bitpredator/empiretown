UIMenuColourPanel = setmetatable({}, UIMenuColourPanel)
UIMenuColourPanel.__index = UIMenuColourPanel
UIMenuColourPanel.__call = function() return "UIMenuPanel", "UIMenuColourPanel" end

function UIMenuColourPanel.New(Title, Colours)
	_UIMenuColourPanel = {
		Data = {
			Pagination = {
				Min = 1,
				Max = 8,
				Total = 8,
			},
			Index = 1000,
			Items = Colours,
			Title = Title or "Title",
			Enabled = true,
			Value = 1,
		},
		Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 112),
		Bar = {},
		LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 0, 30, 30),
		RightArrow = Sprite.New("commonmenu", "arrowright", 0, 0, 30, 30),
		SelectedRectangle = UIResRectangle.New(0, 0, 44.5, 8),
		Text = UIResText.New(Title.." (1 of "..#Colours..")" or "Title".." (1 of "..#Colours..")", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
		ParentItem = nil,
	}

	for Index = 1, #Colours do
		if Index < 10 then
			table.insert(_UIMenuColourPanel.Bar, UIResRectangle.New(0, 0, 44.5, 44.5, table.unpack(Colours[Index])))
		else
			break
		end
	end

	if #_UIMenuColourPanel.Data.Items ~= 0 then
		_UIMenuColourPanel.Data.Index = 1000 - (1000 % #_UIMenuColourPanel.Data.Items)
		_UIMenuColourPanel.Data.Pagination.Max = _UIMenuColourPanel.Data.Pagination.Total + 1
		_UIMenuColourPanel.Data.Pagination.Min = 0
	end
	return setmetatable(_UIMenuColourPanel, UIMenuColourPanel)
end

function UIMenuColourPanel:SetParentItem(Item) -- required
	if Item() == "UIMenuItem" then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end

function UIMenuColourPanel:Enabled(Enabled)
	if type(Enabled) == "boolean" then
		self.Data.Enabled = Enabled
	else
		return self.Data.Enabled
	end
end

function UIMenuColourPanel:Position(Y) -- required
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset

        self.Background:Position(ParentOffsetX, Y)
        for Index = 1, #self.Bar do
            self.Bar[Index]:Position(15 + (44.5 * (Index - 1)) + ParentOffsetX + (ParentOffsetWidth/2), 55 + Y)
        end
        self.SelectedRectangle:Position(15 + (44.5 * ((self:CurrentSelection() - self.Data.Pagination.Min) - 1)) + ParentOffsetX + (ParentOffsetWidth/2), 47 + Y)
        self.LeftArrow:Position(7.5 + ParentOffsetX + (ParentOffsetWidth/2), 15 + Y)
        self.RightArrow:Position(393.5 + ParentOffsetX + (ParentOffsetWidth/2), 15 + Y)
        self.Text:Position(215.5 + ParentOffsetX + (ParentOffsetWidth/2), 15 + Y)
    end
end

function UIMenuColourPanel:CurrentSelection(value, PreventUpdate)
    if tonumber(value) then
        if #self.Data.Items == 0 then
            self.Data.Index = 0
        end

        self.Data.Index = 1000000 - (1000000 % #self.Data.Items) + tonumber(value)

        if self:CurrentSelection() > self.Data.Pagination.Max then
            self.Data.Pagination.Min = self:CurrentSelection() - (self.Data.Pagination.Total + 1)
            self.Data.Pagination.Max = self:CurrentSelection()
        elseif self:CurrentSelection() < self.Data.Pagination.Min then
            self.Data.Pagination.Min = self:CurrentSelection() - 1
            self.Data.Pagination.Max = self:CurrentSelection() + (self.Data.Pagination.Total + 1)
        end

        self:UpdateSelection(PreventUpdate)
    else
        if #self.Data.Items == 0 then
            return 1
        else
            if self.Data.Index % #self.Data.Items == 0 then
                return 1
            else
                return self.Data.Index % #self.Data.Items + 1
            end
        end
    end
end

function UIMenuColourPanel:UpdateParent(Colour)
	local _, ParentType = self.ParentItem()
	if ParentType == "UIMenuListItem" then
		local PanelItemIndex = self.ParentItem:FindPanelItem()
		local PanelIndex = self.ParentItem:FindPanelIndex(self)
		if PanelItemIndex then
			self.ParentItem.Items[PanelItemIndex].Value[PanelIndex] = Colour
			self.ParentItem:Index(PanelItemIndex)
			self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
			self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
		else
			for Index = 1, #self.ParentItem.Items do
				if type(self.ParentItem.Items[Index]) == "table" then
					if not self.ParentItem.Items[Index].Panels then self.ParentItem.Items[Index].Panels = {} end
					self.ParentItem.Items[Index].Panels[PanelIndex] = Colour
				else
					self.ParentItem.Items[Index] = {Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = {[PanelIndex] = Colour}}
				end
			end
			self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
			self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)		
		end
	elseif ParentType == "UIMenuItem" then
		self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Colour)
	end
end

function UIMenuColourPanel:UpdateSelection(PreventUpdate)
    local CurrentSelection = self:CurrentSelection()
    if not PreventUpdate then
        self:UpdateParent(CurrentSelection)
    end
    self.SelectedRectangle:Position(15 + (44.5 * ((CurrentSelection - self.Data.Pagination.Min) - 1)) + self.ParentItem:Offset().X, self.SelectedRectangle.Y)
    for Index = 1, 9 do
        self.Bar[Index]:Colour(table.unpack(self.Data.Items[self.Data.Pagination.Min + Index]))
    end
    self.Text:Text(self.Data.Title.." ("..CurrentSelection.." of "..#self.Data.Items..")")
end

function UIMenuColourPanel:Functions()

    local SafeZone = {X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
	   SafeZone = GetSafeZoneBounds()
    end


	if IsMouseInBounds(self.LeftArrow.X + SafeZone.X, self.LeftArrow.Y + SafeZone.Y, self.LeftArrow.Width, self.LeftArrow.Height) then
		if IsDisabledControlJustPressed(0, 24) then
			if #self.Data.Items > self.Data.Pagination.Total + 1 then
				if self:CurrentSelection() <= self.Data.Pagination.Min + 1 then
					if self:CurrentSelection() == 1 then
						self.Data.Pagination.Min = #self.Data.Items - (self.Data.Pagination.Total + 1)
						self.Data.Pagination.Max = #self.Data.Items
						self.Data.Index = 1000 - (1000 % #self.Data.Items)
						self.Data.Index = self.Data.Index + (#self.Data.Items - 1)
						self:UpdateSelection()
					else
						self.Data.Pagination.Min = self.Data.Pagination.Min - 1
						self.Data.Pagination.Max = self.Data.Pagination.Max - 1
						self.Data.Index = self.Data.Index - 1
						self:UpdateSelection()
					end
				else
					self.Data.Index = self.Data.Index - 1
					self:UpdateSelection()
				end
			else
				self.Data.Index = self.Data.Index - 1
				self:UpdateSelection()
			end
		end
	end

	if IsMouseInBounds(self.RightArrow.X + SafeZone.X, self.RightArrow.Y + SafeZone.Y, self.RightArrow.Width, self.RightArrow.Height) then
		if IsDisabledControlJustPressed(0, 24) then
			if #self.Data.Items > self.Data.Pagination.Total + 1 then
				if self:CurrentSelection() >= self.Data.Pagination.Max then
					if self:CurrentSelection() == #self.Data.Items then
						self.Data.Pagination.Min = 0
						self.Data.Pagination.Max = self.Data.Pagination.Total + 1
						self.Data.Index = 1000 - (1000 % #self.Data.Items)
						self:UpdateSelection()
					else
						self.Data.Pagination.Max = self.Data.Pagination.Max + 1
						self.Data.Pagination.Min = self.Data.Pagination.Max - (self.Data.Pagination.Total + 1)
						self.Data.Index = self.Data.Index + 1
						self:UpdateSelection()
					end
				else
					self.Data.Index = self.Data.Index + 1
					self:UpdateSelection()
				end
			else
				self.Data.Index = self.Data.Index + 1
				self:UpdateSelection()
			end
		end
	end

	for Index = 1, #self.Bar do
		if IsMouseInBounds(self.Bar[Index].X + SafeZone.X, self.Bar[Index].Y + SafeZone.Y, self.Bar[Index].Width, self.Bar[Index].Height) then
			if IsDisabledControlJustPressed(0, 24) then
				self:CurrentSelection(self.Data.Pagination.Min + Index - 1)
			end
		end
	end
end

function UIMenuColourPanel:Draw() -- required
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 112)

        self.Background:Draw()
        self.LeftArrow:Draw()
        self.RightArrow:Draw()
        self.Text:Draw()
        self.SelectedRectangle:Draw()
        for Index = 1, #self.Bar do
            self.Bar[Index]:Draw()
        end
        self:Functions()
    end
end