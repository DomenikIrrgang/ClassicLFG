ClassicLFGPlayerBroadCaster = {}
ClassicLFGPlayerBroadCaster.__index = ClassicLFGPlayerBroadCaster

setmetatable(ClassicLFGPlayerBroadCaster, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGPlayerBroadCaster.new(dungeonGroup)
    local self = setmetatable({}, ClassicLFGPlayerBroadCaster)
    self.DungeonGroup = dungeonGroup
    self.Canceled = false
    --ClassicLFG:DebugPrint("ClassicLFGPlayerBroadCaster Player Broadcaster " .. self.DungeonGroup.Title)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerListed, self, self.Cancel)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerDelisted, self, function(self, dungeonGroup) self:Cancel(dungeonGroup) end)
    return self
end

function ClassicLFGPlayerBroadCaster:Start(time)
    ClassicLFG:DebugPrint("Started Player Broadcast Timer")
    C_Timer.After(time, function()
        if (self.Canceled == false) then
            ClassicLFG:DebugPrint("PublishEvent Player Broadcaster " .. self.DungeonGroup.Title)
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.PlayerListed, self.DungeonGroup)
            -- ClassicLFG.Network:SendObject(
            --     ClassicLFG.Config.Events.PlayerListed,
            --     self.DungeonGroup,
            --     "CHANNEL",
            --     ClassicLFG.Config.Network.Channel.Id)
        end
    end)
end

function ClassicLFGPlayerBroadCaster:Cancel(dungeonGroup)
    if (self.Canceled == false and dungeonGroup.Leader.Name == self.DungeonGroup.Leader.Name) then
        ClassicLFG:DebugPrint("Canceled Broadcast for the LFG of player " .. dungeonGroup.Leader.Name)
        self.Canceled = true
        --ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonPlayerBroadcasterCanceled, self.DungeonGroup)
    end 
end

