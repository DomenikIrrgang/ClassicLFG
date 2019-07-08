---------------------------------
-- Create Group
---------------------------------

ClassicLFG.QueueWindow.CreateGroup:SetScript("OnShow", function(self, _, channel)
	ClassicLFG.QueueWindow.CreateGroup.AutoInvite:SetState(ClassicLFG.DB.profile.AutoInvite)
end)

function ClassicLFG.QueueWindow.CreateGroup:DataEntered()
	if (ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()] ~= nil and
	ClassicLFG.QueueWindow.CreateGroup.Title.Frame:GetText() ~= "" and
    ClassicLFG.QueueWindow.CreateGroup.Description.Frame:GetText() ~= "") then
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

ClassicLFG.QueueWindow.CreateGroup.Icon = ClassicLFGIcon("Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW", ClassicLFG.QueueWindow.CreateGroup, ClassicLFG.QueueWindow.CreateGroup:GetWidth(), 100)
ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup, "TOPLEFT", 0, 0);
ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "TOPRIGHT", 0, -ClassicLFG.QueueWindow.CreateGroup:GetWidth() / 2)
ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetDrawLayer("BORDER")

ClassicLFG.QueueWindow.CreateGroup.RoleIcons = {}
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps = ClassicLFGIconWithText(0, ClassicLFG.Role.DPS.Icon, ClassicLFG.QueueWindow.CreateGroup, 50, 50)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Icon:GetTexture():SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -20, -5)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Icon:GetTexture():SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -40, -25)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Icon:GetTexture():SetTexCoord(
    ClassicLFG.Role.DPS.Offset.Left,
    ClassicLFG.Role.DPS.Offset.Right,
    ClassicLFG.Role.DPS.Offset.Top,
    ClassicLFG.Role.DPS.Offset.Bottom)

ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer = ClassicLFGIconWithText(0, ClassicLFG.Role.HEALER.Icon, ClassicLFG.QueueWindow.CreateGroup, 50, 50)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Icon:GetTexture():SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -100, -5)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Icon:GetTexture():SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -120, -25)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Icon:GetTexture():SetTexCoord(
    ClassicLFG.Role.HEALER.Offset.Left,
    ClassicLFG.Role.HEALER.Offset.Right,
    ClassicLFG.Role.HEALER.Offset.Top,
    ClassicLFG.Role.HEALER.Offset.Bottom)

ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank = ClassicLFGIconWithText(0, ClassicLFG.Role.TANK.Icon, ClassicLFG.QueueWindow.CreateGroup, 50, 50)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Icon:GetTexture():SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -60, -5)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Icon:GetTexture():SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -80, -25)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Icon:GetTexture():SetTexCoord(
    ClassicLFG.Role.TANK.Offset.Left,
    ClassicLFG.Role.TANK.Offset.Right,
    ClassicLFG.Role.TANK.Offset.Top,
    ClassicLFG.Role.TANK.Offset.Bottom)

ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown = ClassicLFGIconWithText(0, ClassicLFG.Role.UNKNOWN.Icon, ClassicLFG.QueueWindow.CreateGroup, 50, 50)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Icon:GetTexture():SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -142, -7)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Icon:GetTexture():SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "TOPRIGHT", -158, -23)
ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Icon:GetTexture():SetTexCoord(
    ClassicLFG.Role.UNKNOWN.Offset.Left,
    ClassicLFG.Role.UNKNOWN.Offset.Right,
    ClassicLFG.Role.UNKNOWN.Offset.Top,
	ClassicLFG.Role.UNKNOWN.Offset.Bottom)
	
ClassicLFG.QueueWindow.CreateGroup.AutoInvite = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.CreateGroup, ClassicLFG.Locale["Auto Accept"])
ClassicLFG.QueueWindow.CreateGroup.AutoInvite.Frame:SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "BOTTOMRIGHT", -5, 25)
ClassicLFG.QueueWindow.CreateGroup.AutoInvite.Frame:SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "BOTTOMLEFT", 250, 5)
ClassicLFG.QueueWindow.CreateGroup.AutoInvite.OnValueChanged = function(_, value)
	ClassicLFG.DB.profile.AutoInvite = value
end

