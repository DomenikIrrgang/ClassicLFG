ClassicLFGTooltip = {}
ClassicLFGTooltip.__index = ClassicLFGTooltip

setmetatable(ClassicLFGTooltip, {
    __call = function (cls, ...)
    return cls.new(...)
    end,
})

function ClassicLFGTooltip.new(parent)
    local self = setmetatable({}, ClassicLFGTooltip)
    self.Frame = CreateFrame("Frame", nil, UIParent, nil)
    self.Frame:SetSize(150, 30)
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeSize = 16, tileEdge = true
    })
    self.Frame:SetBackdropColor(ClassicLFG.Config.BackgroundColor.Red,
        ClassicLFG.Config.BackgroundColor.Green,
        ClassicLFG.Config.BackgroundColor.Blue,
        ClassicLFG.Config.BackgroundColor.Alpha)
    self.Frame:SetFrameStrata("TOOLTIP")
    self.Frame.Text = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Text:SetFont(ClassicLFG.Config.Font, 11, "NONE");
    self.Frame.Text:SetPoint("LEFT", self.Frame, "LEFT", 5, 0);
    self.Frame:SetScript("OnUpdate", function()
        if (self.Frame:IsShown() == true) then
            local x, y = GetCursorPosition()
            x, y = x / UIParent:GetEffectiveScale(), y / UIParent:GetEffectiveScale()
            self.Frame:SetPoint("TOPLEFT", x, y - GetScreenHeight() + 30)
        end
    end)
    self.Frame:Hide()
    return self
end

function ClassicLFGTooltip:SetText(text)
    self.Frame.Text:SetText(text)
    self.Frame:SetWidth(self.Frame.Text:GetStringWidth() + 10)
end
