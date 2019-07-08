ClassicLFGApplicantList = {}
ClassicLFGApplicantList.__index = ClassicLFGApplicantList

setmetatable(ClassicLFGApplicantList, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGApplicantList.new(parent)
    local self = setmetatable({}, ClassicLFGApplicantList)
    self.Frame = CreateFrame("Frame", nil, parent, nil);
    self.ListItems = {}
    self:InitListItems(50)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantReceived, self, self.UpdateList)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantDeclined, self, self.UpdateList)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInviteAccepted, self, self.UpdateList)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInviteDeclined, self, self.UpdateList)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, self, self.UpdateList)
    return self
end

function ClassicLFGApplicantList:InitListItems(count)
    local listItem = ClassicLFGApplicantListItem(self, nil, self.Frame)
    local previous = nil
    listItem:AttachToFrame(self.Frame, "TOP", 0)
    table.insert(self.ListItems, listItem)
    for i=2,count do
        previous = listItem
        listItem = ClassicLFGApplicantListItem(self, nil, self.Frame)
        listItem:AttachToFrame(previous.Frame, "BOTTOM", -5)
        table.insert(self.ListItems, listItem)
    end
end

function ClassicLFGApplicantList:UpdateList()
    for i=1, #self.ListItems do
        local applicant = ClassicLFG.DungeonGroupManager.Applicants:GetItem(i - 1)
        self.ListItems[i]:SetPlayer(applicant)
    end
end

function ClassicLFGApplicantList:Test()
    for i=1, 25 do
        self.ListItems[i]:SetPlayer(ClassicLFGPlayer("TimTheTatMan" .. i, "NONAME", 60, ClassicLFG.Class.WARRIOR.Name, { 1, 1, 1 }))
    end
end


ClassicLFGApplicantListItem = {}
ClassicLFGApplicantListItem.__index = ClassicLFGApplicantListItem

setmetatable(ClassicLFGApplicantListItem, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGApplicantListItem.new(list, player, parent)
    local self = setmetatable({}, ClassicLFGApplicantListItem)
    self.List = list
    self.Frame = CreateFrame("Frame", nil, parent, nil);
    self.BackgroundColor =  { Red = 0.3, Green = 0.3, Blue = 0.6, Alpha = 1 }
    self.TextColor = { Red = 0, Green = 0, Blue = 0, Alpha = 1 }
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
    self.PlayerText = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.PlayerText:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.GuildText = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.GuildText:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.ClassText = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.ClassText:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.DeclineButton = ClassicLFGButton(ClassicLFG.Locale["Decline"], self.Frame)
    self.DeclineButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -5, -5);
    self.DeclineButton:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -65, 5)
    self.DeclineButton.OnClick = function()
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantDeclined, self.Player)
    end
    self.InviteButton = ClassicLFGButton(ClassicLFG.Locale["Invite"], self.Frame)
    self.InviteButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -70, -5);
    self.InviteButton:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -130, 5)
    self.InviteButton.OnClick = function()
        ClassicLFG.DungeonGroupManager:ApplicantInvited(self.Player)
    end
    self:SetPlayer(player)
    self.Tooltip = CreateFrame("Frame", nil, UIParent, nil)
    self.Tooltip:SetSize(150, 30)
    self.Tooltip:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeSize = 16, tileEdge = true
    })
    self.Tooltip:SetBackdropColor(ClassicLFG.Config.BackgroundColor.Red,
        ClassicLFG.Config.BackgroundColor.Green,
        ClassicLFG.Config.BackgroundColor.Blue,
        ClassicLFG.Config.BackgroundColor.Alpha)
    self.Tooltip:SetFrameStrata("TOOLTIP")
    self.Tooltip.Text = self.Tooltip:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Tooltip.Text:SetFont(ClassicLFG.Config.Font, 11, "NONE");
    self.Tooltip.Text:SetPoint("LEFT", self.Tooltip, "LEFT", 5, 0);
    self.Tooltip:Show()
    self.MouseOver = false

    self.Frame:RegisterEvent("PARTY_LEADER_CHANGED")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        self:PartyLeaderCheck()
    end)
    self.Frame:SetScript("OnEnter", function()
        if (self.Player and self.Player.Note ~= nil and self.Player.Note ~= "") then
            self.MouseOver = true
            self.Tooltip:Show()
        end
    end)
    self.Frame:SetScript("OnLeave", function() 
        self.MouseOver = false
        self.Tooltip:Hide()
    end)
    self.Frame:SetScript("OnUpdate", function()
        if (self.MouseOver == true) then
            local x, y = GetCursorPosition()
            x, y = x / UIParent:GetEffectiveScale(), y / UIParent:GetEffectiveScale()
            self.Tooltip:SetPoint("TOPLEFT", x, y - GetScreenHeight() + 30)
        end
    end)

    self.Frame:SetScript("OnMouseUp", function()
        ChatFrame1EditBox:Show()
        ChatFrame1EditBox:SetText("/w ".. self.Player.Name .. " ")
        ChatFrame1EditBox:SetFocus()
    end)

    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInvited, self, function(self, applicant)
        if(self.Player and self.Player.Name == applicant.Name) then
            self.InviteButton.Frame.Title:SetTextColor(0, 1, 0, 1)
            self.InviteButton:SetDisabled(true)
            self.DeclineButton:SetDisabled(true)
        end
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, self.PartyLeaderCheck)
    return self
