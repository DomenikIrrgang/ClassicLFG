ClassicLFGVersionAlert = {}
ClassicLFGVersionAlert.__index = ClassicLFGVersionAlert

setmetatable(ClassicLFGVersionAlert, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGVersionAlert.new()
    local self = setmetatable({}, ClassicLFGVersionAlert)
    self.Window = ClassicLFGWindow("ClassicLFGVersionAlert", UIParent, 310, 81)
    self.Window:SetTitle("ClassicLFG")
    self.Text = self.Window.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.Text:SetFont(ClassicLFG.Config.Font, 12, "NONE")
    self.Text:SetPoint("TOP", self.Window.Frame.Content, "TOP", 0, -5)
    self.Link = ClassicLFGEditBox(nil, self.Window.Frame)
    self.Link.Frame:SetPoint("TOPLEFT", self.Text, "BOTTOMLEFT", 0, -5);
    self.Link.Frame:SetPoint("BOTTOMRIGHT", self.Text, "BOTTOMRIGHT", 0, -27)
    self.Link.Frame:SetText("https://www.curseforge.com/wow/addons/classiclfg")
    self.Link.Frame:SetCursorPosition(1)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.NewVersionAvailable, self, self.OnNewVersionAvailable)
    return self
end

function ClassicLFGVersionAlert:OnNewVersionAvailable(version)
    self.Text:SetText("New Version (" .. version .. ") is available for download.")
    self.Window:Show()
end

ClassicLFG.VersionAlert = ClassicLFGVersionAlert()