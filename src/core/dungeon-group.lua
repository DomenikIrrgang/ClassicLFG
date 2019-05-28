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
    self.Applicants = {}
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
end

function ClassicLFGDungeonGroup:RemoveMember(player)
    self.Members:RemoveItemByComparison(player)
end

function ClassicLFGDungeonGroup:Print()
    for key in pairs(self) do
        print(key, self[key])
    end
end

--ClassicLFG.ExampleGroup = ClassicLFGDungeonGroup(ClassicLFG.Dungeon["The Deadmines"], ClassicLFGPlayer("Suaddon"), "LF 1 Tank 1 Healer 2 DPS", "We are looking for a Tank.")
--ClassicLFG.ExampleGroup:AddMember(ClassicLFGPlayer("Suaddon"))
--ClassicLFG.ExampleGroup:RemoveMember(ClassicLFGPlayer("Suaddon"))