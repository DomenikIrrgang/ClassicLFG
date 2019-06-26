ClassicLFGEditBox = {}
ClassicLFGEditBox.__index = ClassicLFGEditBox

setmetatable(ClassicLFGEditBox, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGEditBox.new(name, parent, title)
    local self = setmetatable({}, ClassicLFGEditBox)
    self.Disabled = false
    self.Frame = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
    self.Frame:SetParent(parent)
    self.Frame:SetFont(ClassicLFG.Config.Font, 12, "NONE")
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.PrimaryColor)
    self.Frame:SetAutoFocus(false)
    self.Frame:SetTextInsets(5, 5, 0, 0)

    self.Frame:SetScript("OnTextChanged", function(_, isUserInput) self:CheckPlaceholder(); self:OnTextChanged(isUserInput, self.Frame:GetText()) end)
    self.Frame:SetScript("OnEditFocusLost", function() self:CheckPlaceholder(); self:OnFocusLost() end)
    self.Frame:SetScript("OnEditFocusGained", function() self.Placeholder:Hide(); PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON); self:OnFocus() end)

    self.Frame:SetScript("OnEnter", function()
        if (self.Disabled == false) then
            ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.SecondaryColor)
        end
    end)
    
    self.Frame:SetScript("OnLeave", function()
        if (self.Disabled == false) then
            ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.PrimaryColor)
        end
    end)

    self.Placeholder = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Placeholder:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Placeholder:SetPoint("LEFT", self.Frame, "LEFT", 5, 0);

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.Title:SetPoint("BOTTOM", self.Frame, "TOP", 0, 5)
    self.Frame.Title:SetText(title)

    self.Frame.Left:Hide()
    self.Frame.Middle:Hide()
    self.Frame.Right:Hide()
    self.Frame:Show()
    return self
end

function ClassicLFGEditBox:OnTextChanged(isUserInput, newText)
    
end

function ClassicLFGEditBox:OnFocus()

 end

 function ClassicLFGEditBox:OnFocusLost()

 end

 function ClassicLFGEditBox:CheckPlaceholder()
    if (self.Frame:GetText() == nil or self.Frame:GetText() == "") then
        self.Placeholder:Show()
    else
        self.Placeholder:Hide()
    end
 end

 function ClassicLFGEditBox:SetPlaceholder(text)
    self.Placeholder:SetText(text)
 end

 function ClassicLFGEditBox:Disable()
    self.Disabled = true
    self.Frame:Disable()
    ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.DisabledColor)
 end

 function ClassicLFGEditBox:Enable()
    self.Disabled = false
    self.Frame:Enable()
    ClassicLFG:SetFrameBackgroundColor(self.Frame, ClassicLFG.Config.PrimaryColor)
 end