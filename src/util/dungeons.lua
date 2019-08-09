ClassicLFG.DungeonList = {}
ClassicLFG.Dungeon = {}

function ClassicLFG:DefineDungeon(name, size, minLevel, maxLevel, location, abbreviations, faction, background)
    ClassicLFG.Dungeon[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviations = abbreviations,
        Background = background,
        Size = size
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

ClassicLFG:DefineDungeon("Ragefire Chasm", 5, 12, 21, "Orgrimmar", {"rfc", "ragefire"}, ClassicLFG.Faction.HORDE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAGEFIRECHASM")
ClassicLFG:DefineDungeon("Wailing Caverns", 5, 16, 25, "Barrens", {"wc"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-WAILINGCAVERNS")
ClassicLFG:DefineDungeon("The Deadmines", 5, 15, 24, "Westfall", {"dm", "vc", "deadmines"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES")
ClassicLFG:DefineDungeon("Shadowfang Keep", 5, 18, 27, "Silverpine Forest", {"sfk", "shadowfang"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SHADOWFANGKEEP")
ClassicLFG:DefineDungeon("Blackfathom Deeps", 5, 21, 30, "Ashenvale", {"bfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKFATHOMDEEPS")
ClassicLFG:DefineDungeon("The Stockades", 5, 21, 30, "Stormwind", {"stockades", "stocks"}, ClassicLFG.Faction.ALLIANCE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STORMWINDSTOCKADES")
ClassicLFG:DefineDungeon("Gnomeregan", 5, 26, 35, "Dun Morogh", {"gnomeregan", "gnomer"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-GNOMEREGAN")
ClassicLFG:DefineDungeon("Razorfen Kraul", 5, 23, 32, "Barrens", {"rfk", "kraul"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENKRAUL")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Graveyard", 5, 26, 35, "Tirisfal Glades", {"sm", "SM GY"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Library", 5, 30, 39, "Tirisfal Glades", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Armory", 5, 33, 42, "Tirisfal Glades", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("The Scarlet Monastery: Cathedral", 5, 35, 44, "Tirisfal Glades", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
ClassicLFG:DefineDungeon("Razorfen Downs", 5, 34, 43, "Barrens", {"rfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENDOWNS")
ClassicLFG:DefineDungeon("Uldaman", 5, 36, 45, "Badlands", {"ulda"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ULDAMAN")
ClassicLFG:DefineDungeon("Zul'Farak", 5, 40, 50, "Tanaris", {"zf"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ZULFARAK")
ClassicLFG:DefineDungeon("Maraudon", 5, 44, 54, "Desolace", {"maraudon", "mara"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MARAUDON")
ClassicLFG:DefineDungeon("Temple of Atal'Hakkar", 5, 47, 60, "Swamp of Sorrows", {"toa", "atal", "sunken temple"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SUNKENTEMPLE")
ClassicLFG:DefineDungeon("Blackrock Depths", 5, 49, 60, "Blackrock Mountain", {"brd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKDEPTHS")
ClassicLFG:DefineDungeon("Lower Blackrock Spire", 10, 55, 60, "Blackrock Mountain", {"lbrs"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
ClassicLFG:DefineDungeon("Upper Blackrock Spire", 10, 55, 60, "Blackrock Mountain", {"ubrs"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
-- ToDo: Need to add all the Dungeon parts once they are released on Classic Realms
--ClassicLFG:DefineDungeon("Dire Maul", 55, 60, "Feralas", {"dm:"}, ClassicLFG.Faction.BOTH)
--
ClassicLFG:DefineDungeon("Stratholme", 5, 58, 60, "Eastern Plaguelands", {"strat"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STRATHOLME")
ClassicLFG:DefineDungeon("Scholomance", 5, 58, 60, "Eastern Plaguelands", {"scholo"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCHOLOMANCE")
ClassicLFG:DefineDungeon("Molten Core", 40, 60, 60, "Blackrock Depths", {"mc"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MOLTENCORE")
ClassicLFG:DefineDungeon("Onyxia's Lair", 40, 60, 60, "Dustwallow Marsh", {"ony", "onyxia"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\LFGIcon-OnyxiaEncounter")
ClassicLFG:DefineDungeon("Custom", 40, 1, 120, "Everywhere", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW")