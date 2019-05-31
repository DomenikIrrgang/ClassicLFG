ClassicLFGDungeonGroup = {}
ClassicLFGDungeonGroup.__index = ClassicLFGDungeonGroup

setmetatable(ClassicLFGDungeonGroup, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDungeonGroup.new(dungeon, leader, title, description, source, members)
    local self = setmetatable({}, ClassicLFGDungeonGroup)
    self.Leader = leader or ClassicLFGPlayer()
    self.Members = members or ClassicLFGLinkedList()
    self.Description = description or ""
    self.Title = title or ""
    self.Dungeon = dungeon or ClassicLFG.Dungeon["The Deadmines"]
    self.Group = {
        Dps = 0,
        Tank = 0,
        Healer = 0
    }
    self.Source = source or { Type = "ADDON" }
    return self
end

function ClassicLFGDungeonGroup:AddMember(player)
    self.Members:AddItem(player)
    ClassicLFG:DebugPrint("Added Group Member")
    ClassicLFG:DebugPrint(player.Name)
end

function ClassicLFGDungeonGroup:Sync()
    ClassicLFG:DebugPrint("Start Syncing DungeonGroup Members")
    self.Members = ClassicLFGLinkedList()
    for i = 1, GetNumGroupMembers() do
        local playerName = GetRaidRosterInfo(i)
        if (UnitIsGroupLeader(playerName)) then
            self.Leader = ClassicLFGPlayer(playerName)
        end
        self:AddMember(ClassicLFGPlayer(playerName))
    end
    ClassicLFG:DebugPrint("Finished Syncing DungeonGroup Members")
end

function ClassicLFGDungeonGroup:RemoveMember(player)
    self.Members:RemoveItemByComparison(player)
end

function ClassicLFGDungeonGroup:Print()
    for key in pairs(self) do
        ClassicLFG:DebugPrint(key, self[key])
    end
end