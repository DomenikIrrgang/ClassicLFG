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
    if (name ~= nil) then
        self.Name = name:SplitString("-")[1]
    else
        self.Name = UnitName("player")
    end
    self.Guild = guild or GetGuildInfo(self.Name)
    self.Level = level or UnitLevel(self.Name)
    if (UnitClass(self.Name) ~= nil) then
        self.Class = class or ClassicLFG.Class[select(2, UnitClass(self.Name))].Name
    else
        -- ToDo: Get Class from Player differently somehow, cant get it using UnitClass if the player is not in your group
        self.Class = class or ClassicLFG.Class.WARRIOR.Name
    end
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
    if (self.Talents ~= nil) then
        local highestTalents = 1
        if (self.Talents[2] > self.Talents[highestTalents]) then
            highestTalents = 2
        end
        if (self.Talents[3] > self.Talents[highestTalents]) then
            highestTalents = 3
        end
        return ClassicLFG.Class[self.Class:upper()].Specialization[highestTalents]
    else
        return nil
    end
end

function ClassicLFGPlayer:Equals(otherPlayer)
    return otherPlayer.Name == self.Name
end