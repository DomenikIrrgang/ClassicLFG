ClassicLFGPlayerManager = {}
ClassicLFGPlayerManager.__index = ClassicLFGPlayerManager

setmetatable(ClassicLFGPlayerManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGPlayerManager.new()
    local self = setmetatable({}, ClassicLFGPlayerManager)
    self.Frame = CreateFrame("Frame", nil, nil, nil)
    self.Frame:RegisterEvent("PLAYER_LEVEL_CHANGED")
    self.Frame:SetScript("OnEvent", function(_, event, _, newLevel)
        ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ChangePlayerLevel, newLevel)
    end)
    return self
end

ClassicLFG.PlayerManager = ClassicLFGPlayerManager()