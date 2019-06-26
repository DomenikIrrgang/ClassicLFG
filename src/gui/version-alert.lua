ClassicLFGVersionAlert = {}
ClassicLFGVersionAlert.__index = ClassicLFGVersionAlert

setmetatable(ClassicLFGVersionAlert, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGVersionAlert.new()
    local self = setmetatable({}, ClassicLFGVersionAlert)
    self.Window = ClassicLFGWindow("ClassicLFGVersionAlert", UIParent, 300, 70)
    self.Window:SetTitle("ClassicLFG")
    self.Text = self.Window.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.Text:SetFont(ClassicLFG.Config.Font, 12, "NONE")
    self.Text:SetPoint("CENTER", self.Window.Frame.Content, "CENTER", 0, 0)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.NewVersionAvailable, self, self.OnNewVersionAvailable)
    return self
end

function ClassicLFGVersionAlert:OnNewVersionAvailable(version)
    self.Text:SetText("New Version (" .. version .. ") is available for download.")
    self.Window:Show()
end

ClassicLFG.VersionAlert = ClassicLFGVersionAlert()