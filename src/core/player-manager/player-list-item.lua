CLassicLFGPlayerListItem = {}
CLassicLFGPlayerListItem.__index = CLassicLFGPlayerListItem

setmetatable(CLassicLFGPlayerListItem, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CLassicLFGPlayerListItem.new(entry, anchor, relativeAnchor, space)
    local self = setmetatable({}, CLassicLFGPlayerListItem)
    self.Frame = CreateFrame("Frame", nil, anchor, nil)
    self.IsOpen = false
    self.DefaultBackgroundColor = { Red = 0.3, Green = 0.3, Blue = 0.3, Alpha = 1 }
    self.DefaultMouserOverColor = { Red = 0.4, Green = 0.4, Blue = 0.4, Alpha = 1 }
    self.BackgroundColor =  self.DefaultBackgroundColor
    self.MouseOverColor =  self.DefaultMouserOverColor
    self.Frame:SetPoint("TOPLEFT", anchor, relativeAnchor, 0, -space);
    self.Frame:SetSize(ClassicLFG.QueueWindow.SearchPlayers:GetWidth(), 50);
    self.TitleBackground = CreateFrame("Frame", nil, self.Frame, nil)
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })

    self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    self.Frame:SetBackdropBorderColor(1,1,1,1)
    self.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Title:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 5, -5);
    self.Title.OldSetText = self.Title.SetText
    self.Title.SetText = function(title, text)
        if (text:len() > 35) then
            text = text:sub(1, 32)
            text = text .. "..."
            self.Title.Truncated = true
        else
            self.Title.Truncated = false
        end
        self.Title.OldSetText(title, text)
        self.TitleBackground:SetPoint("TOPLEFT", self.Title, "TOPLEFT")
        self.TitleBackground:SetPoint("BOTTOMRIGHT", self.Title, "BOTTOMRIGHT")
    end

    self.Tooltip = ClassicLFGTooltip(self.Frame)

    self.DungeonName = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.DungeonName:SetFont(ClassicLFG.Config.Font, 10, "NONE");
    self.DungeonName:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT", 0, -2);

    self.EntrySource = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.EntrySource:SetFont(ClassicLFG.Config.Font, 8, "NONE");
    self.EntrySource:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -5, -5);

    self.Timer = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Timer:SetFont(ClassicLFG.Config.Font, 8, "NONE");
    self.Timer:SetPoint("TOPLEFT", self.DungeonName, "BOTTOMLEFT", 0, -2);
    self.Timer:Hide()

    self.WhisperButton = ClassicLFGButton(ClassicLFG.Locale["Queue"], self.Frame)
    self.WhisperButton:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", -5, 5)
    self.WhisperButton.OnClick = function() 
        ChatFrame1EditBox:Show()
        ChatFrame1EditBox:SetText("/w ".. self.entry.Leader.Name .. " ")
        ChatFrame1EditBox:SetFocus()
    end
    
    self.WhisperButton:SetText(ClassicLFG.Locale["Whisper"])
    self.WhisperButton:Hide()

    self.QueueButton = ClassicLFGButton(ClassicLFG.Locale["Queue"], self.Frame)
    self.QueueButton:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", -92, 5)
    self.QueueButton.OnClick = function() 
        ClassicLFG.QueueDungeonGroupWindow.DungeonGroup = self.entry
        ClassicLFG.QueueDungeonGroupWindow.Frame:Show()
    end

    self.QueueButton:SetText(ClassicLFG.Locale["Queue"])
    self.QueueButton:Hide()

    self.Description = CreateFrame("EditBox", nil, self.Frame, nil);
    self.Description:SetFont(ClassicLFG.Config.Font, 10, "NONE");
    self.Description:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMLEFT", 5, 15);
    self.Description:SetSize(198, 240)
    self.Description:EnableMouse(false)
    self.Description:SetMultiLine(true)
    self.Description:Disable()
    self.Description:Hide()

    self.RoleIcons = {}
    self.RoleIcons.Dps = ClassicLFGIconWithText(0, ClassicLFG.Role.DPS.Icon, self.Frame, 50, 50)
    self.RoleIcons.Dps.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -20, -15)
    self.RoleIcons.Dps.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -40, -35)
    self.RoleIcons.Dps.Icon:GetTexture():SetTexCoord(
        ClassicLFG.Role.DPS.Offset.Left,
        ClassicLFG.Role.DPS.Offset.Right,
        ClassicLFG.Role.DPS.Offset.Top,
        ClassicLFG.Role.DPS.Offset.Bottom)

    self.RoleIcons.Healer = ClassicLFGIconWithText(0, ClassicLFG.Role.HEALER.Icon, self.Frame, 50, 50)
    self.RoleIcons.Healer.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -100, -15)
    self.RoleIcons.Healer.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -120, -35)
    self.RoleIcons.Healer.Icon:GetTexture():SetTexCoord(
        ClassicLFG.Role.HEALER.Offset.Left,
        ClassicLFG.Role.HEALER.Offset.Right,
        ClassicLFG.Role.HEALER.Offset.Top,
        ClassicLFG.Role.HEALER.Offset.Bottom)

    self.RoleIcons.Tank = ClassicLFGIconWithText(0, ClassicLFG.Role.TANK.Icon, self.Frame, 50, 50)
    self.RoleIcons.Tank.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -60, -15)
    self.RoleIcons.Tank.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -80, -35)
    self.RoleIcons.Tank.Icon:GetTexture():SetTexCoord(
        ClassicLFG.Role.TANK.Offset.Left,
        ClassicLFG.Role.TANK.Offset.Right,
        ClassicLFG.Role.TANK.Offset.Top,
        ClassicLFG.Role.TANK.Offset.Bottom)

    self.RoleIcons.Unknown = ClassicLFGIconWithText(0, ClassicLFG.Role.UNKNOWN.Icon, self.Frame, 50, 50)
    self.RoleIcons.Unknown.Icon:GetTexture():SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -142, -17)
    self.RoleIcons.Unknown.Icon:GetTexture():SetPoint("BOTTOMLEFT", self.Frame, "TOPRIGHT", -158, -33)
    self.RoleIcons.Unknown.Icon:GetTexture():SetTexCoord(
        ClassicLFG.Role.UNKNOWN.Offset.Left,
        ClassicLFG.Role.UNKNOWN.Offset.Right,
        ClassicLFG.Role.UNKNOWN.Offset.Top,
        ClassicLFG.Role.UNKNOWN.Offset.Bottom)

    self.Frame:SetScript("OnEnter", function()
        self.Frame:SetBackdropColor(self.MouseOverColor.Red, self.MouseOverColor.Green, self.MouseOverColor.Blue, self.MouseOverColor.Alpha)
        self.Tooltip:SetText(self.entry.Title)
    end)

    self.Frame:SetScript("OnLeave", function()
        self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    end)

    self.TitleBackground:SetScript("OnEnter", function()
        if (self.Title.Truncated) then
            self.Tooltip.Frame:Show()
        end
    end)

    self.TitleBackground:SetScript("OnLeave", function()
        self.Tooltip.Frame:Hide()
    end)

    self.Frame:SetScript("OnMouseDown", function()
        if (self.IsOpen) then
            self.Frame:SetHeight(50)
            self.IsOpen = false
            self.QueueButton:Hide()
            self.Description:Hide()
            self.WhisperButton:Hide()
            self.Timer:Hide()
        else
            self.Frame:SetHeight(95)
            self.IsOpen = true
            self.Description:Show()
            self.WhisperButton:Show()
            self.Timer:Show()
            if (self.entry.Source.Type == "ADDON") then
                self.QueueButton:Show()
            end
        end
    end)

    -- ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.AppliedForGroup, self, function(self, dungeonGroup)
    --     if (self.entry ~= nil and dungeonGroup.Hash == self.entry.Hash) then
    --         self.QueueButton:SetDisabled(true)
    --     end
    -- end)

    -- ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DeclineApplicant, self, function(self, dungeonGroup)
    --     if (self.entry ~= nil and (dungeonGroup.Hash == self.entry.Hash or dungeonGroup.Leader.Name == self.entry.Leader.Name)) then
    --         self.QueueButton:SetDisabled(false)
    --     end
    -- end)

    -- ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, function(self, dungeonGroup)
    --     self.QueueButton:SetDisabled(false)
    -- end)

    -- ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupInviteDecline, self, function(self, playerName)
    --     if (self.entry ~= nil and self.entry.Leader.Name == playerName) then
    --         self.QueueButton:SetDisabled(false)
    --     end
    -- end)
    self:SetGroup(entry)

    self.Frame:SetScript("OnUpdate", function()
        if (self.Frame:IsShown()) then
            local seconds = (math.floor(GetTime() - self.entry.UpdateTime) % 60)
            if (seconds < 10) then
                seconds = "0" .. tostring(seconds)
            end
            self.Timer:SetText(math.floor((GetTime() - self.entry.UpdateTime) / 60) .. ":" .. seconds)
        end
    end)
    return self
