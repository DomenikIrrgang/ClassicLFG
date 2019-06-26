ClassicLFGTabButton = {}
ClassicLFGTabButton.__index = ClassicLFGTabButton

setmetatable(ClassicLFGTabButton, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGTabButton.new(text, name, parent, width, height, padding)
    local self = setmetatable({}, ClassicLFGTabButton)
    self.Disabled = false
    self.Padding = padding
    self.Frame = CreateFrame("Frame", name, parent, nil)
    self.Frame:SetSize(width or 80, height or 30);
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    self:SetBackgroundColor(ClassicLFG.Config.BackgroundColor)
  
    self.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Title:SetPoint("CENTER");
    self.Title:SetText(text);

    self.Content = CreateFrame("Frame", name .. "Content", parent.Content, nil)
    self.Content:SetPoint("TOPLEFT", parent.Content, "TOPLEFT", padding, -padding)
    self.Content:SetPoint("BOTTOMRIGHT", parent.Content, "BOTTOMRIGHT", -padding, padding)
    self.Content:Hide()
  
    self.Frame:SetScript("OnEnter", function()
      if (self.Disabled == false) then
        self:SetBackgroundColor(ClassicLFG.Config.SecondaryColor)
      end
    end)
  
    self.Frame:SetScript("OnLeave", function()
      if (self.Disabled == false) then
        if (self.Selected == true) then
            self:SetBackgroundColor(ClassicLFG.Config.ActiveColor)
        else
            self:SetBackgroundColor(ClassicLFG.Config.BackgroundColor)
        end
      end
    end)
  
    self.Frame:SetScript("OnMouseUp", function()
      if (self.Disabled == false) then
        self:OnClick()
      end
    end)
    
    return self
end

function ClassicLFGTabButton:OnClick()
    if (self.Disabled == false and self.Selected ~= true) then
        self:Select()
    end
end

function ClassicLFGTabButton:Select()
    for key in pairs(self.Frame:GetParent().TabButtons) do
        self.Frame:GetParent().TabButtons[key]:Deselect()
    end
    self:SetBackgroundColor(ClassicLFG.Config.ActiveColor)
    self.Selected = true
    PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
    self.Content:Show()
end

function ClassicLFGTabButton:Deselect()
    if (self.Disabled == false) then
        self:SetBackgroundColor(ClassicLFG.Config.BackgroundColor)
        self.Selected = false
        self.Content:Hide()
    end
end

function ClassicLFGTabButton:SetBackgroundColor(color)
    self.Frame:SetBackdropColor(color.Red, color.Green, color.Blue, color.Alpha)
end

function ClassicLFGTabButton:Disable()
    self.Disabled = true
    self.Content:Hide()
    self:SetBackgroundColor(ClassicLFG.Config.DisabledColor)
end

function ClassicLFGTabButton:Enable()
    self.Disabled = false
    self:SetBackgroundColor(ClassicLFG.Config.BackgroundColor)
end
