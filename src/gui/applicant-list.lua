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
    self.Applicants = ClassicLFGDoubleLinkedList()
    self.ListObjects = {}
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantReceived, self, function(self, ...)
        local applicant = ...
        self:AddApplicant(applicant)
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantDeclined, self, function(self, ...)
        local applicant = ...
        self:RemoveApplicant(applicant)
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInviteAccepted, self, function(self, ...)
        local applicant = ...
        self:RemoveApplicant(applicant)
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInviteDeclined, self, function(self, ...)
        local applicant = ...
        self:RemoveApplicant(applicant)
    end)
    return self
end

function ClassicLFGApplicantList:AddApplicant(player)
    local applicant = player
    applicant.ListItem = ClassicLFGApplicantListItem(self, player, self.Frame)
    if (self.Applicants.Size == 0) then
        applicant.ListItem:AttachToFrame(self.Frame, "TOP", 0)
    else
        applicant.ListItem:AttachToFrame(self.Applicants.Items.Tail.Previous.ListItem.Frame, "BOTTOM", -5)
    end
    self.Applicants:AddItem(player)
end

function ClassicLFGApplicantList:RemoveApplicant(applicant)
    if (not applicant.Next.IsTail and not applicant.Previous.IsHead) then
        applicant.Next.ListItem:AttachToFrame(applicant.Previous.ListItem.Frame, "BOTTOM", -5)
    else
        if (applicant.Previous.IsHead and not applicant.Next.IsTail) then
            applicant.Next.ListItem:AttachToFrame(self.Frame, "TOP", 0)
        end
    end
    applicant.ListItem.Frame:Hide()
    self.Applicants:RemoveItemEqualsFunction(function(item) 
        return item.Name == applicant.Name
    end)
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
    self.Invited = nil
    self.Frame = CreateFrame("Frame", nil, parent, nil);
    self.BackgroundColor =  { Red = 0.3, Green = 0.3, Blue = 0.6, Alpha = 1 }
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
        if (self.Invited == nil) then
            ClassicLFG.GroupManager:ApplicantDeclined(self.Player)
        end
    end
    self.InviteButton = ClassicLFGButton("Invite", self.Frame)
    self.InviteButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -70, -5);
    self.InviteButton:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -130, 5)
    self.InviteButton.OnClick = function()
        if (self.Invited == nil) then
            ClassicLFG.GroupManager:ApplicantInvited(self.Player)
            self.InviteButton.Frame.Title:SetTextColor(0, 1, 0, 1)
        end
    end
    self:SetPlayer(player)

    return self
end

function ClassicLFGApplicantListItem:SetPlayer(player)
    self.Player = player
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
end

function ClassicLFGApplicantListItem:AttachToFrame(parent, direction, yOffset)
    self.Frame:SetPoint("TOPLEFT", parent, direction .. "LEFT", 0, yOffset)
    self.Frame:SetPoint("BOTTOMRIGHT", parent, direction .. "RIGHT", 0, -50 + yOffset)
end