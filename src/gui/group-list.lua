CLassicLFGGroupList = {}
CLassicLFGGroupList.__index = CLassicLFGGroupList

setmetatable(CLassicLFGGroupList, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CLassicLFGGroupList.new(parent, width, height)
    local self = setmetatable({}, CLassicLFGGroupList)
    self.Frame = CreateFrame("Frame", nil, parent, nil)
    self.Frame:SetSize(width, height);
    self.Frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0);
    self.Entries = {}
    self:Init(50)
    return self
end

function CLassicLFGGroupList:Init(count)
    local Item1 = CLassicLFGGroupListItem(nil, self.Frame, "TOPLEFT", 0)
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