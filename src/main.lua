ClassicLFG = LibStub("AceAddon-3.0"):NewAddon("ClassicLFG", "AceConsole-3.0")
ClassicLFG.AceGUI = LibStub("AceGUI-3.0")
ClassicLFG.MinimapIcon = LibStub("LibDBIcon-1.0")

GetTalentTabInfo = GetTalentTabInfo or function(index)
    return "Assasination", nil, math.random(1,10), "RogueAssasination"
end

ClassicLFG.DefaultProfile ={
    profile = {
        minimap = {
            hide = false,
        },
        InviteMessage = "invite please",
        BroadcastDungeonGroupInterval = 90,
        BroadcastDungeonGroupChannel = "General",
    },
}

function ClassicLFG:OnEnable()
    ClassicLFG.ChannelManager:UpdateChannels()
    JoinChannelByName(ClassicLFG.Config.Network.Channel.Name)
    local channels = { GetChannelList() }
    local i = 2
    while i < #channels do
        if (channels[i] == ClassicLFG.Config.Network.Channel.Name) then
            ClassicLFG.Config.Network.Channel.Id = channels[i - 1]
        end
        i = i + 3
    end
    self.Network:SendObject(self.Config.Events.RequestData, "RequestCGroupData", "CHANNEL", ClassicLFG.Config.Network.Channel.Id)
end

function ClassicLFG:OnInitialize()
    self.DB = LibStub("AceDB-3.0"):New("ClassicLFG_DB", self.DefaultProfile)
    ClassicLFG.LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ClassicLFG_LDB", {
        type = "data source",
        text = "TestText",
        icon = "Interface\\Icons\\inv_misc_groupneedmore",
        OnClick = self.MinimapIconClick
    })
    self.MinimapIcon:Register("ClassicLFG_LDB", self.LDB, self.DB.profile.minimap)
    self:RegisterChatCommand("lfg", "MinimapIconClick")
    self:RegisterChatCommand("classiclfg", "MinimapIconClick")
    self:RegisterChatCommand("clfg", "MinimapIconClick")
end

function ClassicLFG:MinimapIconClick()
    if (ClassicLFG.QueueWindow:IsShown() == false) then
        ClassicLFG.QueueWindow:Show()
    else
        ClassicLFG.QueueWindow:Hide()
    end
end