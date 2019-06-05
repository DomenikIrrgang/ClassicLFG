ClassicLFGDungeonGroupManager = {}
ClassicLFGDungeonGroupManager.__index = ClassicLFGDungeonGroupManager

setmetatable(ClassicLFGDungeonGroupManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDungeonGroupManager.new(dungeon, leader, title, description, source, members)
    local self = setmetatable({}, ClassicLFGDungeonGroupManager)
    self.DungeonGroup = nil
    self.Applicants = ClassicLFGLinkedList()
    self.Frame = CreateFrame("Frame")
    self.Frame:RegisterEvent("PARTY_INVITE_REQUEST")
    self.Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    self.Frame:RegisterEvent("GROUP_JOINED")
    self.Frame:RegisterEvent("GROUP_LEFT")
    self.Frame:RegisterEvent("RAID_ROSTER_UPDATE")
    self.Frame:RegisterEvent("PARTY_INVITE_REQUEST")
    self.Frame:RegisterEvent("PARTY_INVITE_REQUEST")
    self.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.Frame:RegisterEvent("PLAYER_LEAVING_WORLD")
    self.Frame:RegisterEvent("CHAT_MSG_SYSTEM")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
    self.Frame:RegisterEvent("PARTY_LEADER_CHANGED")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        if (event == "CHAT_MSG_SYSTEM") then

            local message = ...
            if(self:IsListed() and message:find(" declines your group invitation.")) then
                local playerName = message:gsub(" declines your group invitation.", "")
                self:ApplicantInviteDeclined(ClassicLFGPlayer(playerName, "", "", "", ""))
            end

            if(self:IsListed() and message:find(" joins the party.")) then
                ClassicLFG:DebugPrint("Player joined the party!")
                local playerName = message:gsub(" joins the party.", "")
                local index = self.Applicants:Contains(ClassicLFGPlayer(playerName))
                if (index ~= nil) then
                    self:ApplicantInviteAccepted(self.Applicants:GetItem(index))
                else
                    self:ApplicantInviteAccepted(ClassicLFGPlayer(playerName))
                end
            end

            if(self:IsListed() and message:find(" leaves the party.")) then
                local playerName = message:gsub(" leaves the party.", "")
                ClassicLFG:DebugPrint(playerName .. " left the party!")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupMemberLeft, ClassicLFGPlayer(playerName))
            end

            if(self:IsListed() and (message:find("Your group has been disbanded.") or
            message:find("You leave the group.") or
            message:find("You have been removed from the group."))) then
                 ClassicLFG:DebugPrint("Left party.")
                if (self.DungeonGroup.Leader.Name ~= UnitName("player")) then
                    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
                else
                    ClassicLFGLinkedList.Clear(self.DungeonGroup.Members)
                    ClassicLFGLinkedList.AddItem(self.DungeonGroup.Members, ClassicLFGPlayer())
                end
            end
        end

        if(self:IsListed() and event == "PARTY_LEADER_CHANGED") then
            for i = 0, self.DungeonGroup.Members.Size - 1 do
                local player = ClassicLFGLinkedList.GetItem(self.DungeonGroup.Members, i)
                if (UnitIsGroupLeader(player.Name) == true) then
                    local oldGroup = self.DungeonGroup
                    oldGroup.Leader = player
                    self:UpdateGroup(oldGroup)
                end
            end
        end

        if (event == "CHAT_MSG_CHANNEL_JOIN") then
            local _, playerName, _, channelId, channelName = ...
            if (tonumber(channelId:sub(0,1)) == ClassicLFG.Config.Network.Channel.Id) then
                self:HandleDataRequest(nil, playerName)
            end
        end
        
        if (event == "GROUP_ROSTER_UPDATE") then
            if (self.DungeonGroup) then
                --self.DungeonGroup:Sync()
                for i = 1, GetNumGroupMembers() do
                    local playerName = GetRaidRosterInfo(i)
                    local player = ClassicLFGPlayer(playerName)
                    for k=0, self.Applicants.Size - 1 do
                        if (self.Applicants:GetItem(k).Name == playerName) then
                            self:ApplicantInviteAccepted(player)
                            break
                        end
                    end
                end
            end
        end

        if (event == "PARTY_INVITE_REQUEST") then
            -- ToDo: Only Accept if the leader is in one of the groups you applied to.
            --AcceptGroup()
            --StaticPopup1:Hide()
        end
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.RequestData, self, self.HandleDataRequest)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplyForGroup, self, self.HandleApplications)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupSyncRequest, self, self.HandleDungeonGroupSyncRequest)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupSyncResponse, self, self.HandleDungeonGroupSyncResponse)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, self.HandleDungeonGroupJoined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, self, self.HandleDungeonGroupLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, self, self.HandleGroupDelisted)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, self, self.HandleGroupListed)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, self, self.HandleGroupUpdated)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupMemberLeft, self, self.HandleDungeonGroupMemberLeft)
    return self
end

