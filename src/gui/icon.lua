ClassicLFGIcon = {}
ClassicLFGIcon.__index = ClassicLFGIcon

setmetatable(ClassicLFGIcon, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGIcon.new(texture, parent, width, height)
  local self = setmetatable({}, ClassicLFGIcon)
  self.Texture = parent:CreateTexture(nil, "ARTWORK")
  self.Texture:SetSize(width, height)
  self.Texture:SetTexture(texture)
  self.Texture:Show()
  return self
end

function ClassicLFGIcon:GetTexture()
    return self.Texture
end