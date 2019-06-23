
---------------------------------
-- Settings 
---------------------------------

ClassicLFG.QueueWindow.Settings.Broadcastchannel = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Broadcastchannel"], ClassicLFG.QueueWindow.Settings, 300, 50)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings, "TOPLEFT", 0, 0)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings, "TOPRIGHT", 0, -22)
ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetItems(ClassicLFG:GetDungeonsByLevel(UnitLevel("player")))
ClassicLFG.QueueWindow.Settings.Broadcastchannel.OnValueChanged = function(_, _, channel)
    ClassicLFG.DB.profile.BroadcastDungeonGroupChannel = ClassicLFG.ChannelManager:GetChannelId(channel)
end


ClassicLFG.QueueWindow.Settings:SetScript("OnShow", function(self, _, channel)
	ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetItems(ClassicLFG.ChannelManager:GetChannelNames())
	ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.ChannelManager:GetChannelName((ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)))
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChannelListChanged, ClassicLFG.QueueWindow.Settings.Broadcastchannel, function(self, channels)
	self:SetItems(ClassicLFG.ChannelManager:GetChannelNames())
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.ChannelManager:GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel))
end)


ClassicLFG.QueueWindow.Settings.Broadcastintervall = ClassicLFG.AceGUI:Create("Slider")
ClassicLFG.QueueWindow.Settings.Broadcastintervall.frame:SetParent(ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetPoint("TOPLEFT",ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMLEFT", 0, -15)
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetPoint("BOTTOMRIGHT",ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMRIGHT", 0, -45)
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetLabel(ClassicLFG.Locale["Broadcastinterval"])
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetSliderValues(60, 180, 1)

ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetCallback("OnValueChanged", function(self,_,value)
	ClassicLFG.DB.profile.BroadcastDungeonGroupInterval = value
end)

ClassicLFG.QueueWindow.Settings.Broadcastintervall.frame:SetScript("OnShow", function(self, _ , value)
	ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetValue(ClassicLFG.DB.profile.BroadcastDungeonGroupInterval)	
end)

ClassicLFG.QueueWindow.Settings.Invitemessage = ClassicLFG.AceGUI:Create("EditBox")
ClassicLFG.QueueWindow.Settings.Invitemessage.frame:SetParent(ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.Invitemessage:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.Broadcastintervall.frame, "BOTTOMLEFT", 0, -15);
ClassicLFG.QueueWindow.Settings.Invitemessage:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.Broadcastintervall.frame, "BOTTOMRIGHT", 0, -60)
ClassicLFG.QueueWindow.Settings.Invitemessage:SetLabel(ClassicLFG.Locale["Invitemessage"] .. ":")
ClassicLFG.QueueWindow.Settings.Invitemessage:SetMaxLetters(25)
ClassicLFG.QueueWindow.Settings.Invitemessage:DisableButton(true)

ClassicLFG.QueueWindow.Settings.Invitemessage.frame:SetScript("OnShow", function(self, _, text)
	ClassicLFG.QueueWindow.Settings.Invitemessage:SetText(ClassicLFG.DB.profile.InviteText)
end)

ClassicLFG.QueueWindow.Settings.Invitemessage:SetCallback("OnTextChanged", function(self, _, text)
	ClassicLFG.DB.profile.InviteText = text
end)

ClassicLFG.QueueWindow.Settings.Invitemessage.frame:Show()