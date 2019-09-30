ChatParserMessage = {}
ChatParserMessage.__index = ChatParserMessage

setmetatable(ChatParserMessage, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ChatParserMessage.new(sender, type, typeInformation, message)
    local self = setmetatable({}, ChatParserMessage)
    self.value = message
    self.type = type
    self.typeInformation = typeInformation
    self.sender = sender
    self.timestamp = GetTime()
    return self
end
