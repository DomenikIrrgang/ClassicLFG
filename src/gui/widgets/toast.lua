ClassicLFGToast = {}
ClassicLFGToast.__index = ClassicLFGToast

setmetatable(ClassicLFGToast, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGToast.new(x, y, width, height)
    local self = setmetatable({}, ClassicLFGToast)
    self.Window = ClassicLFGWindow("ClassicLFGToast", UIParent, width, height)
    self.Window:SetTitle("Toast")
    self.Window:SetMovable(false)
    self.Duration = 5
    self.Window.Frame.CloseButton.Frame:Hide()
    self.Window.Frame:SetFrameStrata("TOOLTIP")
    self.Window.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
    self.Window.Frame:SetScript("OnShow", function()
        C_Timer.After(self.Duration, function()
            self.Window:Hide()
        end)
    end)
    self.Window.Frame:SetScript("OnHide", function()
        self.OnToastFinished()
    end)
    self.Window.Frame:SetScript("OnMouseUp", function()
        if (self.Window.Frame:IsVisible() and self.OnClick and self.OnClick.Callback) then
            self.OnClick.Callback(self.OnClick.Object)
        end
    end)
    self.Text = self.Window.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.Text:SetFont(ClassicLFG.Config.Font, 10, "NONE")
    self.Text:SetPoint("LEFT", self.Window.Frame.Content, "LEFT", 8, 0)
    self.Text:SetWidth(width - 16)
    self.Text:SetJustifyH("LEFT")
    self.Text:SetNonSpaceWrap(true)
    return self
end

function ClassicLFGToast:Show(title, message, duration, object, callback)
    if (duration) then
        self.Duration = duration
    end
    self.OnClick = { Object = object, Callback = callback }
    self.Window:SetTitle(title)
    self.Text:SetText(message)
    self.Window.Frame:SetHeight(self.Window.Frame.TitleBar:GetHeight() + self.Text:GetHeight() + 16)
    self.Window:Show()
end

function ClassicLFGToast:OnToastFinished()
end

ClassicLFG.Toast = ClassicLFGToast(300, -300, 270, 60)
