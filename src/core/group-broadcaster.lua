ClassicLFGGroupBroadCaster = {}
ClassicLFGGroupBroadCaster.__index = ClassicLFGGroupBroadCaster

setmetatable(ClassicLFGGroupBroadCaster, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGGroupBroadCaster.new(dungeonGroup)
    local self = setmetatable({}, ClassicLFGGroupBroadCaster)
    self.DungeonGroup = dungeonGroup
    self.Canceled = false
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupListed, self, self.Cancel)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupDelisted, self, function(self, dungeonGroup) self:Cancel(dungeonGroup) end)
    return self
end

function ClassicLFGGroupBroadCaster:Start(time)
    ClassicLFG:DebugPrint("Started Group Broadcast Timer")
    C_Timer.After(time, function()
        if (self.Canceled == false) then
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupListed, self.DungeonGroup)
            ClassicLFG.PeerToPeer:StartBroadcastObject(ClassicLFG.Config.Events.GroupListed, self.DungeonGroup)
        end
    end)
end

function ClassicLFGGroupBroadCaster:Cancel(dungeonGroup)
    if (self.Canceled == false and dungeonGroup.Leader.Name == self.DungeonGroup.Leader.Name) then
        ClassicLFG:DebugPrint("Canceled Broadcast for the group of player " .. dungeonGroup.Leader.Name)
        self.Canceled = true
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.DungeonGroupBroadcasterCanceled, self.DungeonGroup)
    end 
end

