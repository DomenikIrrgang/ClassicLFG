CLassicLFGGroupList = {}
CLassicLFGGroupList.__index = CLassicLFGGroupList

setmetatable(CLassicLFGGroupList, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

local GroupEntry1 = {
    Title = "LFM DM TANK NO SUCKERS",
    Description = "We are looking for one THICC Tank and DPS! Please dont be bad, atleast r.io 2k+! Please dont be bad, atleast r.io 2k+! Please dont be bad, atleast r.io 2k+!",
    Dungeon = {
        Name = "The Deadmines"
    },
    Group = {
        Healer = 1,
        Tank = 0,
        Dps = 2
    },
    Source = {
        Type = "ADDON",
        Leader = {
            Name = "Suu",
            Class = "Warrior",
            Level = 60
        }
    }
}

local GroupEntry2 = {
    Title = "LFM RFC TANK",
    Description = "We are looking for one THICK Tank and DPS!",
    Dungeon = {
        Name = "Ragefire Chasm"
    },
    Group = {
        Healer = 1,
        Tank = 0,
        Dps = 3
    },
    Leader = {
        Name = "Suu",
        Class = "Warrior",
        Level = 60
    },
    Source = {
        Type = "CHAT",
        Channel = "Trade",
    }
}


function CLassicLFGGroupList.new(parent, anchor, width, height)
    local self = setmetatable({}, CLassicLFGGroupList)
    self.Frame = CreateFrame("Frame", nil, parent, nil)
    self.Frame:SetSize(width, height);
    self.Frame:SetPoint(anchor);
    self.Entries = {}
    self:Init(50)
    return self
end

function CLassicLFGGroupList:Init(count)
    local Item1 = CLassicLFGGroupListItem(nil, self.Frame, "TOPLEFT", 2)
    local Previous = CLassicLFGGroupListItem(nil, Item1.Frame, "BOTTOMLEFT", 4)
    self.Entries[1] = Item1
    self.Entries[2] = Previous
    Item1.Frame:Hide()
    Previous.Frame:Hide()

    for i=3,count do
        local Next = CLassicLFGGroupListItem(nil, Previous.Frame, "BOTTOMLEFT", 4)
        self.Entries[i] = Next
        Next.Frame:Hide()
        Previous = Next
    end
    --ClassicLFG:RecursivePrint(self.Entries, 1)
end

function CLassicLFGGroupList:SetDungeonGroups(dungeonGroups)
    for i=1, #dungeonGroups do
        self.Entries[i]:SetGroup(dungeonGroups[i])
        self.Entries[i].Frame:Show()
    end

    for i=#dungeonGroups + 1, #self.Entries do
        self.Entries[i].Frame:Hide()
    end
end