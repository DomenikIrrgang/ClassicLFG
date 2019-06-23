ClassicLFGChannelManager = {}
ClassicLFGChannelManager.__index = ClassicLFGChannelManager

setmetatable(ClassicLFGChannelManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGChannelManager.new()
    local self = setmetatable({}, ClassicLFGChannelManager)
    self.Frame = CreateFrame("frame")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        self:UpdateChannels()
        self:CheckIfInConfiguredChannel()
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChannelListChanged, self.Channels)
    end)
    self.Channels = {}
    return self
end

function ClassicLFGChannelManager:UpdateChannels()
    local channels = { GetChannelList() }
    self.Channels = {}
    local i = 1
    while i < #channels do
        local id, name = GetChannelName(channels[i])
        table.insert(self.Channels, { Name = name, Id = id })
        i = i + 3
    end
end

function ClassicLFGChannelManager:CheckIfInConfiguredChannel()
    local id, name = GetChannelName(ClassicLFG.DB.profile.BroadcastDungeonGroupChannel)
    if (name == nil) then
        ClassicLFG.DB.profile.BroadcastDungeonGroupChannel = self.Channels[1].Id
    end
end

function ClassicLFGChannelManager:GetChannels()
    return self.Channels
end

function ClassicLFGChannelManager:GetChannelNames()
    local names = {}
    for key in pairs(self.Channels) do
        table.insert(names, self.Channels[key].Name)
    end
    return names
end

function ClassicLFGChannelManager:GetChannelId(name)
    for key, value in pairs(self.Channels) do
        if (value.Name == name) then
            return value.Id
        end
    end
end

function ClassicLFGChannelManager:GetChannelName(id)
    for key, value in pairs(self.Channels) do
        if (value.Id == id) then
            return value.Name
        end
    end
end


ClassicLFG.ChannelManager = ClassicLFGChannelManager()