end

function ClassicLFGApplicantListItem:PartyLeaderCheck()
    if (not IsInGroup() or UnitIsGroupLeader(UnitName("player")) == true) then
        if(self.Player and self.Player.Invited ~= true) then
            self:Enable()
        end
    else
        self:Disable()
    end
end

function ClassicLFGApplicantListItem:Enable()
    self.DeclineButton:SetDisabled(false)
    self.InviteButton:SetDisabled(false)
end

function ClassicLFGApplicantListItem:Disable()
    self.DeclineButton:SetDisabled(true)
    self.InviteButton:SetDisabled(true)
end

function ClassicLFGApplicantListItem:SetPlayer(player)
    self.Player = player
    if (player ~= nil) then
        self.PlayerText:SetText(player.Name)
        self.ClassText:SetText(player.Level .. " ")
        if (player.Talents ~= nil) then
            self.ClassText:SetText(self.ClassText:GetText() .. ClassicLFG.Locale[ClassicLFGPlayer.GetSpecialization(player).Name] .. " ")
        end
        self.ClassText:SetText(self.ClassText:GetText() .. ClassicLFG.Locale[player.Class])
        if (player.Talents ~= nil) then
            self.ClassText:SetText(self.ClassText:GetText() .. " (" .. player.Talents[1] .. "/" .. player.Talents[2] .. "/" .. player.Talents[3] .. ")")
        end
        self.ClassText:SetTextColor(GetClassColor(player.Class:upper()))
        self.PlayerText:SetPoint("LEFT", self.Frame, "TOPLEFT", 5, -10)

        if (ClassicLFG:IsInPlayersGuild(player.Name) == true) then
            self.Frame:SetBackdropColor(64/255, 251/255, 64/255, 0.5)
        elseif (ClassicLFG:PlayerIsFriend(player.Name) == true) then
            self.Frame:SetBackdropColor(239/255, 244/255, 39/255, 0.5)
        elseif (ClassicLFG:IsBattleNetFriend(player.Name) == true) then
            self.Frame:SetBackdropColor(13/255, 135/255, 202/255, 0.5)
        else
            self.Frame:SetBackdropColor(self.BackgroundColor.Red, self.BackgroundColor.Green, self.BackgroundColor.Blue, self.BackgroundColor.Alpha)
        end

        if (player.Guild) then
            self.GuildText:SetText("<" .. player.Guild .. ">")
            self.GuildText:SetPoint("TOPLEFT", self.PlayerText, "BOTTOMLEFT", 0, -3)
            self.ClassText:SetPoint("TOPLEFT", self.GuildText, "BOTTOMLEFT", 0, -3)
        else
            self.GuildText:SetText("")
            self.ClassText:SetPoint("TOPLEFT", self.PlayerText, "BOTTOMLEFT", 0, -3)
        end
        if (player.Invited == false) then
            self.InviteButton.Frame.Title:SetTextColor(1, 1, 1, 1)
            self:PartyLeaderCheck()
        else
            self.InviteButton.Frame.Title:SetTextColor(0, 1, 0, 1)
            self.InviteButton:SetDisabled(true)
            self.DeclineButton:SetDisabled(true)
        end
        if (self.Player.Note ~= nil) then
            self.Tooltip.Text:SetText(self.Player.Note)
            self.Tooltip:SetWidth(self.Tooltip.Text:GetStringWidth() + 10)
        end
        self.Frame:Show()
    else
        self.Frame:Hide()
    end
end

function ClassicLFGApplicantListItem:AttachToFrame(parent, direction, yOffset)
    self.Frame:SetPoint("TOPLEFT", parent, direction .. "LEFT", 0, yOffset)
    self.Frame:SetPoint("BOTTOMRIGHT", parent, direction .. "RIGHT", 0, -50 + yOffset)
end