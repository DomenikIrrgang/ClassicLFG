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
    self.Frame:RegisterEvent("CHAT_MSG_SYSTEM")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        if (event == "PLAYER_ENTERING_WORLD") then
            ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.DungeonGroupSyncRequest, "RequestGroupSync", "PARTY")
        end

        if (event == "CHAT_MSG_SYSTEM") then
            local message = ...
            if(message:find(" declines your group invitation.")) then
                local playerName = message:gsub(" declines your group invitation.", "")
                self:ApplicantInviteDeclined(ClassicLFGPlayer(playerName, "", "", "", ""))
            end
        end
        
        if (event == "GROUP_ROSTER_UPDATE") then
            if (self.DungeonGroup) then
                self.DungeonGroup:Sync()
                for i = 1, GetNumGroupMembers() do
                    local playerName = GetRaidRosterInfo(i)
                    local player = ClassicLFGPlayer(playerName)
                    for k=0, self.Applicants.Size - 1 do
                        if (self.Applicants:GetItem(k).Name == playerName) then
                            self:ApplicantInviteAccepted(player)
                            break
                        end
                    end
                    
                    local found = self.DungeonGroup.Members:ContainsWithEqualsFunction(player, function(item1, item2)
                        return item1.Name == item2.Name
                    end)
                    if (found == nil) then
                        ClassicLFG:DebugPrint(playerName .. " left the group.")
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
    return self
end

function ClassicLFGDungeonGroupManager:HandleDataRequest(object, sender)
    if (self.DungeonGroup and self.DungeonGroup.Leader.Name == UnitName("player")) then
        print(sender)
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.GroupListed,
            self.DungeonGroup,
            "WHISPER",
            sender)
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupJoined(dungeonGroup)
    
end

function ClassicLFGDungeonGroupManager:ListGroup(dungeonGroup)
    self.DungeonGroup = dungeonGroup
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Events.GroupListed,
        dungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
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
    self.DungeonGroup = object
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupJoined, self.DungeonGroup)
end

function ClassicLFGDungeonGroupManager:IsListed()
    return self.DungeonGroup ~= nil
end

function ClassicLFGDungeonGroupManager:DequeueGroup()
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Events.GroupDelisted,
        self.DungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
    self.DungeonGroup = nil
end

function ClassicLFGDungeonGroupManager:UpdateGroup(dungeonGroup)
    ClassicLFG.Network:SendObject(
        ClassicLFG.Config.Events.GroupUpdated,
        dungeonGroup,
        "CHANNEL",
        ClassicLFG.Config.Network.Channel.Id)
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

function ClassicLFGDungeonGroupManager:ApplicantDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantDeclined, applicant)
end

function ClassicLFGDungeonGroupManager:ApplicantInvited(applicant)
    InviteUnit(applicant.Name)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInvited, applicant)
end

function ClassicLFGDungeonGroupManager:ApplicantInviteAccepted(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteAccepted, applicant)
end

function ClassicLFGDungeonGroupManager:ApplicantInviteDeclined(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteDeclined, applicant)
end

ClassicLFG.DungeonGroupManager = ClassicLFGDungeonGroupManager()