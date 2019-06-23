ClassicLFGButton = {}
ClassicLFGButton.__index = ClassicLFGButton

setmetatable(ClassicLFGButton, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGButton.new(text, parent, width, height)
  local self = setmetatable({}, ClassicLFGButton)
  self.Frame = CreateFrame("Frame", nil, parent, nil)
  self.Position = {}
  self.OnClick = function() end
  self.Disabled = false
  self.Frame:SetSize(width or 80, height or 30);
  self.Frame:SetBackdrop({
      bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
  })
  self.Frame:SetBackdropColor(ClassicLFG.Config.PrimaryColor.Red,
    ClassicLFG.Config.PrimaryColor.Green,
    ClassicLFG.Config.PrimaryColor.Blue,
    ClassicLFG.Config.PrimaryColor.Alpha)
  self.Frame:SetBackdropBorderColor(1,1,1,1)

  self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
  self.Frame.Title:SetPoint("CENTER");
  self.Frame.Title:SetText(text);

  self.Frame:SetScript("OnEnter", function()
    if (self.Disabled == false) then
      self.Frame:SetBackdropColor(ClassicLFG.Config.SecondaryColor.Red,
      ClassicLFG.Config.SecondaryColor.Green,
      ClassicLFG.Config.SecondaryColor.Blue,
      ClassicLFG.Config.SecondaryColor.Alpha)
    end
  end)

  self.Frame:SetScript("OnLeave", function()
    if (self.Disabled == false) then
      self.Frame:SetBackdropColor(ClassicLFG.Config.PrimaryColor.Red,
      ClassicLFG.Config.PrimaryColor.Green,
      ClassicLFG.Config.PrimaryColor.Blue,
      ClassicLFG.Config.PrimaryColor.Alpha)
    end
  end)

  self.Frame:SetScript("OnMouseUp", function()
    if (self.Disabled == false) then
      self.Frame:SetPoint(self.Position.OwnAnchor, self.Position.RelativeRegion, self.Position.RelativeAnchor, self.Position.XOffset, self.Position.YOffset);
      self:OnClick()
    end
  end)

  self.Frame:SetScript("OnMouseDown", function()
    if (self.Disabled == false) then
      self.Frame:SetPoint(self.Position.OwnAnchor, self.Position.RelativeRegion, self.Position.RelativeAnchor, self.Position.XOffset + 2, self.Position.YOffset -2);
      PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
    end
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

function ClassicLFGButton:SetDisabled(disabled)
  self.Disabled = disabled
  if (self.Disabled) then
    self.Frame:SetBackdropColor(0.2, 0.2, 0.2, 1)
  else
    self.Frame:SetBackdropColor(ClassicLFG.Config.PrimaryColor.Red,
    ClassicLFG.Config.PrimaryColor.Green,
    ClassicLFG.Config.PrimaryColor.Blue,
    ClassicLFG.Config.PrimaryColor.Alpha)
  end
end

function ClassicLFGButton:SetText(text)
    self.Frame.Title:SetText(text)
end