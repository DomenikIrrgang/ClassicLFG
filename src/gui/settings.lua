
---------------------------------
-- Settings 
---------------------------------

ClassicLFG.QueueWindow.Settings.Broadcastchannel = ClassicLFG.AceGUI:Create("Dropdown")
ClassicLFG.QueueWindow.Settings.Broadcastchannel.frame:SetParent(ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings, "TOPLEFT", 8, -12);
ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings, "TOPRIGHT", -8, -45)
ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetText(ClassicLFG.Locale["Select Broadcastchannel"])
ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetLabel(ClassicLFG.Locale["Broadcastchannel"] .. ":")

ClassicLFG.QueueWindow.Settings.Broadcastchannel.frame:SetScript("OnShow", function(self, _, channel)
	ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetList(ClassicLFG.ChannelManager:GetChannelNames())
	ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)
end)

ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetCallback("OnValueChanged", function(self, _, channel)
	ClassicLFG.DB.profile.BroadcastDungeonGroupChannel = channel
end)

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChannelListChanged, ClassicLFG.QueueWindow.Settings.Broadcastchannel, function(self, channels)
	self:SetList(ClassicLFG.ChannelManager:GetChannelNames())
	ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)
end)


ClassicLFG.QueueWindow.Settings.Broadcastintervall = ClassicLFG.AceGUI:Create("Slider")
ClassicLFG.QueueWindow.Settings.Broadcastintervall.frame:SetParent(ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetPoint("TOPLEFT",ClassicLFG.QueueWindow.Settings.Broadcastchannel.frame, "BOTTOMLEFT", 0, -15)
ClassicLFG.QueueWindow.Settings.Broadcastintervall:SetPoint("BOTTOMRIGHT",ClassicLFG.QueueWindow.Settings.Broadcastchannel.frame, "BOTTOMRIGHT", 0, -45)
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