ClassicLFG.DungeonList = {}
ClassicLFG.Dungeon = {}

function ClassicLFG:DefineDungeon(name, minLevel, maxLevel, location, abbreviations, faction, background)
    ClassicLFG.Dungeon[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviations = abbreviations,
        Background = background
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

function ClassicLFG:GetAllDungeonNames()
    local dungeonNames = {}
    for key, value in pairs(ClassicLFG.Dungeon) do
        table.insert(dungeonNames, value.Name)
    end
    return dungeonNames
end

ClassicLFG:DefineDungeon("Ragefire Chasm", 12, 60, "Orgrimmar", {"rfc", "ragefire"}, ClassicLFG.Faction.HORDE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAGEFIRECHASM")
ClassicLFG:DefineDungeon("Wailing Caverns", 16, 60, "Barrens", {"wc"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-WAILINGCAVERNS")
ClassicLFG:DefineDungeon("The Deadmines", 15, 60, "Westfall", {"dm", "vc", "deadmines"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES")
ClassicLFG:DefineDungeon("Shadowfang Keep", 18, 60, "Silverpine Forest", {"sfk", "shadowfang"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SHADOWFANGKEEP")
ClassicLFG:DefineDungeon("Blackfathom Deeps", 21, 60, "Ashenvale", {"bfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKFATHOMDEEPS")
ClassicLFG:DefineDungeon("The Stockades", 21, 60, "Stormwind", {"stockades"}, ClassicLFG.Faction.ALLIANCE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STORMWINDSTOCKADES")
ClassicLFG:DefineDungeon("Gnomeregan", 26, 60, "Dun Morogh", {"gnomeregan"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-GNOMEREGAN")
ClassicLFG:DefineDungeon("Razorfen Kraul", 23, 60, "Barrens", {"rfk", "kraul"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENKRAUL")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Graveyard", 26, 60, "Tirisfal Glades", {"SM GY"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Library", 30, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Armory", 33, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Cathedral", 35, 60, "Tirisfal Glades", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("Razorfen Downs", 34, 60, "Barrens", {"rfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENDOWNS")
ClassicLFG:DefineDungeon("Uldaman", 37, 60, "Badlands", {"ulda"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ULDAMAN")
ClassicLFG:DefineDungeon("Zul'Farak", 40, 60, "Tanaris", {"zf"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ZULFARAK")
ClassicLFG:DefineDungeon("Maraudon", 44, 60, "Desolace", {"maraudon"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MARAUDON")
ClassicLFG:DefineDungeon("Temple of Atal'Hakkar", 47, 60, "Swamp of Sorrows", {"toa", "atal"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SUNKENTEMPLE")
ClassicLFG:DefineDungeon("Blackrock Depths", 49, 60, "Blackrock Mountain", {"brd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKDEPTHS")
ClassicLFG:DefineDungeon("Lower Blackrock Spire", 55, 60, "Blackrock Mountain", {"lbrs"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
-- ToDo: Need to add all the Dungeon parts once they are released on Classic Realms
--ClassicLFG:DefineDungeon("Dire Maul", 55, 60, "Feralas", {"dm:"}, ClassicLFG.Faction.BOTH)
--
ClassicLFG:DefineDungeon("Stratholme", 58, 60, "Eastern Plaguelands", {"strat"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STRATHOLME")
ClassicLFG:DefineDungeon("Scholomance", 58, 60, "Eastern Plaguelands", {"scholo"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCHOLOMANCE")
ClassicLFG:DefineDungeon("Custom", 1, 120, "Everywhere", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW")