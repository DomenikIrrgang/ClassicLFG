ClassicLFGDungeonGroupManager = {}
ClassicLFGDungeonGroupManager.__index = ClassicLFGDungeonGroupManager

setmetatable(ClassicLFGDungeonGroupManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDungeonGroupManager.new()
    local self = setmetatable({}, ClassicLFGDungeonGroupManager)
    self.DungeonGroup = nil
    self.Applicants = ClassicLFGLinkedList()
    self.Frame = CreateFrame("Frame")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
    self.Frame:RegisterEvent("PARTY_LEADER_CHANGED")
    self.Frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        if(self:IsListed() and event == "PARTY_LEADER_CHANGED") then
            if (UnitIsGroupLeader(UnitName("player")) == false and self.BroadcastTicker ~= nil) then
                self:CancelBroadcast()
            end

            if (UnitIsGroupLeader(UnitName("player")) == true and self.BroadcastTicker == nil) then
                self:StartBroadcast()
            end

            for i = 0, self.DungeonGroup.Members.Size - 1 do
                local player = ClassicLFGLinkedList.GetItem(self.DungeonGroup.Members, i)
                
                if (UnitIsGroupLeader(player.Name) == true) then
                    local oldGroup = self.DungeonGroup
                    oldGroup.Leader = player
                    self:UpdateGroup(oldGroup)
                    break
                end
            end
        end

        if (event == "PLAYER_FLAGS_CHANGED") then
            if (UnitIsAFK("player") == true) then
                self:DequeueGroup()
            end
        end

        if (event == "CHAT_MSG_CHANNEL_JOIN") then
            local _, playerName, _, channelId, channelName = ...
            if (tonumber(channelId:sub(0,1)) == ClassicLFG.Config.Network.Channel.Id) then
                self:HandleDataRequest(nil, playerName)
            end
        end
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupKicked, self, self.OnGroupKicked)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupLeft, self, self.OnGroupLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDisbanded, self, self.OnGroupDisbanded)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupMemberLeft, self, self.OnGroupMemberLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupMemberJoined, self, self.OnGroupMemberJoined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupInviteDeclined, self, self.OnGroupInviteDeclined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.RequestData, self, self.HandleDataRequest)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplyForGroup, self, self.HandleApplications)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, self.HandleDungeonGroupJoined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, self, self.HandleDungeonGroupLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, self, self.HandleGroupDelisted)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, self, self.HandleGroupListed)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, self, self.HandleGroupUpdated)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupMemberLeft, self, self.HandleDungeonGroupMemberLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantDeclined, self, self.OnApplicantDeclined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ApplicantInviteDeclined, self, self.OnApplicantInviteDeclined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.InviteWhisperReceived, self, self.HandleInviteWhisperReceived)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupInviteAlreadyInGroup, self, self.OnGroupInviteAlreadyInGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.SyncApplicantList, self, self.OnSyncApplicantList)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerTalents, self, self.OnPlayerTalents)
    return self
end

function ClassicLFGDungeonGroupManager:OnPlayerTalents(object)
    local talents = object.Talents
    local name = object.Name
    for i = 0, self.DungeonGroup.Members.Size - 1 do
        if (ClassicLFGLinkedList.GetItem(self.DungeonGroup.Members, i).Name == name) then
            ClassicLFGLinkedList.GetItem(self.DungeonGroup.Members, i).Talents = talents
            self:UpdateGroup(self.DungeonGroup)
        end
    end
end

function ClassicLFGDungeonGroupManager:OnSyncApplicantList(applicantList)
    self.Applicants:Clear()
    for i = 0, applicantList.Size - 1 do
        self:HandleApplications(ClassicLFGLinkedList.GetItem(applicantList, i))
    end
end

function ClassicLFGDungeonGroupManager:OnGroupInviteAlreadyInGroup(playerName)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteDeclined, ClassicLFGPlayer(playerName, "", "", "", ""))
end

