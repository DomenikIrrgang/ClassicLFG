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
    self.AppliedGroups = ClassicLFGLinkedList()
    self.Frame = CreateFrame("Frame")
    self.Frame:SetScript("OnEvent", function(_, event, ...) 

    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupUpdated, self, self.ReceiveGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, self, self.ReceiveGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, self, self.HandleDequeueGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, self.HandleDungeonGroupJoined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DeclineApplicant, self, self.HandleApplicationDeclined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChatDungeonGroupFound, self, self.HandleChatDungeonGroupFound)
    return self
end

function ClassicLFGGroupManager:ApplyForGroup(dungeonGroup)
    if (dungeonGroup.Leader.Name ~= UnitName("player")) then
        self.AppliedGroups:AddItem(dungeonGroup)
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.AppliedForGroup, dungeonGroup)
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.ApplyForGroup,
            ClassicLFGPlayer(),
            "WHISPER",
            dungeonGroup.Leader.Name)
    end
end

function ClassicLFGGroupManager:HandleChatDungeonGroupFound(dungeonGroup)
    if (not self:ContainsGroup(dungeonGroup)) then
        local broadCast = ClassicLFGGroupBroadCaster(dungeonGroup)
        broadCast:Start(math.random(1, ClassicLFG.Config.BroadcastInterval))
    end
end

function ClassicLFGGroupManager:WithdrawFromGroup(dungeonGroup)
    if (dungeonGroup.Leader.Name ~= UnitName("player")) then
        local index = self:HasGroup(self.AppliedGroups, dungeonGroup)
        if (index ~= nil) then
            self.AppliedGroups:RemoveItem(index)
            ClassicLFG.Network:SendObject(
                ClassicLFG.Config.Events.DungeonGroupWithdrawApplication,
                ClassicLFGPlayer(),
                "WHISPER",
                dungeonGroup.Leader.Name)
        end
    end
end

function ClassicLFGGroupManager:ContainsGroup(dungeonGroup)
    local groupIndex = self:HasGroup(self.Groups, dungeonGroup)
    return groupIndex ~= nil
end

function ClassicLFGGroupManager:HandleDungeonGroupJoined(dungeonGroup)
    for i = 0, self.AppliedGroups.Size - 1 do
        local group = self.AppliedGroups:GetItem(i)
        if (dungeonGroup.Hash ~= group.Hash) then
            ClassicLFG.Network:SendObject(
                ClassicLFG.Config.Events.DungeonGroupWithdrawApplication,
                ClassicLFGPlayer(),
                "WHISPER",
                group.Leader.Name)
        end
    end
    self.AppliedGroups:Clear()
end

function ClassicLFGGroupManager:HandleApplicationDeclined(dungeonGroup)
    ClassicLFG:Print("You have been declined by the group: \"" .. dungeonGroup.Title .. "\"")
end

function ClassicLFGGroupManager:HandleDequeueGroup(dungeonGroup)
    local index = self:HasGroup(self.Groups, dungeonGroup)
    if (index ~= nil) then
        self.Groups:RemoveItem(index)
    end
end

function ClassicLFGGroupManager:HasAppliedForGroup(dungeonGroup)
    for i = 0, self.AppliedGroups.Size - 1 do
        local group = self.AppliedGroups:GetItem(i)
        if (dungeonGroup.Hash ~= group.Hash) then
            return true
        end
    end
    return false
end

function ClassicLFGGroupManager:ReceiveGroup(dungeonGroup)
    local groupIndex = self:HasGroup(self.Groups, dungeonGroup)

    if (groupIndex ~= nil) then
        self.Groups:SetItem(groupIndex, dungeonGroup)
    else
        self.Groups:AddItem(dungeonGroup)
    end
end

function ClassicLFGGroupManager:HasGroup(group, dungeonGroup)
    for i=0, group.Size - 1 do
        if (group:GetItem(i).Hash== dungeonGroup.Hash) then
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