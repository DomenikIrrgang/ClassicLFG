ClassicLFGGroupManager = {}
ClassicLFGGroupManager.__index = ClassicLFGGroupManager

setmetatable(ClassicLFGGroupManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGGroupManager.new()
    local self = setmetatable({}, ClassicLFGGroupManager)
    self.Groups = ClassicLFGLinkedList()
    self.Applicants = ClassicLFGLinkedList()
    self.Frame = CreateFrame("Frame")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
    self.Frame:RegisterEvent("PARTY_INVITE_REQUEST")
    self.Frame:RegisterEvent("GROUP_JOINED")
    self.Frame:SetScript("OnEvent", function(_, event, ...) 
        if (event == "CHAT_MSG_CHANNEL_JOIN") then
            local _, playerName, _, channelId, channelName = ...
            if (tonumber(channelId:sub(0,1)) == ClassicLFG.Config.Network.Channel.Id) then
                self:HandleDataRequest(nil, playerName)
            end
        end
        print(event)
        if (event == "GROUP_JOINED") then
            local index = ...
            local playerName = GetRaidRosterInfo(index)
            self:ApplicantInviteAccepted(ClassicLFGPlayer(playerName))
        end

        if (event == "PARTY_INVITE_REQUEST") then
            -- ToDo: Only Accept if the leader is in one of the groups you applied to.
            local leader = ...
            AcceptGroup()
            StaticPopup1:Hide()
        end
    end)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.RequestData, self, self.HandleDataRequest)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.PostGroup, self, self.ReceiveGroup)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.DequeueGroup, self, self.HandleDequeueGroup)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.ApplyForGroup, self, self.HandleApplications)
    return self
end

function ClassicLFGGroupManager:HandleDataRequest(object, sender)
    if (self.Groups.Size > 0) then
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Network.Prefixes.PostGroup,
            self.Groups:GetItem(math.random(0, self.Groups.Size - 1)),
            "WHISPER",
            sender)
    end
end

function ClassicLFGGroupManager:HandleApplications(applicant)
    print(self.Applicants.Size)
    local index = self.Applicants:ContainsWithEqualsFunction(applicant, function(item1, item2)
        return item1.Name == item2.Name
    end)
    if (index == nil) then
        self:AddApplicant(applicant)
    end
end

function ClassicLFGGroupManager:ApplicantDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantDeclined, applicant)
end

function ClassicLFGGroupManager:ApplicantInvited(applicant)
    InviteUnit(applicant.Name)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInvited, applicant)
end

function ClassicLFGGroupManager:ApplicantInviteAccepted(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteAccepted, applicant)
end

function ClassicLFGGroupManager:ApplicantInviteDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteDeclined, applicant)
end

function ClassicLFGGroupManager:AddApplicant(applicant)
    self.Applicants:AddItem(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantReceived, applicant)
end

function ClassicLFGGroupManager:RemoveApplicant(applicant)
    local index = self.Applicants:ContainsWithEqualsFunction(applicant, function(item1, item2)
        return item1.Name == item2.Name
    end)
    if (index ~= nil) then
        self.Applicants:RemoveItem(index)
    end
end

function ClassicLFGGroupManager:ApplyForGroup(dungeonGroup)
    if (dungeonGroup.Leader.Name ~= UnitName("player")) then
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Network.Prefixes.ApplyForGroup,
            ClassicLFGPlayer(),
            "WHISPER",
            dungeonGroup.Leader.Name)
    end
end

function ClassicLFGGroupManager:PostGroup(dungeonGroup)
    self:ReceiveGroup(dungeonGroup)
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Network.Prefixes.PostGroup,
        dungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
end

function ClassicLFGGroupManager:DequeueGroup()
    local dungeonGroup = ClassicLFGDungeonGroup()
    self:HandleDequeueGroup(dungeonGroup)
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Network.Prefixes.DequeueGroup,
        dungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
end

function ClassicLFGGroupManager:HandleDequeueGroup(dungeonGroup)
    local index = self:HasGroup(dungeonGroup.Leader)
    if (index ~= nil) then
        self.Groups:RemoveItem(index)
    end
end

function ClassicLFGGroupManager:ReceiveGroup(dungeonGroup)
    local groupIndex = self:HasGroup(dungeonGroup.Leader)
    if (groupIndex ~= nil) then
        self.Groups:SetItem(groupIndex, dungeonGroup)
    else
        self.Groups:AddItem(dungeonGroup)
    end
end

function ClassicLFGGroupManager:HasGroup(player)
    for i=0, self.Groups.Size - 1 do
        if (self.Groups:GetItem(i).Leader.Name == player.Name) then
            return i
        end
    end
    return nil
end

function ClassicLFGGroupManager:FilterGroupsByDungeon(dungeons)
    local groups = {}
    for i=0, self.Groups.Size - 1 do
        local group = self.Groups:GetItem(i)
        if (ClassicLFG:ArrayContainsValue(dungeons, group.Dungeon.Name)) then
            table.insert(groups, group)
        end
    end
    return groups
end

ClassicLFG.GroupManager = ClassicLFGGroupManager()