ClassicLFG.QueueWindow.CreateGroup.Title = ClassicLFGEditBox(nil, ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "BOTTOMLEFT", 0, -5);
ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Icon.Texture, "BOTTOMRIGHT", 0, -27)
ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetMaxLetters(25)
ClassicLFG.QueueWindow.CreateGroup.Title:SetPlaceholder(ClassicLFG.Locale["Title"])
ClassicLFG.QueueWindow.CreateGroup.Title.OnTextChanged = ClassicLFG.QueueWindow.CreateGroup.DataEntered

ClassicLFG.QueueWindow.CreateGroup.Dungeon = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Dungeon"], ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Dungeon.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Title.Frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.Dungeon.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Title.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetItems(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.CreateGroup.Dungeon.OnValueChanged = function(value)
    ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetTexture(ClassicLFG.Dungeon[value].Background)
    ClassicLFG.QueueWindow.CreateGroup.DataEntered()
end

ClassicLFG.QueueWindow.CreateGroup.Description = ClassicLFGEditBox(nil, ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Dungeon.Frame, "BOTTOMRIGHT", -0, -30)
ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetMaxLetters(120)
ClassicLFG.QueueWindow.CreateGroup.Description:SetPlaceholder(ClassicLFG.Locale["Description"])
ClassicLFG.QueueWindow.CreateGroup.Description.OnTextChanged = ClassicLFG.QueueWindow.CreateGroup.DataEntered

ClassicLFG.QueueWindow.CreateGroup.QueueButton = ClassicLFGButton(ClassicLFG.Locale["List Group"], ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.CreateGroup.QueueButton.OnClick = function(self)
	if (ClassicLFG.DungeonGroupManager:IsListed()) then
		ClassicLFG.DungeonGroupManager:UpdateGroup(ClassicLFGDungeonGroup(
			ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()],
			ClassicLFGPlayer(),
			ClassicLFG.QueueWindow.CreateGroup.Title.Frame:GetText(),
			ClassicLFG.QueueWindow.CreateGroup.Description.Frame:GetText()
		))
	else
		ClassicLFG.DungeonGroupManager:ListGroup(ClassicLFG.DungeonGroupManager:InitGroup(
			ClassicLFG.QueueWindow.CreateGroup.Title.Frame:GetText(),
			ClassicLFG.Dungeon[ClassicLFG.QueueWindow.CreateGroup.Dungeon:GetValue()],
			ClassicLFG.QueueWindow.CreateGroup.Description.Frame:GetText()
		))
	end
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
end
ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)