function ClassicLFGDungeonGroupManager:HandleInviteWhisperReceived(playerName)
    if (self:IsListed()) then
        ClassicLFG:WhoQuery(playerName, function(result)
            if (result) then
                if (result.fullGuildName == "") then
                    result.fullGuildName = nil
                end
                self:HandleApplications(ClassicLFGPlayer(playerName, result.fullGuildName, result.level, ClassicLFG.Class[result.filename].Name))
            end
        end)
    end
end

function ClassicLFGDungeonGroupManager:OnGroupKicked()
    if (self:IsListed()) then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:OnGroupLeft()
    if (self:IsListed()) then
        if (self.DungeonGroup.Leader.Name ~= UnitName("player")) then
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
        else
            self:DequeueGroup()
        end
    end
end

function ClassicLFGDungeonGroupManager:OnGroupDisbanded()
    if (self:IsListed()) then
        ClassicLFGLinkedList.Clear(self.DungeonGroup.Members)
        ClassicLFGLinkedList.AddItem(self.DungeonGroup.Members, ClassicLFGPlayer())
        self:UpdateGroup(self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:OnGroupMemberLeft(playerName)
    if(self:IsListed()) then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupMemberLeft, ClassicLFGPlayer(playerName))
    end
end

function ClassicLFGDungeonGroupManager:OnGroupMemberJoined(playerName)
    if(self:IsListed() and playerName) then
        local index = self.Applicants:Contains(ClassicLFGPlayer(playerName))
        if (index ~= nil) then
            self:ApplicantInviteAccepted(self.Applicants:GetItem(index))
        else
            self:ApplicantInviteAccepted(ClassicLFGPlayer(playerName))
        end
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.SyncApplicantList, self.Applicants, "WHISPER", playerName)
    end
end

function ClassicLFGDungeonGroupManager:OnGroupInviteDeclined(playerName)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteDeclined, ClassicLFGPlayer(playerName, "", "", "", ""))
end

function ClassicLFGDungeonGroupManager:CancelBroadcast()
    ClassicLFG:DebugPrint("Canceled broadcasting dungeon group")
    self.BroadcastTicker:Cancel()
    self.BroadcastTicker = nil
end

function ClassicLFGDungeonGroupManager:StartBroadcast()
    ClassicLFG:DebugPrint("Started broadcasting dungeon group")
    self.BroadcastTicker = C_Timer.NewTicker(ClassicLFG.DB.profile.BroadcastDungeonGroupInterval + math.random(0, 10), function()
        ClassicLFG:DebugPrint("Broadcast Ticker tick")
        if (self:IsListed()) then
            -- Prevent group from being delisted on other clients
            self:UpdateGroup(self.DungeonGroup)
            SendChatMessage(self:GetBroadcastMessage(), "CHANNEL", nil, GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel))
            self:CancelBroadcast()
            self:StartBroadcast()
        end
    end)
end

function ClassicLFGDungeonGroupManager:GetBroadcastMessage()
    if (self.DungeonGroup.Dungeon.Name == ClassicLFG.Dungeon.Custom.Name) then
        return self.DungeonGroup.Title
    else 
        return "LFM \"" .. self.DungeonGroup.Dungeon.Name .. "\": " .. self.DungeonGroup.Title
    end    
end


function ClassicLFGDungeonGroupManager:HandleDataRequest(object, sender)
    if (self.DungeonGroup ~= nil) then
        local characterName = sender:SplitString("-")[1]
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
        if (UnitIsGroupLeader(player.Name) == nil) then
            self:RemoveMember(player)
        end

        if (UnitIsGroupLeader("player") == true) then
            self:UpdateGroup(self.DungeonGroup)
        end
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupDelisted(dungeonGroup)
    if (self.DungeonGroup ~= nil and dungeonGroup.Hash == self.DungeonGroup.Hash) then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupLeft, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupListed(dungeonGroup)
    if (UnitIsGroupLeader(dungeonGroup.Leader.Name) == true and dungeonGroup.Source.Type == "ADDON") then
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupJoined, dungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:HandleGroupUpdated(dungeonGroup)
    if (self:IsListed() and dungeonGroup.Hash == self.DungeonGroup.Hash) then
        self.DungeonGroup = dungeonGroup
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupJoined(dungeonGroup)
    self.DungeonGroup = dungeonGroup
    if (UnitIsGroupLeader("player") == true or not IsInGroup()) then
        self:StartBroadcast()
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
    SendChatMessage(self:GetBroadcastMessage(), "CHANNEL", nil, GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel))
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
        self.DungeonGroup.UpdateTime = GetTime()
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.DungeonGroupUpdated,
            self.DungeonGroup,
            "CHANNEL",
            ClassicLFG.Config.Network.Channel.Id)
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupUpdated, self.DungeonGroup)
    end
