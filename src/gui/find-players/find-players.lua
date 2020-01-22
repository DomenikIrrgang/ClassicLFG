---------------------------------
-- Search Group - Filter
---------------------------------

ClassicLFG.QueueWindow.SearchPlayers.Filter = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Dungeon"], ClassicLFG.QueueWindow.SearchPlayers)
ClassicLFG.QueueWindow.SearchPlayers.Filter.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchPlayers, "TOPLEFT", 0, 0);
ClassicLFG.QueueWindow.SearchPlayers.Filter.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchPlayers, "TOPRIGHT", 0, -22)
ClassicLFG.QueueWindow.SearchPlayers.Filter:SetMultiSelect(true)
ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons = ClassicLFGLinkedList()

ClassicLFG.Store:AddListener(ClassicLFG.Actions.ToggleShowAllDungeons, ClassicLFG.QueueWindow.SearchPlayers.Filter, function(self, action, state)
    self.SelectedDungeons = ClassicLFGLinkedList()
    self:Reset()
    self:UpdateDungeons()
	ClassicLFG.QueueWindow.SearchPlayers.List:SetDungeonGroups(ClassicLFG.PlayerManager:FilterPlayersByDungeon(ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:ToArray()))
end)

ClassicLFG.Store:AddListener(ClassicLFG.Actions.ChangePlayerLevel, ClassicLFG.QueueWindow.SearchPlayers.Filter, function(self, action, state)
    self:UpdateDungeons()
end)

function ClassicLFG.QueueWindow.SearchPlayers.Filter:UpdateDungeons()
    if (ClassicLFG.Store:GetState().Db.profile.ShowAllDungeons) then
        self:SetItems(ClassicLFG.DungeonManager:GetAllDungeonNames())
    else
        self:SetItems(ClassicLFG.DungeonManager:GetDungeonsByLevel((ClassicLFG.Store:GetState().Player.Level)))
    end
end

ClassicLFG.QueueWindow.SearchPlayers.Filter.OnValueChanged = function(key, checked, value)
    local index = ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:Contains(value)
	if (index ~= nil and checked == false) then
		ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:RemoveItem(index)
    end

    if (checked == true) then
		ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:AddItem(value)
	end
	ClassicLFG.QueueWindow.SearchPlayers.List:SetDungeonGroups(ClassicLFG.PlayerManager:FilterPlayersByDungeon(ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:ToArray()))
end

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonPlayerUpdated, ClassicLFG.QueueWindow.SearchPlayers, function()
	ClassicLFG.QueueWindow.SearchPlayers.List:SetDungeonGroups(ClassicLFG.PlayerManager:FilterPlayersByDungeon(ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerDelisted, ClassicLFG.QueueWindow.SearchPlayers, function()
	ClassicLFG.QueueWindow.SearchPlayers.List:SetDungeonGroups(ClassicLFG.PlayerManager:FilterPlayersByDungeon(ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerListed, ClassicLFG.QueueWindow.SearchPlayers, function()
	ClassicLFG.QueueWindow.SearchPlayers.List:SetDungeonGroups(ClassicLFG.PlayerManager:FilterPlayersByDungeon(ClassicLFG.QueueWindow.SearchPlayers.Filter.SelectedDungeons:ToArray()))
end)

---------------------------------
-- Search Group - ScrollFrame
---------------------------------

local function ScrollFrame_OnMouseWheel(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20);
    
    if (self:GetVerticalScrollRange() > 0) then
        self.ScrollBar:Show()
    else 
        self.ScrollBar:Hide()
    end
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame = CreateFrame("ScrollFrame", nil, ClassicLFG.QueueWindow.SearchPlayers, "UIPanelScrollFrameTemplate");
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchPlayers.Filter.Frame, "BOTTOMLEFT", 0, -3);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchPlayers, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame:SetClipsChildren(true);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar:ClearAllPoints();
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar:SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame, "TOPRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar.ScrollUpButton:ClearAllPoints()
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar.ScrollDownButton:ClearAllPoints()
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar.ThumbTexture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar.ThumbTexture:SetWidth(2)
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar.ThumbTexture:SetColorTexture(
    ClassicLFG.Config.PrimaryColor.Red,
    ClassicLFG.Config.PrimaryColor.Green,
    ClassicLFG.Config.PrimaryColor.Blue,
    ClassicLFG.Config.PrimaryColor.Alpha
)
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.ScrollBar:Hide()

ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.Child = CreateFrame("Frame", nil, ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.Child:SetSize(ClassicLFG.QueueWindow.SearchPlayers:GetWidth(), 20);
ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame:SetScrollChild(ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.Child);

---------------------------------
-- Search Group - List - Init
---------------------------------

ClassicLFG.QueueWindow.SearchPlayers.List = CLassicLFGPlayerList(ClassicLFG.QueueWindow.SearchPlayers.ScrollFrame.Child, ClassicLFG.QueueWindow.SearchPlayers:GetWidth(), 500)