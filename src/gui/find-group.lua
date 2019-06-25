---------------------------------
-- Search Group - Filter
---------------------------------

ClassicLFG.QueueWindow.SearchGroup.Filter = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Dungeon"], ClassicLFG.QueueWindow.SearchGroup)
ClassicLFG.QueueWindow.SearchGroup.Filter.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup, "TOPLEFT", 0, 0);
ClassicLFG.QueueWindow.SearchGroup.Filter.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup, "TOPRIGHT", 0, -22)
ClassicLFG.QueueWindow.SearchGroup.Filter:SetMultiSelect(true)
ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons = ClassicLFGLinkedList()
ClassicLFG.QueueWindow.SearchGroup.Filter.InitFilterValues = function()
    ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons = ClassicLFGLinkedList()
    ClassicLFG.QueueWindow.SearchGroup.Filter:Reset()
    if (ClassicLFG.DB.profile.ShowAllDungeons) then
        ClassicLFG.QueueWindow.SearchGroup.Filter:SetItems(ClassicLFG:GetAllDungeonNames())
    else
        ClassicLFG.QueueWindow.SearchGroup.Filter:SetItems(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
    end
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:ToArray()))
end

ClassicLFG.QueueWindow.SearchGroup.Filter.Frame:SetScript("OnShow", function()
    ClassicLFG.QueueWindow.SearchGroup.Filter:InitFilterValues()
end)

ClassicLFG.QueueWindow.SearchGroup.Filter.OnValueChanged = function(key, checked, value)
    local index = ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:Contains(value)
	if (index ~= nil and checked == false) then
		ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:RemoveItem(index)
    end

    if (checked == true) then
		ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:AddItem(value)
	end
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:ToArray()))
end

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:ToArray()))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, ClassicLFG.QueueWindow.SearchGroup, function()
	ClassicLFG.QueueWindow.SearchGroup.List:SetDungeonGroups(ClassicLFG.GroupManager:FilterGroupsByDungeon(ClassicLFG.QueueWindow.SearchGroup.Filter.SelectedDungeons:ToArray()))
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
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup.Filter.Frame, "BOTTOMLEFT", 0, -3);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetClipsChildren(true);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:ClearAllPoints();
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.SearchGroup.ScrollFrame, "TOPRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.SearchGroup.ScrollFrame, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar.ScrollUpButton:ClearAllPoints()
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar.ScrollDownButton:ClearAllPoints()
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar.ThumbTexture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar.ThumbTexture:SetWidth(2)
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.ScrollBar.ThumbTexture:SetColorTexture(
    ClassicLFG.Config.PrimaryColor.Red,
    ClassicLFG.Config.PrimaryColor.Green,
    ClassicLFG.Config.PrimaryColor.Blue,
    ClassicLFG.Config.PrimaryColor.Alpha
)

ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child = CreateFrame("Frame", nil, ClassicLFG.QueueWindow.SearchGroup.ScrollFrame);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child:SetSize(ClassicLFG.QueueWindow.SearchGroup:GetWidth(), 20);
ClassicLFG.QueueWindow.SearchGroup.ScrollFrame:SetScrollChild(ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child);

---------------------------------
-- Search Group - List - Init
---------------------------------

ClassicLFG.QueueWindow.SearchGroup.List = CLassicLFGGroupList(ClassicLFG.QueueWindow.SearchGroup.ScrollFrame.Child, ClassicLFG.QueueWindow.SearchGroup:GetWidth(), 500)