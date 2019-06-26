ClassicLFGSlider = {}
ClassicLFGSlider.__index = ClassicLFGSlider

setmetatable(ClassicLFGSlider, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGSlider.new(title, name, parent)
    local self = setmetatable({}, ClassicLFGSlider)
    self.Disabled = false
    self.Frame = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    self.Frame.Thumb:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    self.Frame.Thumb:SetWidth(15)
    self.Frame.Thumb:SetHeight(10)
    self.Frame.Thumb:SetColorTexture(
        ClassicLFG.Config.PrimaryColor.Red,
        ClassicLFG.Config.PrimaryColor.Green,
        ClassicLFG.Config.PrimaryColor.Blue,
        ClassicLFG.Config.PrimaryColor.Alpha
    )
    self.Frame:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
    ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.PrimaryColor)

    self.Frame.Low:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT", 0, -5)
    self.Frame.High:SetPoint("TOPRIGHT", self.Frame, "BOTTOMRIGHT", 0, -5)
    self.Frame.Low:SetFont(ClassicLFG.Config.Font, 12, "NONE")
    self.Frame.High:SetFont(ClassicLFG.Config.Font, 12, "NONE")

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.Title:SetPoint("BOTTOM", self.Frame, "TOP", 0, 5)
    self.Frame.Title:SetText(title)

    self.Frame.CurrentValue = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.CurrentValue:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.CurrentValue:SetPoint("TOP", self.Frame, "BOTTOM", 0, -5)
    
    self.Frame:SetScript("OnValueChanged", function(_, value)
        self.Frame.CurrentValue:SetText(value)
        self:OnValueChanged(value)
    end)

    self.Frame:SetScript("OnMouseDown", function()
        PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
    end)

    self.Frame:Show()
    return self
end

function ClassicLFGSlider:SetSliderValues(min, max, step)
    self.Frame.Low:SetText(min)
    self.Frame.High:SetText(max)
    self.Frame:SetMinMaxValues(min, max)
    self.Frame:SetValueStep(step)
    self.Frame:SetStepsPerPage(step)
    self.Frame:SetObeyStepOnDrag(true)
end

function ClassicLFGSlider:OnValueChanged(value)
end