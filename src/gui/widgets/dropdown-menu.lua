ClassicLFGDropdownMenue = {}
ClassicLFGDropdownMenue.__index = ClassicLFGDropdownMenue

setmetatable(ClassicLFGDropdownMenue, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGDropdownMenue.new(text, parent, title)
    local self = setmetatable({}, ClassicLFGDropdownMenue)
    self.Disabled = false
    self.Items = {}
    self.DefaultText = text
    self.Entries = {}
    self.SelectedItems = {}
    self.OnValueChanged = function(key, selected, value) end
    self.MultiSelect = false
    self.Open = false
    self.Frame = CreateFrame("Frame", nil, parent, nil)
    self.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    self:SetBackgroundColor(ClassicLFG.Config.PrimaryColor)
    self.Frame.Text = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Text:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.Text:SetPoint("LEFT", self.Frame, "LEFT", 5, 0);
    self.Frame.Text:SetText(text);

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.Frame.Title:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    self.Frame.Title:SetPoint("BOTTOM", self.Frame, "TOP", 0, 5)
    self.Frame.Title:SetText(title)

    for i = 1, 30 do
        table.insert(self.Entries, self:CreateEntry(i))
    end
    self.SelectAllEntry = self:CreateEntry(-2)
    self.DeselectAllEntry = self:CreateEntry(-1)
    self.SelectAllEntry.Frame:SetScript("OnMouseDown", function() self:SelectAll(); self:HideEntries() end)
    self.SelectAllEntry.Frame:SetScript("OnMouseUp", function() end)
    self.SelectAllEntry.Text:SetText(ClassicLFG.Locale["Select all"])
    self.DeselectAllEntry.Frame:SetScript("OnMouseDown", function() self:DeselectAll(); self:HideEntries()end)
    self.DeselectAllEntry.Frame:SetScript("OnMouseUp", function() end)
    self.DeselectAllEntry.Text:SetText(ClassicLFG.Locale["Deselect all"])
    
    self.Frame:SetScript("OnEnter", function()
        if (self.Disabled == false) then
            self:SetBackgroundColor(ClassicLFG.Config.SecondaryColor)
        end
    end)
    
    self.Frame:SetScript("OnLeave", function()
        if (self.Disabled == false) then
            self:SetBackgroundColor(ClassicLFG.Config.PrimaryColor)
        end
    end)

    self.Frame:SetScript("OnMouseDown", function()
        if (self.Disabled == false) then
            if (self.Open == true) then
                self:HideEntries()
            else
                self:ShowEntries()
            end
            PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
        end
      end)

    self.Frame:Show()
    return self
end

function ClassicLFGDropdownMenue:SelectAll()
    if (self.MultiSelect == true) then
        for key, value in pairs(self.Entries) do
            if (value.Active == true) then
                value.Selected = true
                ClassicLFG:SetFrameBackgroundColor(value.Frame, ClassicLFG.Config.ActiveColor)
                self.OnValueChanged(value.Key, value.Selected, self.Items[value.Key])
            end
        end
        self:UpdateSelectedItems()
    end
end

function ClassicLFGDropdownMenue:DeselectAll()
    if (self.MultiSelect == true) then
        for key, value in pairs(self.Entries) do
            if (value.Active == true) then
                value.Selected = false
                ClassicLFG:SetFrameBackgroundColor(value.Frame, ClassicLFG.Config.DialogColor)
                self.OnValueChanged(value.Key, value.Selected, self.Items[value.Key])
            end
        end
        self:UpdateSelectedItems()
    end
end

function ClassicLFGDropdownMenue:ShowEntries()
    for key, value in pairs(self.Entries) do
        if (value.Active == true) then
            value.Frame:Show()
        end
    end
    if (self.MultiSelect == true) then
        self.SelectAllEntry.Frame:Show()
        self.DeselectAllEntry.Frame:Show()
    end
    self.Open = true
end

function ClassicLFGDropdownMenue:Reset()
    self.SelectedItems = {}
    for key, value in pairs(self.Entries) do
        value.Selected = false
        ClassicLFG:SetFrameBackgroundColor(value.Frame, ClassicLFG.Config.DialogColor)
    end
    self:UpdateSelectedItems()
end

function ClassicLFGDropdownMenue:GetValue()
    return self.SelectedItems[1]
end

function ClassicLFGDropdownMenue:SetValue(value)
    self.SelectedItems = { value }
    self.Frame.Text:SetText(value)
end

function ClassicLFGDropdownMenue:HideEntries()
    for key, value in pairs(self.Entries) do
        value.Frame:Hide()
    end
    self.Open = false
    if (self.MultiSelect == true) then
        self.SelectAllEntry.Frame:Hide()
        self.DeselectAllEntry.Frame:Hide()
    end
end

function ClassicLFGDropdownMenue:SetMultiSelect(multiSelect)
    self.MultiSelect = multiSelect
end

function ClassicLFGDropdownMenue:SetItems(items)
    self.Items = items
    local i = 1
    for key, value in pairs(self.Entries) do
        value.Active = false
    end
    for key, value in pairs(self.Items) do
        self.Entries[i].Text:SetText(ClassicLFG.Locale[value] or value)
        self.Entries[i].Active = true
        self.Entries[i].Selected = false
        self.Entries[i].Key = key
        if (i == 1) then
            self.Entries[i].Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT", 0, -1)
            self.Entries[i].Frame:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", 0, -21)
        else
            self.Entries[i].Frame:SetPoint("TOPLEFT", self.Entries[i - 1].Frame, "BOTTOMLEFT", 0, -1)
            self.Entries[i].Frame:SetPoint("BOTTOMRIGHT", self.Entries[i - 1].Frame, "BOTTOMRIGHT", 0, -21)
        end
        i = i + 1
    end
    self.SelectAllEntry.Frame:SetPoint("TOPLEFT", self.Entries[i - 1].Frame, "BOTTOMLEFT", 0, -1)
    self.SelectAllEntry.Frame:SetPoint("BOTTOMRIGHT", self.Entries[i - 1].Frame, "BOTTOMRIGHT", 0, -21)
    self.DeselectAllEntry.Frame:SetPoint("TOPLEFT", self.SelectAllEntry.Frame, "BOTTOMLEFT", 0, -1)
    self.DeselectAllEntry.Frame:SetPoint("BOTTOMRIGHT", self.SelectAllEntry.Frame, "BOTTOMRIGHT", 0, -21)
end

function ClassicLFGDropdownMenue:SetBackgroundColor(color)
    self.Frame:SetBackdropColor(color.Red, color.Green, color.Blue, color.Alpha)
end

function ClassicLFGDropdownMenue:UpdateSelectedItems()
    self.SelectedItems = {}
    for key, value in pairs(self.Entries) do
        if (value.Selected == true) then
            table.insert(self.SelectedItems, value.Key)
        end
    end

    if (#self.SelectedItems > 0) then
        for key, value in pairs(self.SelectedItems) do
            if (key == 1) then
                self.Frame.Text:SetText(ClassicLFG.Locale[self.Items[value]] or self.Items[value])
            else
                self.Frame.Text:SetText(self.Frame.Text:GetText() .. ", " .. (ClassicLFG.Locale[self.Items[value]] or self.Items[value]))
            end
        end
        while (self.Frame.Text:GetStringWidth() >= self.Frame:GetWidth() - 5) do
            self.Frame.Text:SetText(self.Frame.Text:GetText():sub(1, self.Frame.Text:GetText():len() - 4) .. "...")
        end
    else
        self.Frame.Text:SetText(self.DefaultText)
    end
end

function ClassicLFGDropdownMenue:CreateEntry(id)
    local entry = {}
    entry.Id = id
    entry.Selected = false
    entry.Frame = CreateFrame("Frame", nil, self.Frame, nil)
    entry.Frame:SetFrameStrata("TOOLTIP")
    entry.Frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8
    })
    ClassicLFG:SetFrameBackgroundColor(entry.Frame, ClassicLFG.Config.DialogColor)
    
    entry.Frame:SetScript("OnEnter", function()
        if (self.Disabled == false and entry.Selected == false) then
            ClassicLFG:SetFrameBackgroundColor(entry.Frame, ClassicLFG.Config.SecondaryColor)
        end
    end)
    
    entry.Frame:SetScript("OnLeave", function()
        if (self.Disabled == false and entry.Selected == false) then
            ClassicLFG:SetFrameBackgroundColor(entry.Frame, ClassicLFG.Config.DialogColor)
        end
    end)

    entry.Frame:SetScript("OnMouseDown", function()
        self:HideEntries()
        if (self.MultiSelect == false) then
            for key, value in pairs(self.Entries) do
                if (value.Id ~= entry.Id) then
                    value.Selected = false
                else
                    value.Selected = not value.Selected
                end
                if (value.Selected == true) then
                    ClassicLFG:SetFrameBackgroundColor(value.Frame, ClassicLFG.Config.ActiveColor)
                else
                    ClassicLFG:SetFrameBackgroundColor(value.Frame, ClassicLFG.Config.DialogColor)
                end
            end
        else
            entry.Selected = not entry.Selected
            if (entry.Selected == true) then
                ClassicLFG:SetFrameBackgroundColor(entry.Frame, ClassicLFG.Config.ActiveColor)
            else
                ClassicLFG:SetFrameBackgroundColor(entry.Frame, ClassicLFG.Config.DialogColor)
            end
        end
        self:UpdateSelectedItems()
        self.OnValueChanged(entry.Key, entry.Selected, self.Items[entry.Key])
        PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
    end)

    entry.Text = entry.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    entry.Text:SetFont(ClassicLFG.Config.Font, 12, "NONE");
    entry.Text:SetPoint("LEFT", entry.Frame, "LEFT", 5, 0);
    entry.Active = false
    entry.Frame:Hide()
    return entry
end

function ClassicLFGDropdownMenue:Enable()
    self.Disabled = false
    self:SetBackgroundColor(ClassicLFG.Config.PrimaryColor)
end

function ClassicLFGDropdownMenue:Disable()
    self.Disabled = true
    self:SetBackgroundColor(ClassicLFG.Config.DisabledColor)
end