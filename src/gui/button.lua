ClassicLFGButton = {}
ClassicLFGButton.__index = ClassicLFGButton

setmetatable(ClassicLFGButton, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGButton.new(text, parent)
  local self = setmetatable({}, ClassicLFGButton)
  self.Frame = CreateFrame("Frame", nil, parent, nil);
  self.Position = {}
  self.OnClick = function() end
  self.Frame:SetSize(80, 30);
  self.Frame:SetBackdrop({
      bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
  })
  self.Frame:SetBackdropColor(0.5, 0.5, 0.5, 1)
  self.Frame:SetBackdropBorderColor(1,1,1,1)

  self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
  self.Frame.Title:SetPoint("CENTER");
  self.Frame.Title:SetText(text);

  self.Frame:SetScript("OnEnter", function()
    self.Frame:SetBackdropColor(0.7, 0.7, 0.7, 1)
  end)

  self.Frame:SetScript("OnLeave", function()
    self.Frame:SetBackdropColor(0.5, 0.5, 0.5, 1)
  end)

  self.Frame:SetScript("OnMouseUp", function()
    self.Frame:SetPoint(self.Position.OwnAnchor, self.Position.RelativeRegion, self.Position.RelativeAnchor, self.Position.XOffset, self.Position.YOffset);
    self:OnClick()
end)

  self.Frame:SetScript("OnMouseDown", function()
    self.Frame:SetPoint(self.Position.OwnAnchor, self.Position.RelativeRegion, self.Position.RelativeAnchor, self.Position.XOffset + 2, self.Position.YOffset -2);
  end)
  return self
end

function ClassicLFGButton:SetPoint(ownAnchor, relativeRegion, relativeAnchor, xOffset, yOffset)
    self.Position = { OwnAnchor = ownAnchor, RelativeRegion = relativeRegion, RelativeAnchor = relativeAnchor, XOffset = xOffset, YOffset = yOffset }
    self.Frame:SetPoint(ownAnchor, relativeRegion, relativeAnchor, xOffset, yOffset);
end

function ClassicLFGButton:Hide()
    self.Frame:Hide()
end

function ClassicLFGButton:Show()
    self.Frame:Show()
end

function ClassicLFGButton:SetText(text)
    self.Frame.Title:SetText(text)
end