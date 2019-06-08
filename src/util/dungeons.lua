ClassicLFG.DungeonList = {}
ClassicLFG.Dungeon = {}

function ClassicLFG:DefineDungeon(name, minLevel, maxLevel, location, abbreviations, faction)
    ClassicLFG.Dungeon[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviations = abbreviations
    }
    ClassicLFG.DungeonList[name] = name
end

function ClassicLFG:GetDungeonsByLevel(level)
    local dungeonsForLevel = {}
    for key in pairs(ClassicLFG.Dungeon) do
        local dungeon = ClassicLFG.Dungeon[key]
        if (dungeon.MinLevel <= level and dungeon.MaxLevel >= level) then
            dungeonsForLevel[dungeon.Name] = dungeon.Name
        end
    end
    return dungeonsForLevel
end

ClassicLFG:DefineDungeon("Ragefire Chasm", 13, 60, "Orgrimmar", {"rfc", "ragefire"}, ClassicLFG.Faction.HORDE)
ClassicLFG:DefineDungeon("Wailing Caverns", 16, 60, "Barrens", {"wc"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Deadmines", 17, 60, "Westfall", {"dm", "vc", "deadmines"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Shadowfang Keep", 22, 60, "Silverpine Forest", {"sfk", "shadowfang"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Blackfathom Deeps", 24, 60, "Ashenvale", {"bfd"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Stockade", 24, 60, "Stormwind", {"stockades"}, ClassicLFG.Faction.ALLIANCE)
ClassicLFG:DefineDungeon("Gnomeregan", 29, 60, "Dun Morogh", {"gnomeregan"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Razorfen Kraul", 24, 60, "Barrens", {"rfk", "kraul"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Scarlet Monastery: Graveyard", 28, 60, "Tirisfal Glades", {"SM GY"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Scarlet Monastery: Library", 32, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Scarlet Monastery: Armory", 36, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("The Scarlet Monastery: Cathedral", 38, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Razorfen Downs", 37, 60, "Barrens", {"rfd"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Uldaman", 41, 60, "Badlands", {"ulda"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Zul'Farak", 42, 60, "Tanaris", {"zf"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Maraudon", 46, 60, "Desolace", {"maraudon"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Temple of Atal'Hakkar", 50, 60, "Swamp of Sorrows", {"toa", "atal"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Blackrock Depths", 52, 60, "Blackrock Mountain", {"brd"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Lower Blackrock Spire", 55, 60, "Blackrock Mountain", {"lbrs"}, ClassicLFG.Faction.BOTH)
-- ToDo: Need to add all the Dungeon parts once they are released on Classic Realms
--ClassicLFG:DefineDungeon("Dire Maul", 55, 60, "Feralas", {"dm:"}, ClassicLFG.Faction.BOTH)
--
ClassicLFG:DefineDungeon("Stratholme", 58, 60, "Eastern Plaguelands", {"strat"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Scholomance", 58, 60, "Eastern Plaguelands", {"scholo"}, ClassicLFG.Faction.BOTH)
ClassicLFG:DefineDungeon("Custom", 1, 60, "Everywhere", {}, ClassicLFG.Faction.BOTH)