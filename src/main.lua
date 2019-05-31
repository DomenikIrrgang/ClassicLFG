ClassicLFG = LibStub("AceAddon-3.0"):NewAddon("ClassicLFG")
ClassicLFG.AceGUI = LibStub("AceGUI-3.0")

GetTalentTabInfo = GetTalentTabInfo or function(index)
    return "Assasination", nil, math.random(1,10), "RogueAssasination"
end

function ClassicLFG:OnEnable()
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