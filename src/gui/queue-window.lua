ClassicLFGQueueDungeonGroupWindow = {}
ClassicLFGQueueDungeonGroupWindow.__index = ClassicLFGQueueDungeonGroupWindow

setmetatable(ClassicLFGQueueDungeonGroupWindow, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

--table.inherit(ClassicLFGQueueDungeonGroupWindow, ClassicLFGWindow(parent, name, width, height))

function ClassicLFGQueueDungeonGroupWindow.new(parent)
    local self = setmetatable({}, ClassicLFGQueueDungeonGroupWindow)
    self.Frame = ClassicLFGWindow("ClassicLFGQueueDungeonFrame", parent, 250, 100)
    self.EditBox = ClassicLFGEditBox(nil, self.Frame.Frame.Content)
    self.EditBox.Frame:SetPoint("TOPLEFT", self.Frame.Frame.Content, "TOPLEFT", 8, -8)
    self.EditBox.Frame:SetPoint("BOTTOMRIGHT", self.Frame.Frame.Content, "TOPRIGHT", -8, -30)
    self.EditBox:SetPlaceholder(ClassicLFG.Locale["Note"])
    self.QueueButton = ClassicLFGButton(ClassicLFG.Locale["Queue"], self.Frame.Frame.Content)
    self.QueueButton:SetPoint("TOPLEFT", self.EditBox.Frame, "BOTTOMLEFT", 0, -5)
    self.QueueButton:SetPoint("BOTTOMRIGHT", self.EditBox.Frame, "BOTTOMRIGHT", 0, -27)
    self.QueueButton.OnClick = function() ClassicLFG.GroupManager:ApplyForGroup(self.DungeonGroup, self.EditBox.Frame:GetText()); self.Frame:Hide() end
    self.Frame:SetTitle(ClassicLFG.Locale["Queue Dungeon"])
    self.Frame.Frame:SetScript("OnShow", function() self.EditBox.Frame:SetText(ClassicLFG.DB.profile.InviteText) end)
    table.insert(UISpecialFrames, self.Frame.Frame:GetName())
    return self
end

ClassicLFG.QueueDungeonGroupWindow = ClassicLFGQueueDungeonGroupWindow(UIParent, nil, 300, 300)