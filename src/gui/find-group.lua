---------------------------------
-- Search Group - Filter
---------------------------------

ClassicLFG.QueueWindow.SearchGroup.SearchField = ClassicLFG.AceGUI:Create("Dropdown")
ClassicLFG.QueueWindow.SearchGroup.SearchField.frame:SetParent(ClassicLFG.QueueWindow.SearchGroup)
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup, "TOPLEFT", 0, -8);
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup, "TOPRIGHT", -5, -35)
--ClassicLFG.QueueWindow.SearchGroup.SearchField:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetMultiselect(true)
ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons = ClassicLFGLinkedList()
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetText(ClassicLFG.Locale["Select Dungeon"])
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetCallback("OnValueChanged", function(key, checked, value)
	local index = ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:Contains(value)
	if (index) then
		ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:RemoveItem(index)
	else
		ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:AddItem(value)
	end
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:ToArray()))
	ClassicLFG.QueueWindow.SearchGroup.SearchField.pullout:Close()
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons:ToArray()))
end)

---------------------------------
-- Search Group - ScrollFrame
---------------------------------

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

ClassicLFG.QueueWindow.SearchGroup.ScrollFrame = CreateFrame("ScrollFrame", nil, ClassicLFG.QueueWindow.SearchGroup, "UIPanelScrollFrameTemplate");
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup.SearchField.frame, "BOTTOMLEFT", 4, -1);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup, "BOTTOMRIGHT", -3, 4);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetClipsChildren(true);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:ClearAllPoints();
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup.ScrollFrame, "TOPRIGHT", -12, -18);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup.ScrollFrame, "BOTTOMRIGHT", -7, 18);

ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child = CreateFrame("Frame", nil, ClassicLFG.QueueWindow.SearchGroup.ScrollFrame);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child:SetSize(358, 20);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetScrollChild(ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child);

---------------------------------
-- Search Group - List - Init
---------------------------------

ClassicLFG.QueueWindow.SearchGroup.List = CLassicLFGGroupList(ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child, "TOP", 358, 500)