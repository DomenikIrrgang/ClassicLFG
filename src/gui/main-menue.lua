---------------------------------
-- Window
---------------------------------

ClassicLFG.QueueWindow = CreateFrame("Frame", "ClassicLFGQueueWindow", UIParent, "UIPanelDialogTemplate")
ClassicLFG.QueueWindow:SetSize(400, 600)
ClassicLFG.QueueWindow:SetPoint("CENTER", UIParent, "CENTER")

---------------------------------
-- Window - Title
---------------------------------

ClassicLFG.QueueWindow.Title:ClearAllPoints();
ClassicLFG.QueueWindow.Title:SetFontObject("GameFontHighlight");
ClassicLFG.QueueWindow.Title:SetPoint("LEFT", ClassicLFGQueueWindowTitleBG, "LEFT", 6, 1);
ClassicLFG.QueueWindow.Title:SetText("ClassicLFG");

---------------------------------
-- Window - Tabs
---------------------------------

local function Tab_OnClick(self)
	for key in pairs(self:GetParent().Tabs) do
		self:GetParent().Tabs[key].content:Hide()
	end
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	self.content:Show()
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs;
	frame.Tabs = {}
	local contents = {};
	local frameName = frame:GetName();
	
	for i = 1, numTabs do	
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
		tab:SetID(i);
		tab:SetText(select(i, ...));
		tab:SetScript("OnClick", Tab_OnClick);
		
		tab.content = CreateFrame("Frame", nil, ClassicLFG.QueueWindow, nil)
		tab.content:SetPoint("TOPLEFT", ClassicLFGQueueWindowDialogBG, "TOPLEFT", 0, 0)
		tab.content:SetPoint("BOTTOMRIGHT", ClassicLFGQueueWindowDialogBG, "BOTTOMRIGHT", 0, 0)
		tab.content:Hide()
		
		table.insert(contents, tab.content);
		table.insert(frame.Tabs, tab)
		
		if (i == 1) then
			tab:SetPoint("TOPLEFT", ClassicLFG.QueueWindow, "BOTTOMLEFT", 5, 7);
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0);
		end	
	end
	
	Tab_OnClick(_G[frameName.."Tab1"]);
	
	return unpack(contents);
end

ClassicLFG.QueueWindow.SearchGroup, ClassicLFG.QueueWindow.CreateGroup = SetTabs(ClassicLFG.QueueWindow, 2, "Search Group", "Create Group")

---------------------------------
-- Search Group - Filter
---------------------------------

ClassicLFG.QueueWindow.SearchGroup.SearchField = ClassicLFG.AceGUI:Create("Dropdown")
ClassicLFG.QueueWindow.SearchGroup.SearchField.frame:SetParent(ClassicLFG.QueueWindow.SearchGroup)
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.SearchGroup, "TOPLEFT", 0, -8);
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.SearchGroup, "TOPRIGHT", -5, -35)
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetText("Select Dungeon")
--ClassicLFG.QueueWindow.SearchGroup.SearchField:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.SearchGroup.SearchField:SetMultiselect(true)
ClassicLFG.QueueWindow.SearchGroup.SearchField.SelectedDungeons = ClassicLFGLinkedList()
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

---------------------------------
-- Create Group
---------------------------------

function ClassicLFG.QueueWindow.CreateGroup:DataEntered()
	if (ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()] ~= nil and
	ClassicLFG.QueueWindow.CreateGroup.Title:GetText() ~= "" and
	ClassicLFG.QueueWindow.CreateGroup.Description:GetText() ~= "") then
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(false)
	else
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	end
end

function ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(disable)
	if (disable == false and (IsInGroup() == false or UnitIsGroupLeader("player") == true)) then
		ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetDisabled(disable)
	else
		ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetDisabled(true)
	end
end

function ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(disable)
	if (disable == false and (IsInGroup() == false or UnitIsGroupLeader("player") == true)) then
		ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetDisabled(disable)
	else
		ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetDisabled(true)
	end
end

