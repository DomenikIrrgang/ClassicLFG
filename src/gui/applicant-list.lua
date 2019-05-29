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
        local applicant = ClassicLFG.GroupManager.Applicants:GetItem(i - 1)
        self.ListItems[i]:SetPlayer(applicant)
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
    self.DeclineButton = ClassicLFGButton("Decline", self.Frame)
    self.DeclineButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -5, -5);
    self.DeclineButton:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -65, 5)
    self.DeclineButton.OnClick = function()
        if (self.Player.Invited == false) then
            ClassicLFG.GroupManager:ApplicantDeclined(self.Player)
        end
    end
    self.InviteButton = ClassicLFGButton("Invite", self.Frame)
    self.InviteButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -70, -5);
    self.InviteButton:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -130, 5)
    self.InviteButton.OnClick = function()
        print(self.Player.Invited)
        if (self.Player.Invited == false) then
            ClassicLFG.GroupManager:ApplicantInvited(self.Player)
            self.InviteButton.Frame.Title:SetTextColor(0, 1, 0, 1)
        end
    end
    self:SetPlayer(player)

    return self
end

function ClassicLFGApplicantListItem:SetPlayer(player)
    self.Player = player
    if (player ~= nil) then
        self.PlayerText:SetText(player.Name)
        self.ClassText:SetText(player.Level .. " " .. player.Class)
        self.ClassText:SetTextColor(GetClassColor(player.Class:upper()))
        self.PlayerText:SetPoint("LEFT", self.Frame, "TOPLEFT", 5, -10)
        if (player.Guild) then
            self.GuildText:SetText("<" .. player.Guild .. ">")
            self.GuildText:SetPoint("TOPLEFT", self.PlayerText, "BOTTOMLEFT", 0, -3)
            self.ClassText:SetPoint("TOPLEFT", self.GuildText, "BOTTOMLEFT", 0, -3)
        else
            self.ClassText:SetPoint("TOPLEFT", self.PlayerText, "BOTTOMLEFT", 0, -3)
        end
        if (player.Invited == false) then
            self.InviteButton.Frame.Title:SetTextColor(1, 1, 1, 1)
        else
            self.InviteButton.Frame.Title:SetTextColor(0, 1, 0, 1)
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