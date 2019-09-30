ChatParserFilter = {}
ChatParserFilter.__index = ChatParserFilter

setmetatable(ChatParserFilter, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ChatParserFilter.new(types, callback)
    local self = setmetatable({}, ChatParserFilter)
    self.types = types or {}
    self.callback = callback or function() return true end
    return self
end

function ChatParserFilter:OnMessage(message)
    for _, value in pairs(self.types) do
        if ((message.type == value)) then
            return self.callback(message)
        end
    end
    return false
end
