ClassicLFGIconWithText = {}
ClassicLFGIconWithText.__index = ClassicLFGIconWithText

setmetatable(ClassicLFGIconWithText, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGIconWithText.new(text, texture, parent, width, height)
  local self = setmetatable({}, ClassicLFGIconWithText)
  self.Icon = ClassicLFGIcon(texture, parent, width, height)
  self.Text = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  self.Text:SetFont(ClassicLFG.Config.Font, 11, "NONE");
  self.Text:SetText(text);
  self.Text:SetPoint("LEFT", self.Icon.Texture, "RIGHT", 2, 0);
  return self
end

function ClassicLFGIconWithText:GetTexture()
    return self.Texture
end

function ClassicLFGIconWithText:Hide()
  self.Icon.Texture:Hide()
  self.Text:Hide()
end

function ClassicLFGIconWithText:Show()
  self.Icon.Texture:Show()
  self.Text:Show()
end