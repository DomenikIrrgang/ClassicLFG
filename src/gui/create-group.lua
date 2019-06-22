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
ClassicLFG.QueueWindow.CreateGroup.Title:SetLabel(ClassicLFG.Locale["Title"] .. ":")
ClassicLFG.QueueWindow.CreateGroup.Title:SetMaxLetters(25)
ClassicLFG.QueueWindow.CreateGroup.Title:DisableButton(true)
ClassicLFG.QueueWindow.CreateGroup.Title.frame:Show()
ClassicLFG.QueueWindow.CreateGroup.Title:SetCallback("OnTextChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.Dungeon = ClassicLFG.AceGUI:Create("Dropdown")
ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame:SetParent(ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Title.frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Title.frame, "BOTTOMRIGHT", 0, -45)
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetText(ClassicLFG.Locale["Select Dungeon"])
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetLabel(ClassicLFG.Locale["Dungeon"] .. ":")
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetList(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetCallback("OnValueChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.Description = ClassicLFG.AceGUI:Create("MultiLineEditBox")
ClassicLFG.QueueWindow.CreateGroup.Description.frame:SetParent(ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Description:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.Description:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.frame, "BOTTOMRIGHT", -0, -100)
ClassicLFG.QueueWindow.CreateGroup.Description:SetLabel(ClassicLFG.Locale["Description"] .. ":")
ClassicLFG.QueueWindow.CreateGroup.Description:DisableButton(true)
ClassicLFG.QueueWindow.CreateGroup.Description:SetMaxLetters(120)
ClassicLFG.QueueWindow.CreateGroup.Description.frame:Show()
ClassicLFG.QueueWindow.CreateGroup.Description:SetCallback("OnTextChanged", ClassicLFG.QueueWindow.CreateGroup.DataEntered)

ClassicLFG.QueueWindow.CreateGroup.QueueButton = ClassicLFGButton(ClassicLFG.Locale["List Group"], ClassicLFG.QueueWindow.CreateGroup)
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

ClassicLFG.QueueWindow.CreateGroup.DequeueButton = ClassicLFGButton(ClassicLFG.Locale["Delist Group"], ClassicLFG.QueueWindow.CreateGroup)
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
	if (ClassicLFG.DungeonGroupManager:IsListed() and ClassicLFG.DungeonGroupManager.DungeonGroup.Hash == dungeonGroup.Hash) then
		PanelTemplates_DisableTab(ClassicLFG.QueueWindow, 1)
		ClassicLFG.QueueWindow.Tab_OnClick(_G[ClassicLFG.QueueWindow:GetName() .."Tab2"]);
		ClassicLFG.QueueWindow.CreateGroup.Title:SetText(dungeonGroup.Title)
		ClassicLFG.QueueWindow.CreateGroup.Description:SetText(dungeonGroup.Description)
		ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	end
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	PanelTemplates_DisableTab(ClassicLFG.QueueWindow, 1)
	ClassicLFG.QueueWindow.Tab_OnClick(_G[ClassicLFG.QueueWindow:GetName() .."Tab2"]);
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOM", -5, -30)
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	ClassicLFG.QueueWindow.CreateGroup.Title:SetText(dungeonGroup.Title)
	ClassicLFG.QueueWindow.CreateGroup.Description:SetText(dungeonGroup.Description)
	ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetText(ClassicLFG.Locale["Update Data"])
	ClassicLFG.QueueWindow.CreateGroup.DequeueButton:Show()
	ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(false)
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	PanelTemplates_EnableTab(ClassicLFG.QueueWindow, 1)
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
	if ((IsInGroup() and UnitIsGroupLeader("player")) or not IsInGroup()) then
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(false)
	else
		ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	end
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetText(ClassicLFG.Locale["List Group"])
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.frame, "BOTTOMRIGHT", 0, -30)
end)