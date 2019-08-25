ClassicLFGCheckBox= {}
ClassicLFGCheckBox.__index = ClassicLFGCheckBox

setmetatable(ClassicLFGCheckBox, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGCheckBox.new(text, parent, text)
    local self = setmetatable({}, ClassicLFGCheckBox)
    self.Frame = CreateFrame("Frame", nil, parent, nil)
    self.Selected = false
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    self.Frame:SetBackdropColor(ClassicLFG.Config.PrimaryColor.Red,
        ClassicLFG.Config.PrimaryColor.Green,
        ClassicLFG.Config.PrimaryColor.Blue,
        ClassicLFG.Config.PrimaryColor.Alpha)
    self.Frame:SetBackdropBorderColor(1,1,1,1)

    self.Frame.Thumb = self.Frame:CreateTexture(nil, "ARTWORK")
    self.Frame.Thumb:SetTexture("Interface\\Button\\UI-Checkbox-Check")
    self.Frame.Thumb:SetWidth(15)
    self.Frame.Thumb:SetHeight(15)
    self.Frame.Thumb:SetColorTexture(
        ClassicLFG.Config.BackgroundColor.Red,
        ClassicLFG.Config.BackgroundColor.Green,
        ClassicLFG.Config.BackgroundColor.Blue,
        ClassicLFG.Config.BackgroundColor.Alpha
    )
    self.Frame.Thumb:SetPoint("LEFT", self.Frame, "LEFT", 5, 0)

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.Title:SetPoint("LEFT", self.Frame.Thumb, "RIGHT", 8, 0)
    self.Frame.Title:SetText(text)

    self.Frame:SetScript("OnEnter", function()
        self.Frame.Thumb:SetColorTexture(
            ClassicLFG.Config.SecondaryColor.Red,
            ClassicLFG.Config.SecondaryColor.Green,
            ClassicLFG.Config.SecondaryColor.Blue,
            ClassicLFG.Config.SecondaryColor.Alpha
    )
    end)

    self.Frame:SetScript("OnLeave", function()
        if (self.Selected == true) then
            self:Select()
        else
            self:Deselect()
        end
    end)

    self.Frame:SetScript("OnMouseUp", function()
        self:SetState(not self.Selected)
    end)

    self.Frame:SetScript("OnMouseDown", function()
        PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
        self:OnMouseDown()
    end)
    return self
end

function ClassicLFGCheckBox:SetState(selected)
    self.Selected = selected
    if (selected == true) then
        self:Select()
    else
        self:Deselect()
    end
    self:OnValueChanged(self.Selected)
end

function ClassicLFGCheckBox:Select()
    self.Frame.Thumb:SetColorTexture(
        ClassicLFG.Config.PrimaryColor.Red,
        ClassicLFG.Config.PrimaryColor.Green,
        ClassicLFG.Config.PrimaryColor.Blue,
        ClassicLFG.Config.PrimaryColor.Alpha
    )
end

function ClassicLFGCheckBox:Deselect()
    self.Frame.Thumb:SetColorTexture(
        ClassicLFG.Config.BackgroundColor.Red,
        ClassicLFG.Config.BackgroundColor.Green,
        ClassicLFG.Config.BackgroundColor.Blue,
        ClassicLFG.Config.BackgroundColor.Alpha
    )
end

function ClassicLFGCheckBox:OnValueChanged(selected)
end

function ClassicLFGCheckBox:OnMouseDown()
end