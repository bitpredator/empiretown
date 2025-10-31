UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)
UIMenuProgressItem.__index = UIMenuProgressItem
UIMenuProgressItem.__call = function() return "UIMenuItem", "UIMenuProgressItem" end

function UIMenuProgressItem.New(Text, Items, Index, Description, Counter)
	if type(Items) ~= "table" then Items = {} end
	if Index == 0 then Index = 1 end
	local _UIMenuProgressItem = {
		Base = UIMenuItem.New(Text or "", Description or ""),
		Data = {
			Items = Items,
			Counter = tobool(Counter),
			Max = 407.5,
			Index = tonumber(Index) or 1,
		},
		Background = UIResRectangle.New(0, 0, 415, 20),
		Bar = UIResRectangle.New(0, 0, 407.5, 12.5),
		OnProgressChanged = function(menu, item, newindex) end,
		OnProgressSelected = function(menu, item, newindex) end,
	}

	_UIMenuProgressItem.Base.Rectangle.Height = 60
	_UIMenuProgressItem.Base.SelectedSprite.Height = 60

	if _UIMenuProgressItem.Data.Counter then
		_UIMenuProgressItem.Base:RightLabel(_UIMenuProgressItem.Data.Index.."/"..#_UIMenuProgressItem.Data.Items)
	else
		_UIMenuProgressItem.Base:RightLabel((type(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]) == "table") and tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index].Name) or tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]))
	end

	_UIMenuProgressItem.Bar.Width = _UIMenuProgressItem.Data.Index/#_UIMenuProgressItem.Data.Items * _UIMenuProgressItem.Data.Max

	return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
end

function UIMenuProgressItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuProgressItem:Position(Y)
	if tonumber(Y) then
		self.Base:Position(Y)
		self.Background:Position(8 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 177 + Y + self.Base._Offset.Y)
		self.Bar:Position(11.75 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 180.75 + Y + self.Base._Offset.Y)
	end
end

function UIMenuProgressItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

function UIMenuProgressItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

function UIMenuProgressItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuProgressItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuProgressItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self.Base._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self.Base._Offset.Y = tonumber(Y)
		end
	else
		return self.Base._Offset
	end
end

function UIMenuProgressItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.Text:Text(tostring(Text))
	else
		return self.Base.Text:Text()
	end
end

function UIMenuProgressItem:Index(Index)
	if tonumber(Index) then
		if tonumber(Index) > #self.Data.Items then
			self.Data.Index = 1
		elseif tonumber(Index) < 1 then
			self.Data.Index = #self.Data.Items
		else
			self.Data.Index = tonumber(Index)
		end

		if self.Data.Counter then
			self.Base:RightLabel(self.Data.Index.."/"..#self.Data.Items)
		else
			self.Base:RightLabel((type(self.Data.Items[self.Data.Index]) == "table") and tostring(self.Data.Items[self.Data.Index].Name) or tostring(self.Data.Items[self.Data.Index]))
		end

		self.Bar.Width = self.Data.Index/#self.Data.Items * self.Data.Max
	else
		return self.Data.Index
	end
end

function UIMenuProgressItem:ItemToIndex(Item)
	for i = 1, #self.Data.Items do
		if type(Item) == type(self.Data.Items[i]) and Item == self.Data.Items[i] then
			return i
		elseif type(self.Data.Items[i]) == "table" and (type(Item) == type(self.Data.Items[i].Name) or type(Item) == type(self.Data.Items[i].Value)) and (Item == self.Data.Items[i].Name or Item == self.Data.Items[i].Value) then
			return i
		end
	end
end

function UIMenuProgressItem:IndexToItem(Index)
	if tonumber(Index) then
		if tonumber(Index) == 0 then Index = 1 end
		if self.Data.Items[tonumber(Index)] then
			return self.Data.Items[tonumber(Index)]
		end
	end
end

function UIMenuProgressItem:SetLeftBadge()
	error("This item does not support badges")
end

function UIMenuProgressItem:SetRightBadge()
	error("This item does not support badges")
end

function UIMenuProgressItem:RightLabel()
	error("This item does not support a right label")
end

function UIMenuProgressItem:CalculateProgress(CursorX)
	local Progress = CursorX - self.Bar.X
	self:Index(math.round(#self.Data.Items * (((Progress >= 0 and Progress <= self.Data.Max) and Progress or ((Progress < 0) and 0 or self.Data.Max))/self.Data.Max)))
end

function UIMenuProgressItem:Draw()
	self.Base:Draw()

	if self.Base._Selected then
		self.Background:Colour(table.unpack(Colours.Black))
		self.Bar:Colour(table.unpack(Colours.White))
	else
		self.Background:Colour(table.unpack(Colours.White))
		self.Bar:Colour(table.unpack(Colours.Black))
	end

	self.Background:Draw()
	self.Bar:Draw()
end