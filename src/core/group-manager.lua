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
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.RequestData, self, self.HandleDataRequest)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.PostGroup, self, self.ReceiveGroup)
    ClassicLFG.Network:AddMessageCallback(ClassicLFG.Config.Network.Prefixes.DequeueGroup, self, self.HandleDequeueGroup)
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