ClassicLFG.QueueWindow.CreateGroup.DequeueButton = ClassicLFGButton(ClassicLFG.Locale["Delist Group"], ClassicLFG.QueueWindow.CreateGroup)
ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOM", 5, -8);
ClassicLFG.QueueWindow.CreateGroup.DequeueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOMRIGHT", -0, -30)
ClassicLFG.QueueWindow.CreateGroup.DequeueButton.Frame:Hide()
ClassicLFG.QueueWindow.CreateGroup.DequeueButton.OnClick = function(self)
	ClassicLFG.DungeonGroupManager:DequeueGroup()
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame = CreateFrame("ScrollFrame", nil, ClassicLFG.QueueWindow.CreateGroup, "UIPanelScrollFrameTemplate");
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.QueueButton.Frame, "BOTTOMLEFT", 0, -5);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetClipsChildren(true);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:ClearAllPoints();
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:SetPoint("TOPRIGHT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame, "TOPRIGHT", 0, 0);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame, "BOTTOMRIGHT", 0, 0);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar.ScrollUpButton:ClearAllPoints()
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar.ScrollDownButton:ClearAllPoints()
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar.ThumbTexture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar.ThumbTexture:SetWidth(2)
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar.ThumbTexture:SetColorTexture(
    ClassicLFG.Config.PrimaryColor.Red,
    ClassicLFG.Config.PrimaryColor.Green,
    ClassicLFG.Config.PrimaryColor.Blue,
    ClassicLFG.Config.PrimaryColor.Alpha
)
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.ScrollBar:Hide()

ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child = CreateFrame("Frame", nil, ClassicLFG.QueueWindow.CreateGroup.ScrollFrame);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child:SetSize(ClassicLFG.QueueWindow.CreateGroup:GetWidth(), 20);
ClassicLFG.QueueWindow.CreateGroup.ScrollFrame:SetScrollChild(ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child);


ClassicLFG.QueueWindow.CreateGroup.ApplicantList = ClassicLFGApplicantList(ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child)
ClassicLFG.QueueWindow.CreateGroup.ApplicantList.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.CreateGroup.ScrollFrame.Child, "TOPLEFT", 0, 0);
ClassicLFG.QueueWindow.CreateGroup.ApplicantList.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup, "BOTTOMRIGHT", 0, 0)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	if (ClassicLFG.DungeonGroupManager:IsListed() and ClassicLFG.DungeonGroupManager.DungeonGroup.Hash == dungeonGroup.Hash) then
		ClassicLFG.QueueWindow:DisableTab(1)
		ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetText(dungeonGroup.Title)
		ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetText(dungeonGroup.Description)
		ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
        ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
		ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetTexture(dungeonGroup.Dungeon.Background)
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.DPS))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.TANK))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.HEALER))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.UNKNOWN))
	end
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	ClassicLFG.QueueWindow:DisableTab(1)
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOM", -5, -30)
	ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
	ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetText(dungeonGroup.Title)
	ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetText(dungeonGroup.Description)
	ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(dungeonGroup.Dungeon.Name)
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetText(ClassicLFG.Locale["Update Data"])
	ClassicLFG.QueueWindow.CreateGroup.DequeueButton:Show()
    ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(false)
    ClassicLFG.QueueWindow.CreateGroup.Icon.Texture:SetTexture(dungeonGroup.Dungeon.Background)
    if (dungeonGroup.Leader.Name ~= UnitName("player")) then
        ClassicLFG.QueueWindow.CreateGroup.Title:Disable()
        ClassicLFG.QueueWindow.CreateGroup.Description:Disable()
        ClassicLFG.QueueWindow.CreateGroup.Dungeon:Disable()
    end

    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.DPS))
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.TANK))
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.HEALER))
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.UNKNOWN))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, ClassicLFG.QueueWindow, function(self, dungeonGroup)
	ClassicLFG.QueueWindow:EnableTab(1)
	ClassicLFG.QueueWindow.CreateGroup.DequeueButton:Hide()
	ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Text:SetText("0")
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Text:SetText("0")
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Text:SetText("0")
    ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Text:SetText("0")
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDisbanded, ClassicLFG.QueueWindow, function(self)
	local dungeonGroup = ClassicLFG.DungeonGroupManager.DungeonGroup
	if (ClassicLFG.DungeonGroupManager:IsListed()) then
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Dps.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.DPS))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Tank.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.TANK))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Healer.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.HEALER))
		ClassicLFG.QueueWindow.CreateGroup.RoleIcons.Unknown.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(dungeonGroup, ClassicLFG.Role.UNKNOWN))
	end
end)

ClassicLFG.QueueWindow.CreateGroup:RegisterEvent("PARTY_LEADER_CHANGED")
ClassicLFG.QueueWindow.CreateGroup:SetScript("OnEvent", function(_, event)
	if (event == "PARTY_LEADER_CHANGED") then
		if (UnitIsGroupLeader("player") == true or IsInGroup() == false) then
            ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(false)
            ClassicLFG.QueueWindow.CreateGroup.Title:Enable()
            ClassicLFG.QueueWindow.CreateGroup.Description:Enable()
            ClassicLFG.QueueWindow.CreateGroup.Dungeon:Enable()
		else
			ClassicLFG.QueueWindow.CreateGroup:DisableDequeueButton(true)
            ClassicLFG.QueueWindow.CreateGroup:DisableQueueButton(true)
            ClassicLFG.QueueWindow.CreateGroup.Title:Disable()
            ClassicLFG.QueueWindow.CreateGroup.Description:Disable()
            ClassicLFG.QueueWindow.CreateGroup.Dungeon:Disable()
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
    ClassicLFG.QueueWindow.CreateGroup.Title:Enable()
    ClassicLFG.QueueWindow.CreateGroup.Title.Frame:SetText("")
    ClassicLFG.QueueWindow.CreateGroup.Description:Enable()
    ClassicLFG.QueueWindow.CreateGroup.Description.Frame:SetText("")
    ClassicLFG.QueueWindow.CreateGroup.Dungeon:Enable()
    ClassicLFG.QueueWindow.CreateGroup.Dungeon:Reset()
    --ClassicLFG.QueueWindow.CreateGroup.Dungeon:SetValue(ClassicLFG.Locale["Select Dungeon"])
	ClassicLFG.QueueWindow.CreateGroup.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.CreateGroup.Description.Frame, "BOTTOMRIGHT", 0, -30)
end)