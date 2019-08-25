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
    self:Init(100)
    self.NoResults = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.NoResults:ClearAllPoints();
    self.NoResults:SetFontObject("GameFontHighlight");
    self.NoResults:SetPoint("TOP", self.Frame, "TOP", 0, -50);
    self.NoResults:SetText(ClassicLFG.Locale["No groups found!"])
    self.NoResults:Hide()
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
    self:SortGroupByFriendsAndGuild(dungeonGroups)
    for i=1, #dungeonGroups do
        self.Entries[i]:SetGroup(dungeonGroups[i])
        self.Entries[i].Frame:Show()
    end

    for i=#dungeonGroups + 1, #self.Entries do
        self.Entries[i].Frame:Hide()
    end

    if (#dungeonGroups == 0) then
        self.NoResults:Show()
    else
        self.NoResults:Hide()
    end
end

function CLassicLFGGroupList:SortGroupByFriendsAndGuild(dungeonGroups)
    table.sort(dungeonGroups, function(item1, item2)
        if (ClassicLFG:IsInPlayersGuild(item1.Leader.Name) == true and not ClassicLFG:IsInPlayersGuild(item2.Leader.Name) ) then
            return true
        end
        if (ClassicLFG:PlayerIsFriend(item1.Leader.Name) == true and not ClassicLFG:PlayerIsFriend(item2.Leader.Name) == true) then
            return true
        end
        return false
    end)
end