ClassicLFG.QueueWindow.CreateGroup.Title = ClassicLFG.AceGUI:Create("EditBox")
ClassicLFG.QueueWindow.CreateGroup.Title.frame:SetParent(ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Title:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup, "TOPLEFT", 10, -8);
ClassicLFG.QueueWindow.CreateGroup.Title:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "TOPRIGHT", -13, -45)
ClassicLFG.QueueWindow.CreateGroup.Title:SetLabel("Title:")
ClassicLFG.QueueWindow.CreateGroup.Title:SetMaxLetters(25)
ClassicLFG.QueueWindow.CreateGroup.Title:DisableButton(true)
ClassicLFG.QueueWindow.CreateGroup.Title.frame:Show()
ClassicLFG.QueueWindow.CreateGroup.Title:SetCallback("OnTextChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.Dungeon = ClassicLFG.AceGUI:Create("Dropdown")
ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame:SetParent(ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Title.frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Title.frame, "BOTTOMRIGHT", 0, -45)
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetText("Select Dungeon")
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetLabel("Dungeon:")
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetCallback("OnValueChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.Description = ClassicLFG.AceGUI:Create("MultiLineEditBox")
ClassicLFG.QueueWindow.CreateGroup.Description.frame:SetParent(ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Description:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.Description:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame, "BOTTOMRIGHT", -0, -100)
ClassicLFG.QueueWindow.CreateGroup.Description:SetLabel("Description:")
ClassicLFG.QueueWindow.CreateGroup.Description:DisableButton(true)
ClassicLFG.QueueWindow.CreateGroup.Description:SetMaxLetters(120)
ClassicLFG.QueueWindow.CreateGroup.Description.frame:Show()
ClassicLFG.QueueWindow.CreateGroup.Description:SetCallback("OnTextChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.QueueButton = ClassicLFGButton("List Group", ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.CreateGroup.QueueButton.OnClick = function(self)
	if (ClassicLFG.DungeonGroupManager:IsListed()) then
		ClassicLFG.DungeonGroupManager:UpdateGroup(ClassicLFGDungeonGroup(
			ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()],
			ClassicLFGPlayer(),
			ClassicLFG.QueueWindow.CreateGroup.Title:GetText(),
			ClassicLFG.QueueWindow.CreateGroup.Description:GetText()
		))
	else
		ClassicLFG.DungeonGroupManager:ListGroup(ClassicLFG.DungeonGroupManager:InitGroup(
			ClassicLFG.QueueWindow.CreateGroup.Title:GetText(),
			ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()],
			ClassicLFG.QueueWindow.CreateGroup.Description:GetText()
		))
	end
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
end
ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)

ClassicLFG.QueueWindow.CreateGroup.DequeueButton = ClassicLFGButton("Delist Group", ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOM", 5, -8);
ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOMRIGHT", -0, -30)
ClassicLFG.QueueWindow.CreateGroup.DequeueButton.Frame:Hide()
ClassicLFG.QueueWindow.CreateGroup.DequeueButton.OnClick = function(self)
	ClassicLFG.DungeonGroupManager:DequeueGroup()
end

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame = CreateFrame("ScrollFrame", nil, ClassicLFG.QueueWindow.CreateGroup, "UIPanelScrollFrameTemplate");
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.QueueButton.Frame, "BOTTOMLEFT", 0, -5);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "BOTTOMRIGHT", -13, 0);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetClipsChildren(true);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:ClearAllPoints();
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame, "TOPRIGHT", -12, -18);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame, "BOTTOMRIGHT", -7, 18);

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child = CreateFrame("Frame", nil, ClassicLFG.QueueWindow.CreateGroup.ScrollFrame);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child:SetSize(358, 20);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetScrollChild(ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child);


ClassicLFG.QueueWindow.CreateGroup.ApplicantList = ClassicLFGApplicantList(ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child)
ClassicLFG.QueueWindow.CreateGroup.ApplicantList.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child, "BOTTOMLEFT", 0, 18);
ClassicLFG.QueueWindow.CreateGroup.ApplicantList.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "BOTTOMRIGHT", -35, 10)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	if (ClassicLFG.DungeonGroupManager:IsListed() and UnitIsGroupLeader(dungeonGroup.Leader.Name) == true) then
		PanelTemplates_DisableTab(ClassicLFG.QueueWindow, 1)
		Tab_OnClick(_G[ClassicLFG.QueueWindow:GetName() .."Tab2"]);
		ClassicLFG.QueueWindow.CreateGroup.Title:SetText(dungeonGroup.Title)
		ClassicLFG.QueueWindow.CreateGroup.Description:SetText(dungeonGroup.Description)
		ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	end
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	PanelTemplates_DisableTab(ClassicLFG.QueueWindow, 1)
	Tab_OnClick(_G[ClassicLFG.QueueWindow:GetName() .."Tab2"]);
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOM", -5, -30)
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	ClassicLFG.QueueWindow.CreateGroup.Title:SetText(dungeonGroup.Title)
	ClassicLFG.QueueWindow.CreateGroup.Description:SetText(dungeonGroup.Description)
	ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetText("Update Data")
	ClassicLFG.QueueWindow.CreateGroup.DequeueButton:Show()
	ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(false)
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	PanelTemplates_EnableTab(ClassicLFG.QueueWindow, 1)
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(false)
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetText("List Group")
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOMRIGHT", 0, -30)
	ClassicLFG.QueueWindow.CreateGroup.DequeueButton:Hide()
end)

ClassicLFG.QueueWindow.CreateGroup:RegisterEvent("PARTY_LEADER_CHANGED")
ClassicLFG.QueueWindow.CreateGroup:SetScript("OnEvent", function(_, event)
	if (event == "PARTY_LEADER_CHANGED") then
		if (UnitIsGroupLeader("player") == true or IsInGroup() == false) then
			ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(false)
		else
			ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(true)
			ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
		end
	end
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, ClassicLFG.QueueWindow.CreateGroup.QueueButton, function(self)
	self:SetDisabled(false)
end)

ClassicLFG.QueueWindow:Hide()