end

function CLassicLFGPlayerListItem:SetGroup(entry)
    if (entry) then
        self.entry = entry
        self.Title:SetText(entry.Leader.Name )
        self.Description:SetText(entry.Title)
        self.DungeonName:SetText(ClassicLFG.Locale[entry.Dungeon.Name] or entry.Dungeon.Name)
        self.RoleIcons.Dps.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(entry, ClassicLFG.Role.DPS))
        self.RoleIcons.Tank.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(entry, ClassicLFG.Role.TANK))
        self.RoleIcons.Healer.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(entry, ClassicLFG.Role.HEALER))
        self.RoleIcons.Unknown.Text:SetText(ClassicLFGDungeonGroup.GetRoleCount(entry, ClassicLFG.Role.UNKNOWN))
        if (self.entry.Source.Type == "CHAT") then
            self.RoleIcons.Dps:Hide()
            self.RoleIcons.Tank:Hide()
            self.RoleIcons.Healer:Hide()
            self.RoleIcons.Unknown:Hide()
            self.QueueButton:Hide()
            self.Description:SetText(entry.Title)
        else
            self.RoleIcons.Dps:Show()
            self.RoleIcons.Tank:Show()
            self.RoleIcons.Healer:Show()
            self.RoleIcons.Unknown:Show()
            self.Description:SetText(entry.Description)
        end

        if (ClassicLFG.GroupManager:HasAppliedForGroup(entry)) then
            self.QueueButton:SetDisabled(true)
        else
            self.QueueButton:SetDisabled(false)
        end

        if (ClassicLFG:IsInPlayersGuild(entry.Leader.Name) == true) then
            self.BackgroundColor = ClassicLFG:DeepCopy(ClassicLFG.Config.GuildColor)
            self.MouseOverColor = ClassicLFG:DeepCopy(ClassicLFG.Config.GuildColor)
            self.MouseOverColor.Blue = self.MouseOverColor.Blue + 0.2
            self.MouseOverColor.Red = self.MouseOverColor.Red + 0.2
        elseif (ClassicLFG:PlayerIsFriend(entry.Leader.Name) == true) then
            self.BackgroundColor =  ClassicLFG:DeepCopy(ClassicLFG.Config.FriendColor)
            self.MouseOverColor = ClassicLFG:DeepCopy(ClassicLFG.Config.FriendColor)
            self.MouseOverColor.Green = 1
        elseif (ClassicLFG:IsBattleNetFriend(entry.Leader.Name) == true) then
            self.BackgroundColor =  ClassicLFG:DeepCopy(ClassicLFG.Config.BattleNetColor)
            self.MouseOverColor = ClassicLFG:DeepCopy(ClassicLFG.Config.BattleNetColor)
            self.MouseOverColor.Blue = self.MouseOverColor.Blue + 0.2
            self.MouseOverColor.Red = self.MouseOverColor.Red + 0.2
        else
            self.BackgroundColor = self.DefaultBackgroundColor
            self.MouseOverColor = self.DefaultMouserOverColor
            if (entry.Source.Type == "ADDON") then
                self.BackgroundColor.Blue = 0.6
                self.MouseOverColor.Blue = 0.7
            else
                self.BackgroundColor.Blue = 0.4
                self.MouseOverColor.Blue = 0.5
            end
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