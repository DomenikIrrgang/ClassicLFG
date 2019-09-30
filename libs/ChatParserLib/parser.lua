ChatParser = {}
ChatParser.__index = ChatParser

setmetatable(ChatParser, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ChatParser.new(filters, callback)
    local self = setmetatable({}, ChatParser)
    self.filters = {}
    self.Frame = CreateFrame("frame")
    self.Frame:RegisterEvent("CHAT_MSG_SAY")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL")
    self.Frame:RegisterEvent("CHAT_MSG_YELL")
    self.Frame:RegisterEvent("CHAT_MSG_WHISPER")
    self.Frame:SetScript("OnEvent", function(_, type, ...)
        local message, sender = ...
        local typeInformation = nil

        if (type == "CHAT_MSG_CHANNEL") then
            local _, _, _, _, _, _, _, _, channelName = ...
            typeInformation = channelName
        end

        self:MessageReceived(ChatParserMessage(sender, type, typeInformation, message))
    end)
    return self
end

function ChatParser:MessageReceived(message)
    for _, filter in pairs(self.filters) do
        if (filter:OnMessage(message) == false) then
            return
        end
    end
    self.callback(message)
end