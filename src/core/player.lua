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
    self.Name = ClassicLFG:SplitString(name, "-")[0] or UnitName("player")
    print(self.Name)
    self.Guild = guild or GetGuildInfo(self.Name)
    self.Level = level or UnitLevel(self.Name)
    self.Class = class or ClassicLFG.Class[select(2, UnitClass(self.Name))].Name
    self.Talents = talents or self:CreateTalents()
    return self
end

function ClassicLFGPlayer:CreateTalents()
    if(self.Name == UnitName("player")) then
        local talents = {}
        talents[1] = select(3, GetTalentTabInfo(1))
        talents[2] = select(3, GetTalentTabInfo(2))
        talents[3] = select(3, GetTalentTabInfo(3))
        return talents
    end
    return nil
end

function ClassicLFGPlayer:GetSpecialization()
    local highestTalents = 1
    if (self.Talents[2] > self.Talents[highestTalents]) then
        highestTalents = 2
    end
    if (self.Talents[3] > self.Talents[highestTalents]) then
        highestTalents = 3
    end
    return ClassicLFG.Class[self.Class:upper()].Specialization[highestTalents]
end

function ClassicLFGPlayer:Equals(otherPlayer)
    return otherPlayer.Name == self.Name
end