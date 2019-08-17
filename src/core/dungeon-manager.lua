ClassicLFGDungeonManager = {}
ClassicLFGDungeonManager.__index = ClassicLFGDungeonManager

setmetatable(ClassicLFGDungeonManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDungeonManager.new()
    local self = setmetatable({}, ClassicLFGDungeonManager)
    self.Frame = CreateFrame("Frame", nil, nil, nil)
    self.DungeonList = {}
    self.Dungeons = {}
    return self
end

function ClassicLFGDungeonManager:GetAllDungeons()
    return self.DungeonList
end

function ClassicLFGDungeonManager:GetAvailableDungeons()
    return self:GetDungeonsByLevel(UnitLevel("player"))
end

function ClassicLFGDungeonManager:DefineDungeon(name, size, minLevel, maxLevel, location, abbreviation, abbreviations, faction, background)
    self.Dungeons[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviation = abbreviation,
        Abbreviations = abbreviations,
        Background = background,
        Size = size
    }
    self.DungeonList[name] = name
end

function ClassicLFGDungeonManager:GetDungeonsByLevel(level)
    local dungeonsForLevel = {}
    for key in pairs(self.Dungeons) do
        local dungeon = self.Dungeons[key]
        if (dungeon.MinLevel <= level and dungeon.MaxLevel >= level) then
            dungeonsForLevel[dungeon.Name] = dungeon.Name
        end
    end
    return dungeonsForLevel
end

function ClassicLFGDungeonManager:GetAllDungeonNames()
    local dungeonNames = {}
    for key, value in pairs(self.Dungeons) do
        table.insert(dungeonNames, value.Name)
    end
    return dungeonNames
end

ClassicLFG.DungeonManager = ClassicLFGDungeonManager()