end

function ClassicLFGDungeonGroupManager:HandleDungeonGroupLeft(dungeonGroup)
    if (dungeonGroup.Leader.Name == UnitName("player")) then
        self:CancelBroadcast()
    end
    self.Applicants:Clear()
    self.DungeonGroup = nil
end

function ClassicLFGDungeonGroupManager:HandleApplications(applicant)
    if (self:IsListed() and not ClassicLFG:IsInPlayersGroup(applicant.Name) and not ClassicLFG:IsIgnored(applicant.Name)) then
        local index = self.Applicants:ContainsWithEqualsFunction(applicant, function(item1, item2)
            return item1.Name == item2.Name
        end)
        if (index == nil) then
            self:AddApplicant(applicant)
             if (ClassicLFG.QueueWindow:IsShown() == false) then
                local text = ClassicLFG.Locale["New Applicant: "] .. applicant.Name .. ClassicLFG.Locale[" - Level "].. applicant.Level .. " "
                if (applicant.Talents ~= nil) then
                    text = text .. ClassicLFG.Locale[ClassicLFGPlayer.GetSpecialization(applicant).Name] .. " "
                end
                ClassicLFG:Print(text .. ClassicLFG.Locale[applicant.Class])
                PlaySound(SOUNDKIT.RAID_BOSS_EMOTE_WARNING)
            end
        end
        if (UnitIsGroupLeader("player")) then
            ClassicLFG.Network:SendObject(
                ClassicLFG.Config.Events.ApplyForGroup,
                applicant,
                "PARTY")
        end
    end
end

function ClassicLFGDungeonGroupManager:AddApplicant(applicant)
    self.Applicants:AddItem(applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantReceived, applicant)
    if(ClassicLFG.DB.profile.AutoInvite == true) then
        self:ApplicantInvited(applicant)
    end
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

function ClassicLFGDungeonGroupManager:OnApplicantDeclined(applicant)
    self:RemoveApplicant(applicant)
    if (not IsInGroup() or UnitIsGroupLeader("player") == true) then
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.DeclineApplicant, self.DungeonGroup, "WHISPER", applicant.Name)
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.ApplicantDeclined,
            applicant,
            "PARTY")
    end
end

function ClassicLFGDungeonGroupManager:ApplicantInvited(applicant)
    if (not IsInGroup() or UnitIsGroupLeader("player")) then
        InviteUnit(applicant.Name)
        applicant.Invited = true
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInvited, applicant)
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.ApplicantInvited, applicant, "PARTY")
    end
end

function ClassicLFGDungeonGroupManager:ApplicantInviteAccepted(applicant)
    self:RemoveApplicant(applicant)
    ClassicLFGDungeonGroup.AddMember(self.DungeonGroup, applicant)
    ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ApplicantInviteAccepted, applicant)

    if (self.DungeonGroup.Members.Size >= self.DungeonGroup.Dungeon.Size) then
        self:DequeueGroup()
    else
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.DungeonGroupJoined, self.DungeonGroup, "WHISPER", applicant.Name)
        if (UnitIsGroupLeader("player") == true) then
            self:UpdateGroup(self.DungeonGroup)
        end
    end
end

function ClassicLFGDungeonGroupManager:OnApplicantInviteDeclined(applicant)
    self:RemoveApplicant(applicant)
    if (UnitIsGroupLeader("player") == true) then
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.ApplicantInviteDeclined, applicant, "PARTY")
    end
end

ClassicLFG.DungeonGroupManager = ClassicLFGDungeonGroupManager()