ClassicLFGDungeonGroup = {}
ClassicLFGDungeonGroup.__index = ClassicLFGDungeonGroup

setmetatable(ClassicLFGDungeonGroup, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDungeonGroup.new(dungeon, leader, title, description, source, members)
    local self = setmetatable({}, ClassicLFGDungeonGroup)
    self.Hash = ClassicLFG:RandomHash(8)
    self.Leader = leader or ClassicLFGPlayer()
    self.Members = members or ClassicLFGLinkedList()
    self.Description = description or ""
    self.Title = title or ""
    self.Dungeon = dungeon or ClassicLFG.Dungeon["Custom"]
    self.Group = {
        Dps = 0,
        Tank = 0,
        Healer = 0
    }
    self.Source = source or { Type = "ADDON" }
    self.UpdateTime = GetTime()
    return self
end

function ClassicLFGDungeonGroup:AddMember(player)
    ClassicLFGLinkedList.AddItem(self.Members, player)
    ClassicLFG:DebugPrint("Added Group Member:" .. player.Name)
end

function ClassicLFGDungeonGroup:GetRoleCount(role)
    local count = 0
    for i = 0, self.Members.Size - 1 do
        if (ClassicLFGPlayer.GetSpecialization(ClassicLFGLinkedList.GetItem(self.Members, i)) ~= nil and ClassicLFGPlayer.GetSpecialization(ClassicLFGLinkedList.GetItem(self.Members, i)).Role.Name == role.Name) then
            count = count + 1
        else
            if (ClassicLFGPlayer.GetSpecialization(ClassicLFGLinkedList.GetItem(self.Members, i)) == nil and role.Name == ClassicLFG.Role.UNKNOWN.Name) then
                count = count + 1
            end 
        end
    end
    return count
end

function ClassicLFGDungeonGroup:ContainsMember(playerName)
    for i = 0, self.Members.Size - 1 do
        if (ClassicLFGLinkedList.GetItem(self.Members, i).Name == playerName) then
            return true
        end
    end
    return false
end

function ClassicLFGDungeonGroup:RemoveMember(player)
    self.Members:RemoveItemByComparison(player)
    ClassicLFG:DebugPrint("Removed Group Member: " .. player.Name)
end

function ClassicLFGDungeonGroup:Print()
    for key in pairs(self) do
        ClassicLFG:DebugPrint(key .. " " .. self[key])
    end
end

function ClassicLFGDungeonGroup:Equals(otherGroup)
    return self.Hash == otherGroup.Hash
end