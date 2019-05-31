CLassicLFGGroupListItem = {}
CLassicLFGGroupListItem.__index = CLassicLFGGroupListItem

setmetatable(CLassicLFGGroupListItem, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CLassicLFGGroupListItem.new(entry, anchor, relativeAnchor, space)
    local self = setmetatable({}, CLassicLFGGroupListItem)
    self.Frame = CreateFrame("Frame", nil, anchor, nil)
    self.IsOpen = false
    self.BackgroundColor =  { Red = 0.3, Green = 0.3, Blue = 0.3, Alpha = 1 }
    self.MouseOverColor =  { Red = 0.4, Green = 0.4, Blue = 0.4, Alpha = 1 }
    self.Frame:SetPoint("TOPLEFT", anchor, relativeAnchor, 0, -space);
    self.Frame:SetSize(358, 50);
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })

    self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    self.Frame:SetBackdropBorderColor(1,1,1,1)

    self.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Title:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 5, -5);

    self.DungeonName = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.DungeonName:SetFont(ClassicLFG.Config.Font, 10, "NONE");
    self.DungeonName:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT", 0, -2);
    self.EntrySource = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.EntrySource:SetFont(ClassicLFG.Config.Font, 8, "NONE");
    self.EntrySource:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", 0, -3);

    self.QueueButton = ClassicLFGButton("Queue", self.Frame)
    self.QueueButton:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", -5, 5)
    self.QueueButton.OnClick = function() 
        ClassicLFG.GroupManager:ApplyForGroup(self.entry)
    end
    self.QueueButton:Hide()

    self.Description = CreateFrame("EditBox", nil, self.Frame, nil);
    self.Description:SetFont(ClassicLFG.Config.Font, 10, "NONE");
    self.Description:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMLEFT", 5, 15);
    self.Description:SetSize(250, 180)
    self.Description:EnableMouse(false)
    self.Description:SetMultiLine(true)
    self.Description:Disable()
    self.Description:Hide()

    self.RoleIcons = {}
    self.RoleIcons.Dps = ClassicLFGIconWithText(0, "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", self.Frame, 50, 50)
    self.RoleIcons.Dps.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -20, -15)
    self.RoleIcons.Dps.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -40, -35)
    self.RoleIcons.Dps.Icon:GetTexture():SetTexCoord(0.31, 0.65, 0.3, 0.65)

    self.RoleIcons.Healer = ClassicLFGIconWithText(0, "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", self.Frame, 50, 50)
    self.RoleIcons.Healer.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -100, -15)
    self.RoleIcons.Healer.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -120, -35)
    self.RoleIcons.Healer.Icon:GetTexture():SetTexCoord(0.31, 0.65, 0, 0.3)

    self.RoleIcons.Tank = ClassicLFGIconWithText(0, "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", self.Frame, 50, 50)
    self.RoleIcons.Tank.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -60, -15)
    self.RoleIcons.Tank.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -80, -35)
    self.RoleIcons.Tank.Icon:GetTexture():SetTexCoord(0, 0.31, 0.3, 0.65)

    self.Frame:SetScript("OnEnter", function()
        self.Frame:SetBackdropColor(self.MouseOverColor.Red, self.MouseOverColor.Green, self.MouseOverColor.Blue, self.MouseOverColor.Alpha)
    end)

    self.Frame:SetScript("OnLeave", function()
        self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    end)

    self.Frame:SetScript("OnMouseDown", function()
        if (self.IsOpen) then
            self.Frame:SetHeight(50)
            self.IsOpen = false
            self.QueueButton:Hide()
            self.Description:Hide()
        else
            self.Frame:SetHeight(95)
            self.IsOpen = true
            if (self.entry.Leader.Name == UnitName("player")) then
                -- Todo: Once Buttons can be disabled disabled instead of hide
                self.QueueButton.Frame:Hide()
            else
                self.QueueButton.Frame:Show()
            end
            self.Description:Show()
        end
    end)

    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.AppliedForGroup, self, function(self, dungeonGroup)
        if (self.entry ~= nil and dungeonGroup.Leader.Name == self.entry.Leader.Name) then
            self.QueueButton:SetDisabled(true)
        end
    end)

    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DeclineApplicant, self, function(self, dungeonGroup)
        if (self.entry ~= nil and dungeonGroup.Leader.Name == self.entry.Leader.Name) then
            self.QueueButton:SetDisabled(false)
        end
    end)
    self:SetGroup(entry)
    return self
end

function CLassicLFGGroupListItem:SetGroup(entry)
    if (entry) then
        self.entry = entry
        self.Title:SetText(entry.Title)
        self.DungeonName:SetText(entry.Dungeon.Name)
        self.Description:SetText(entry.Description)
        self.RoleIcons.Dps.Text:SetText(entry.Group.Dps)
        self.RoleIcons.Tank.Text:SetText(entry.Group.Tank)
        self.RoleIcons.Healer.Text:SetText(entry.Group.Healer)

        if (ClassicLFG.GroupManager:HasAppliedForGroup(entry)) then
            self.QueueButton:SetDisabled(true)
        end

        if (entry.Source.Type == "ADDON") then
            self.BackgroundColor.Blue = 0.6
            self.MouseOverColor.Blue = 0.7
        else
            self.BackgroundColor.Blue = 0.3
            self.MouseOverColor.Blue = 0.4
        end
        self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    
        if (entry.Source.Type == "CHAT") then
            self.EntrySource:SetText(entry.Source.Channel)
            self.EntrySource:Show()
        else
            self.EntrySource:Hide()
        end
    end
end