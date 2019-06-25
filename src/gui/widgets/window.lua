ClassicLFGWindow = {}
ClassicLFGWindow.__index = ClassicLFGWindow

setmetatable(ClassicLFGWindow, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGWindow.new(name, parent, width, height)
    local self = setmetatable({}, ClassicLFGWindow)
    self.Frame = CreateFrame("Frame", name, parent, nil)
    self.ShowAnimationGroup = self.Frame:CreateAnimationGroup()
    self.ShowAnimation = self.ShowAnimationGroup:CreateAnimation("Alpha")
    self.ShowAnimation:SetDuration(0.4)
    self.ShowAnimation:SetSmoothing("OUT")
    self.ShowAnimation:SetFromAlpha(0)
    self.ShowAnimation:SetToAlpha(1)
    self.HideAnimationGroup = self.Frame:CreateAnimationGroup()
    self.HideAnimation = self.HideAnimationGroup:CreateAnimation("Alpha")
    self.HideAnimation:SetDuration(0.3)
    self.HideAnimation:SetSmoothing("OUT")
    self.HideAnimation:SetFromAlpha(1)
    self.HideAnimation:SetToAlpha(0)
    self.HideAnimation:SetScript("OnFinished", function() self.Frame:Hide() end)
    self.Width = width
    self.Height = height
    self.OnClick = function() end
    self.Disabled = false
    self.Frame:SetSize(self.Width, self.Height)
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeSize = 16, tileEdge = true
    })
    self.Frame:SetBackdropColor(ClassicLFG.Config.BackgroundColor.Red,
        ClassicLFG.Config.BackgroundColor.Green,
        ClassicLFG.Config.BackgroundColor.Blue,
        ClassicLFG.Config.BackgroundColor.Alpha)
    self.Frame:SetPoint("TOPLEFT", parent, "CENTER", -1 * self.Width / 2, self.Height / 2)

    self.Frame:SetScript("OnMouseDown", function()
        self.Frame:SetMovable(true)
        self.Frame:StartMoving(ClassicLFG.QueueWindow)
    end)

    self.Frame:SetScript("OnMouseUp", function()
        self.Frame:StopMovingOrSizing()
        self.Frame:SetMovable(false)
    end)

    self.Frame.TitleBar = CreateFrame("Frame", nil, self.Frame, nil)
    self.Frame.TitleBar.Height = 30
    self.Frame.TitleBar:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 0, 0)
    self.Frame.TitleBar:SetPoint("BOTTOMRIGHT", self.Frame, "TOPRIGHT", 0, -self.Frame.TitleBar.Height)
    self.Frame.TitleBar:Show()

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Title:ClearAllPoints();
    self.Frame.Title:SetFontObject("GameFontHighlight");
    self.Frame.Title:SetPoint("LEFT", self.Frame.TitleBar, "LEFT", 10, 0);
    self.Frame.Title:Show()

    self.Frame.CloseButton = ClassicLFGButton("X", self.Frame.TitleBar, 20, 20)
    self.Frame.CloseButton:SetPoint("RIGHT", self.Frame.TitleBar, "RIGHT", -7, 0)
    self.Frame.CloseButton.OnClick = function() self:Hide() end

    self.Frame.Content = CreateFrame("Frame", name .. "Content", self.Frame, nil)
    self.Frame.Content:SetPoint("TOPLEFT", self.Frame.TitleBar, "BOTTOMLEFT", 0, 0)
    self.Frame.Content:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", 0, 0)
    self.Frame.Content:Show()
    self.Frame:Hide()
    return self
end

function ClassicLFGWindow:SetTitle(title)
    self.Frame.Title:SetText(title);
end

function ClassicLFGWindow:Show()
    self.Frame:Show()
    self.ShowAnimationGroup:Play()
end

function ClassicLFGWindow:Hide()
    self.HideAnimationGroup:Play()
end

function ClassicLFGWindow:IsShown()
    return self.Frame:IsShown()
end

function ClassicLFGWindow:CreateTabs(count, ...)
    local contents = {}
    self.Frame.Tabs = {}
    self.Frame.TabButtons = {}
    self.Frame.numTabs = count
    for i = 1, count do	
		local tab = ClassicLFGTabButton("Tab " .. i, self.Frame:GetName() .. "Tab" .. i, self.Frame, 106, 22, 8);
        tab.Frame:SetID(i)
        tab.Title:SetText(select(i, ...))
		table.insert(contents, tab.Content);
        table.insert(self.Frame.TabButtons, tab)
        table.insert(self.Frame.Tabs, tab.Frame)

		if (i == 1) then
			tab.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Frame, "BOTTOMLEFT", 5, 0);
		else
			tab.Frame:SetPoint("TOPLEFT", _G[self.Frame:GetName() .. "Tab" .. (i - 1)], "TOPRIGHT", 5, 0);
		end	
	end
	
	self.Frame.TabButtons[1]:OnClick()
	return unpack(contents);
end

function ClassicLFGWindow:DisableTab(index)
    if (self.Frame.TabButtons[index].Selected == true) then
        self.Frame.TabButtons[index]:Deselect()
        for i = 1, #self.Frame.TabButtons do
            if (self.Frame.TabButtons[i].Disabled == false and index ~= i) then
                self.Frame.TabButtons[i]:Select()
                break
            end
        end
    end
    self.Frame.TabButtons[index]:Disable()
end

function ClassicLFGWindow:EnableTab(index)
    self.Frame.TabButtons[index]:Enable()
end