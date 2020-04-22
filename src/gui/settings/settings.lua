
---------------------------------
-- Settings 
---------------------------------

ClassicLFG.QueueWindow.Settings:SetScript("OnShow", function(self, _, channel)
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetItems(ClassicLFG.ChannelManager:GetBroadcastChannelNames())
    ClassicLFG.QueueWindow.Settings.Broadcastchannel:SetValue(ClassicLFG.ChannelManager:GetChannelName((ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)))
    ClassicLFG.QueueWindow.Settings.AutoAcceptInvite:SetState(ClassicLFG.DB.profile.AutoAcceptInvite)
    ClassicLFG.QueueWindow.Settings.HideMinimapIcon:SetState(ClassicLFG.DB.profile.minimap.hide)
    ClassicLFG.QueueWindow.Settings.EnableToasts:SetState(ClassicLFG.DB.profile.Toast.Enabled)
    ClassicLFG.QueueWindow.Settings.FilterChat:SetState(ClassicLFG.DB.profile.FilterChat)
end)

ClassicLFG.QueueWindow.Settings.Broadcastchannel = ClassicLFGDropdownMenue(ClassicLFG.Locale["Select Broadcastchannel"], ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Broadcastchannel"])
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings, "TOPLEFT", 0, -10)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings, "TOPRIGHT", 0, -32)
ClassicLFG.QueueWindow.Settings.Broadcastchannel.OnValueChanged = function(_, _, channel)
    ClassicLFG.DB.profile.BroadcastDungeonGroupChannel = ClassicLFG.ChannelManager:GetChannelId(channel)
end

ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChannelListChanged, ClassicLFG.QueueWindow.Settings.Broadcastchannel, function(self, channels)
    if (ClassicLFG.ChannelManager:GetBroadcastChannelNames() and #ClassicLFG.ChannelManager:GetBroadcastChannelNames() > 0) then
        self:SetItems(ClassicLFG.ChannelManager:GetBroadcastChannelNames())
        self:SetValue(ClassicLFG.ChannelManager:GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel))
    end
end)

ClassicLFG.QueueWindow.Settings.ShowAllDungeons = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Always show all dungeons"])
ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.Broadcastchannel.Frame, "BOTTOMRIGHT", 0, -30)

ClassicLFG.QueueWindow.Settings.ShowAllDungeons.OnValueChanged = function(_, value)
    ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ToggleShowAllDungeons, value)
end

ClassicLFG.Store:AddListener(ClassicLFG.Actions.ToggleShowAllDungeons, ClassicLFG.QueueWindow.Settings.ShowAllDungeons, function(self, action, state, value)
    if (state.Db.profile.ShowAllDungeons == true) then
        self:Select()
        self.Selected = true
    else
        self:Deselect()
        self.Selected = false
    end
end)

ClassicLFG.QueueWindow.Settings.ShareTalents = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Share Talents"])
ClassicLFG.QueueWindow.Settings.ShareTalents.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.ShareTalents.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.ShowAllDungeons.Frame, "BOTTOMRIGHT", 0, -30)

ClassicLFG.QueueWindow.Settings.ShareTalents.OnValueChanged = function(_, value)
    ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ToggleShareTalents, value)
end

ClassicLFG.Store:AddListener(ClassicLFG.Actions.ToggleShareTalents, ClassicLFG.QueueWindow.Settings.ShareTalents, function(self, action, state, value)
    if (state.Db.profile.ShareTalents == true) then
        self:Select()
        self.Selected = true
    else
        self:Deselect()
        self.Selected = false
    end
end)

ClassicLFG.QueueWindow.Settings.AutoAcceptInvite = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Autoaccept invites of parties you applied to"])
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.ShareTalents.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.ShareTalents.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.AutoAcceptInvite = value
end

ClassicLFG.QueueWindow.Settings.HideMinimapIcon = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Hide Minimap Icon"])
ClassicLFG.QueueWindow.Settings.HideMinimapIcon.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.HideMinimapIcon.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.AutoAcceptInvite.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.HideMinimapIcon.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.minimap.hide = value
    ClassicLFG:InitMInimapIcon()
end

ClassicLFG.QueueWindow.Settings.FilterChat = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Remove LFM Messages from Chat"])
ClassicLFG.QueueWindow.Settings.FilterChat.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.HideMinimapIcon.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.FilterChat.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.HideMinimapIcon.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.FilterChat.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.FilterChat = value
end

ClassicLFG.QueueWindow.Settings.EnableToasts = ClassicLFGCheckBox(nil, ClassicLFG.QueueWindow.Settings, ClassicLFG.Locale["Show Notifications"])
ClassicLFG.QueueWindow.Settings.EnableToasts.Frame:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.FilterChat.Frame, "BOTTOMLEFT", 0, -8)
ClassicLFG.QueueWindow.Settings.EnableToasts.Frame:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.FilterChat.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.EnableToasts.OnValueChanged = function(_, value)
    ClassicLFG.DB.profile.Toast.Enabled = value
end

ClassicLFG.QueueWindow.Settings.QueueButton = ClassicLFGButton(ClassicLFG.Locale["Toggle Notifications"], ClassicLFG.QueueWindow.Settings)
ClassicLFG.QueueWindow.Settings.QueueButton:SetPoint("TOPLEFT", ClassicLFG.QueueWindow.Settings.EnableToasts.Frame, "BOTTOMLEFT", 0, -8);
ClassicLFG.QueueWindow.Settings.QueueButton:SetPoint("BOTTOMRIGHT", ClassicLFG.QueueWindow.Settings.EnableToasts.Frame, "BOTTOMRIGHT", 0, -30)
ClassicLFG.QueueWindow.Settings.QueueButton.OnClick = function()
    ClassicLFG.ToastManager:SetMovable(not ClassicLFG.ToastManager.Movable)
end