function ClassicLFGDungeonGroupManager:HandleDataRequest(object, sender)
    if (self.DungeonGroup ~= nil) then
        local characterName = ClassicLFG:SplitString(sender, "-")[1]
        if (self.DungeonGroup.Leader.Name == UnitName("player") or characterName == self.DungeonGroup.Leader.Name) then
            ClassicLFG.Network:SendObject(
                ClassicLFG.Config.Events.GroupListed,
                self.DungeonGroup,
                "WHISPER",
                sender)
        end
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupMemberLeft(player)
    if (self:IsListed()) then
        self:RemoveMember(player)
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupDelisted(dungeonGroup)
    if (self.DungeonGroup ~= nil and dungeonGroup.Hash == self.DungeonGroup.Hash) then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupListed(dungeonGroup)
    if (UnitIsGroupLeader(dungeonGroup.Leader.Name) == true) then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupJoined, dungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupUpdated(dungeonGroup)
    if (dungeonGroup.Hash == self.DungeonGroup.Hash) then
        self.DungeonGroup = dungeonGroup
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupJoined(dungeonGroup)
    self.DungeonGroup = dungeonGroup
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupSyncRequest(_, sender)
    if (self.DungeonGroup ~= nil) then
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.DungeonGroupSyncResponse,
            self.DungeonGroup,
            "WHISPER",
            sender)
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupSyncResponse(object)
    if (self.DungeonGroup == nil) then
        self.DungeonGroup = object
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupJoined, self.DungeonGroup)
    else
        self.DungeonGroup = object
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupUpdated, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:InitGroup(title, dungeon, description)
    local dungeonGroup = ClassicLFGDungeonGroup(dungeon, nil, title, description)
    for i = 1, GetNumGroupMembers() do
        local playerName = GetRaidRosterInfo(i)
        if (playerName ~= UnitName("player")) then
            dungeonGroup:AddMember(ClassicLFGPlayer(playerName))
        end
    end
    return dungeonGroup
end

function ClassicLFGDungeonGroupManager:ListGroup(dungeonGroup)
    self.DungeonGroup = dungeonGroup
    ClassicLFGDungeonGroup.AddMember(self.DungeonGroup, ClassicLFGPlayer(UnitName("player")))
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Events.GroupListed,
        dungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupJoined, self.DungeonGroup)
end

function ClassicLFGDungeonGroupManager:IsListed()
    return self.DungeonGroup ~= nil
end

function ClassicLFGDungeonGroupManager:DequeueGroup()
    if (self:IsListed()) then
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.GroupDelisted,
            self.DungeonGroup,
            "CHANNEL",
            ClassicLFG.Config.Network.Channel.Id)
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:UpdateGroup(dungeonGroup)
    if (self.DungeonGroup ~= nil) then
        self.DungeonGroup.Dungeon = dungeonGroup.Dungeon
        self.DungeonGroup.Description = dungeonGroup.Description
        self.DungeonGroup.Title = dungeonGroup.Title
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.DungeonGroupUpdated,
            self.DungeonGroup,
            "CHANNEL",
            ClassicLFG.Config.Network.Channel.Id)
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupLeft(dungeonGroup)
    self.DungeonGroup = nil
end

function ClassicLFGDungeonGroupManager:HandleApplications(applicant)
    local index = self.Applicants:ContainsWithEqualsFunction(applicant, function(item1, item2)
        return item1.Name == item2.Name
    end)
    if (index == nil) then
        self:AddApplicant(applicant)
    end
end

function ClassicLFGDungeonGroupManager:AddApplicant(applicant)
    self.Applicants:AddItem(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantReceived, applicant)
end

function ClassicLFGDungeonGroupManager:RemoveApplicant(applicant)
    local index = self.Applicants:ContainsWithEqualsFunction(applicant, function(item1, item2)
        return item1.Name == item2.Name
    end)
    if (index ~= nil) then
        self.Applicants:RemoveItem(index)
    end
end

function ClassicLFGDungeonGroupManager:RemoveMember(member)
    local index = ClassicLFGLinkedList.ContainsWithEqualsFunction(self.DungeonGroup.Members, member, function(item1, item2)
        return item1.Name == item2.Name
    end)
    if (index ~= nil) then
        ClassicLFGLinkedList.RemoveItem(self.DungeonGroup.Members, index)
    end
end

function ClassicLFGDungeonGroupManager:ApplicantDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantDeclined, applicant)
    ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.DeclineApplicant, self.DungeonGroup, "WHISPER", applicant.Name)
end

function ClassicLFGDungeonGroupManager:ApplicantInvited(applicant)
    InviteUnit(applicant.Name)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInvited, applicant)
end

function ClassicLFGDungeonGroupManager:ApplicantInviteAccepted(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFGDungeonGroup.AddMember(self.DungeonGroup, applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteAccepted, applicant)
    ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.DungeonGroupJoined, self.DungeonGroup, "WHISPER", applicant.Name)
    if (self.DungeonGroup.Members.Size == 5) then
        self:DequeueGroup()
    end
end

function ClassicLFGDungeonGroupManager:ApplicantInviteDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteDeclined, applicant)
end

ClassicLFG.DungeonGroupManager = ClassicLFGDungeonGroupManager()