ClassicLFGPlayer = {}
ClassicLFGPlayer.__index = ClassicLFGPlayer

setmetatable(ClassicLFGPlayer, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGPlayer.new(name, guild, level, class, talents)
    local self = setmetatable({}, ClassicLFGPlayer)
    self.Invited = false
    self.Name = name or UnitName("player")
    self.Guild = guild or GetGuildInfo(self.Name)
    self.Level = level or UnitLevel(self.Name)
    self.Class = Class or ClassicLFG.Class[select(2, UnitClass(self.Name))].Name
    self.Talents = talents
    return self
end

function ClassicLFGPlayer:Equals(otherPlayer)
    return otherPlayer.Name == self.Name
end

--ClassicLFG.ExamplePlayer = ClassicLFGPlayer("Suaddon")