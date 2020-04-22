﻿ClassicLFG = LibStub("AceAddon-3.0"):NewAddon("ClassicLFG", "AceConsole-3.0")
ClassicLFG.AceGUI = LibStub("AceGUI-3.0")
ClassicLFG.Locale = LibStub("AceLocale-3.0"):GetLocale("ClassicLFG")
ClassicLFG.MinimapIcon = LibStub("LibDBIcon-1.0")

GetTalentTabInfo = GetTalentTabInfo or function(index)
    return "Assasination", nil, math.random(1,10), "RogueAssasination"
end

ClassicLFG.DefaultProfile ={
    profile = {
        minimap = {
            hide = false,
        },
        InviteText = "invite please",
        BroadcastDungeonGroupInterval = 90,
        BroadcastDungeonGroupChannel = "General",
        ShowAllDungeons = false,
        AutoAcceptInvite = false,
        InviteKeyword = "inv",
        AutoInvite = false,
        ShowMinimapIcon = true,
        BroadcastDungeonGroup = true,
        FilterChat = false,
        Toast = {
            Enabled = true,
            X = GetScreenWidth() / 2 - 260 / 2,
            Y = (GetScreenHeight() / 4) * -1,
        }
    },
}

function ClassicLFG:OnEnable()
    ClassicLFG.ChannelManager:UpdateChannels()
end

local f = CreateFrame('Frame')
f.joined = false
f:SetScript('OnUpdate', function(self, elapsed)
	self.delayed = (self.delayed or 0) + elapsed
    if self.delayed > 2 then
        local numActiveChannels = C_ChatInfo.GetNumActiveChannels()
		if numActiveChannels and (numActiveChannels >= 1) and self.joined == false then
			if numActiveChannels < MAX_WOW_CHAT_CHANNELS then
                JoinChannelByName(ClassicLFG.Config.Network.Channel.Name, nil, nil, true)
                self.joined = true
                local channels = { GetChannelList() }
                local i = 2
                while i < #channels do
                    if (channels[i] == ClassicLFG.Config.Network.Channel.Name) then
                        ClassicLFG.Config.Network.Channel.Id = channels[i - 1]
                    end
                    i = i + 3
                end
                ClassicLFG.PeerToPeer:StartBroadcastObject(ClassicLFG.Config.Events.RequestData, UnitName("player"))
                ClassicLFG.PeerToPeer:StartBroadcastObject(ClassicLFG.Config.Events.VersionCheck, ClassicLFG.Config.Version)
				self:SetScript('OnUpdate', nil)
			end
		end
        self:SetScript('OnUpdate', nil)
	elseif self.delayed > 45 then
		self:SetScript('OnUpdate', nil)
	end
end)

function ClassicLFG:OnInitialize()
    self.DB = LibStub("AceDB-3.0"):New("ClassicLFG_DB", self.DefaultProfile)
    local iconPath = ([[Interface\Addons\%s\%s\%s]]):format("ClassicLFG", "textures", "inv_misc_groupneedmore")
    self.LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ClassicLFG_LDB", {
        type = "launcher",
        text = "ClassicLFG_LDB",
        icon = iconPath,
        OnClick = self.MinimapIconClick,
        OnTooltipShow = self.MinimapTooltip,
    })
    self.MinimapIcon:Register("ClassicLFG_LDB", self.LDB, self.DB.profile.minimap)
    self:RegisterChatCommand("lfg", "MinimapIconClick")
    self:RegisterChatCommand("classiclfg", "MinimapIconClick")
    self:RegisterChatCommand("clfg", "MinimapIconClick")
    local initialState = self:GetInitialState()
    initialState.Db = self.DB
    self.Store:SetState(self:DeepCopy(initialState))
    self.Store:GetState().Db = self.DB
    self.Initialized = true
    self.ToastManager = ClassicLFGToastManager()
end

function ClassicLFG:GetInitialState()
    return {
        MainWindowOpen = false,
        NetworkObjectsSend = 0,
        NetworkPackagesSend = 0,
        DungeonGroupQueued = false,
        DungeonGroup = nil,
        Db = nil,
        Player = {
            Level = UnitLevel("player")
        },
        ShareTalents = true
    }
end

function ClassicLFG:InitMInimapIcon()
    if self.DB.profile.minimap.hide then
		self.MinimapIcon:Hide("ClassicLFG_LDB")
    else
		self.MinimapIcon:Show("ClassicLFG_LDB")
	end
end

function ClassicLFG:MinimapIconClick()
    ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ToggleMainWindow)
end

function ClassicLFG:Reset()
    self.Store:SetState(self.InitialState)
end

function ClassicLFG.MinimapTooltip(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine("ClassicLFG")
    tooltip:AddLine(ClassicLFG.Locale["Leftclick: Open LFG Browser"])
end