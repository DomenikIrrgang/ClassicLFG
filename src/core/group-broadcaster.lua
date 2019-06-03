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
    return self
end

function ClassicLFGGroupBroadCaster:Start(time)
    C_Timer.After(time, function()
        if (self.Canceled == false) then
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupListed, self.DungeonGroup)
            print(self.DungeonGroup.Leader.Name)
            ClassicLFG.Network:SendObject(
                ClassicLFG.Config.Events.GroupListed,
                self.DungeonGroup,
                "CHANNEL",
                ClassicLFG.Config.Network.Channel.Id)
        end
    end)
end

function ClassicLFGGroupBroadCaster:Cancel(dungeonGroup)
    if (dungeonGroup.Leader.Name == self.DungeonGroup.Leader.Name) then
        self.Canceled = true
    end 
end