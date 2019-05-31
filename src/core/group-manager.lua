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
    self.Frame = CreateFrame("Frame")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL_JOIN")
    self.Frame:SetScript("OnEvent", function(_, event, ...) 
        if (event == "CHAT_MSG_CHANNEL_JOIN") then
            local _, playerName, _, channelId, channelName = ...
            if (tonumber(channelId:sub(0,1)) == ClassicLFG.Config.Network.Channel.Id) then
                self:HandleDataRequest(nil, playerName)
            end
        end
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupUpdated, self, self.ReceiveGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, self, self.ReceiveGroup)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, self, self.HandleDequeueGroup)
    return self
end

function ClassicLFGGroupManager:ApplyForGroup(dungeonGroup)
    if (dungeonGroup.Leader.Name ~= UnitName("player")) then
        ClassicLFG.Network:SendObject(
            ClassicLFG.Config.Events.ApplyForGroup,
            ClassicLFGPlayer(),
            "WHISPER",
            dungeonGroup.Leader.Name)
    end
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