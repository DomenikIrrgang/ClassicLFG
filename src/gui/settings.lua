
---------------------------------
-- Settings 
---------------------------------

ClassicLFG.QueueWindow.Settings:SetScript("OnShow", function(self, _, channel)
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetItems(ClassicLFG.ChannelManager:GetChannelNames())
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.ChannelManager:GetChannelName((ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)))
    ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame:SetValue(ClassicLFG.DB.profile.BroadcastDungeonGroupInterval)	
    ClassicLFG.QueueWindow.Settings.Invitemessage.Frame:SetText(ClassicLFG.DB.profile.InviteText)
    ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame:SetText(ClassicLFG.DB.profile.InviteKeyword)
    ClassicLFG.QueueWindow.Settings.ShowAllDungeons:SetState(ClassicLFG.DB.profile.ShowAllDungeons)
    ClassicLFG.QueueWindow.Settings.AutoAcceptInvite:SetState(ClassicLFG.DB.profile.AutoAcceptInvite)
end)

ClassicLFG.QueueWindow.Settings.Broadcastchannel = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Broadcastchannel"], ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Broadcastchannel"])
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings, "TOPLEFT", 0, -10)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings, "TOPRIGHT", 0, -32)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.OnValueChanged = function(_, _, channel)
    ClassicLFG.DB.profile.BroadcastDungeonGroupChannel = ClassicLFG.ChannelManager:GetChannelId(channel)
end

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChannelListChanged, ClassicLFG.QueueWindow.Settings.Broadcastchannel, function(self, channels)
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetItems(ClassicLFG.ChannelManager:GetChannelNames())
    self:SetItems(ClassicLFG.ChannelManager:GetChannelNames())
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.ChannelManager:GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel))
end)

ClassicLFG.QueueWindow.Settings.BroadcastSlider = ClassicLFGSlider(ClassicLFG.Locale["Broadcastinterval"], nil, ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMLEFT", 0, -25);
ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMRIGHT", 0, -47)
if (ClassicLFG.Config.Debug == true) then
    ClassicLFG.QueueWindow.Settings.BroadcastSlider:SetSliderValues(1, 180, 1)
else
    ClassicLFG.QueueWindow.Settings.BroadcastSlider:SetSliderValues(60, 180, 1)
end
ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame:SetValue(5)
ClassicLFG.QueueWindow.Settings.BroadcastSlider.OnValueChanged = function(_, value)
	ClassicLFG.DB.profile.BroadcastDungeonGroupInterval = value
end

ClassicLFG.QueueWindow.Settings.Invitemessage = ClassicLFGEditBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Invitemessage"])
ClassicLFG.QueueWindow.Settings.Invitemessage.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame, "BOTTOMLEFT", 0, -38);
ClassicLFG.QueueWindow.Settings.Invitemessage.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.BroadcastSlider.Frame, "BOTTOMRIGHT", 0, -60)
ClassicLFG.QueueWindow.Settings.Invitemessage.Frame:SetMaxLetters(25)
ClassicLFG.QueueWindow.Settings.Invitemessage:SetPlaceholder(ClassicLFG.Locale["Invitemessage"])

ClassicLFG.QueueWindow.Settings.Invitemessage.OnTextChanged = function(self, _, text)
	ClassicLFG.DB.profile.InviteText = text
end

ClassicLFG.QueueWindow.Settings.InviteKeyword = ClassicLFGEditBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Invite Keyword"])
ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.Invitemessage.Frame, "BOTTOMLEFT", 0, -25);
ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.Invitemessage.Frame, "BOTTOMRIGHT", 0, -47)
ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame:SetMaxLetters(25)
ClassicLFG.QueueWindow.Settings.InviteKeyword:SetPlaceholder(ClassicLFG.Locale["Invite Keyword"])

ClassicLFG.QueueWindow.Settings.InviteKeyword.OnTextChanged = function(self, _, text)
	ClassicLFG.DB.profile.InviteKeyword = text
end

ClassicLFG.QueueWindow.Settings.ShowAllDungeons = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Always show all dungeons"])
ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.InviteKeyword.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.ShowAllDungeons.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.ShowAllDungeons = value
    ClassicLFG.QueueWindow.SearchGroup.Filter:InitFilterValues()
end

ClassicLFG.QueueWindow.Settings.AutoAcceptInvite = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Autoaccept invites of parties you applied to"])
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.AutoAcceptInvite = value
end