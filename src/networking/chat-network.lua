ClassicLFGChatNetwork = {}
ClassicLFGChatNetwork.__index = ClassicLFGChatNetwork

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

setmetatable(ClassicLFGChatNetwork, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGChatNetwork.new()
    local self = setmetatable({}, ClassicLFGChatNetwork)
    C_ChatInfo.RegisterAddonMessagePrefix(ClassicLFG.Config.Network.Prefix)
    self.NetworkThread = CreateFrame("frame")
    self.MessageBuffer = {}
    self.Count = 0
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", self.ChatFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", self.ChatFilter)
    C_Timer.NewTicker(1, function()
        self.Count = 0
        for key, value in pairs(self.MessageBuffer) do
            if (value.Completed == true) then
                self.MessageBuffer[key] = nil
            end
        end
    end)
	return self
end

function ClassicLFGChatNetwork:ChatFilter(event, message, sender, ...)
    if (message:find(ClassicLFG.Config.Network.Prefix)) then
        ClassicLFG.ChatNetwork:HandleAddonMessage(sender, message)
        return true
    else
        return false
    end
end

function ClassicLFGChatNetwork:HandleAddonMessage(sender, message)
    local player, playerRealm = UnitFullName("player")
	if (sender ~= player .. "" .. playerRealm) then
        local headers, content = self:SplitNetworkPackage(message)
        self.MessageBuffer[headers.Hash] = self.MessageBuffer[headers.Hash] or {}
        self.MessageBuffer[headers.Hash][headers.Order] = content
        local receivedAllMessages = true
        for i = 1, tonumber(headers.TotalCount) do
            if (self.MessageBuffer[headers.Hash][tostring(i)] == nil) then
                receivedAllMessages = false
                break
            end
        end
        --ClassicLFG:DebugPrint("Received package " .. headers.Order .. " of " .. headers.TotalCount .. ". Total: " .. self.MessageBuffer[headers.Hash]["count"])
        if (receivedAllMessages and self.MessageBuffer[headers.Hash].Completed ~= true) then
            print(headers.Hash, sender, "all recieved")
            self.MessageBuffer[headers.Hash].Completed = true
            local successful, object = self:MessageToObject(self:MergeMessages(headers, self.MessageBuffer[headers.Hash]))
            ClassicLFG:NetworkDebugPrint("[ChatNetwork] Network Package from " .. sender .. " complete! Event: " .. object.Event)
            --self.MessageBuffer[headers.Hash] = nil
            ClassicLFG.EventBus:PublishEvent(object.Event, object.Payload, sender)
        end
    end
end

function ClassicLFGChatNetwork:SendObject(event, object, channel, target)
    ClassicLFG:NetworkDebugPrint("[ChatNetwork] Network Event Send")
    ClassicLFG:NetworkDebugPrint("[ChatNetwork] Event: " .. event .. " Channel: " .. channel)
    self:SendMessage(ClassicLFG.Config.Network.Prefix, self:ObjectToMessage({ Event = event, Payload = object }), channel, target)
end

function ClassicLFGChatNetwork:SendMessage(prefix, message, channel, target)
    local messages = self:SplitMessage(message)
    for key in pairs(messages) do
        self.Count = self.Count + 1
        SendChatMessage(messages[key], channel, nil, target)
    end
end

function ClassicLFGChatNetwork:MessageToObject(message)
	return Serializer:Deserialize(message)
end

function ClassicLFGChatNetwork:ObjectToMessage(object)
	return Serializer:Serialize(object)
end

function ClassicLFGChatNetwork:MergeMessages(headers, messages)
    local tmp = ""
    ClassicLFG:RecursivePrint(messages, 2)
    for i = 1, tonumber(headers.TotalCount) do
        tmp = tmp .. messages[tostring(i)]
    end
    return tmp
end

function ClassicLFGChatNetwork:SplitMessage(message)
    local messages = {}
    local hash = self:RandomHash(8)
    -- Note: -3 for Splitting Characters in protocol and -2 for MessageCount and TotalCount and - hashlength
    local maxSize = 255 - 4 - 2 - hash:len() - ClassicLFG.Config.Network.Prefix:len()
    local totalCount = math.ceil(message:len() / maxSize)
    if (totalCount >= 10) then
        -- Note: -9 for Messages with Count < 10 and -2 for for increased Size of MessageCount and TotalCount
        totalCount = math.ceil((message:len() - 9) / (maxSize - 2))
    end
    local index = 1
    local messageCount = 1
    while (index < message:len()) do
        local headers = self:CreatePackageHeaders(messageCount, hash, totalCount)
        local content = message:sub(index, (index - 1) + 255 - headers.Length)
        table.insert(messages, self:CreateNetworkPackage(headers, content))
        index = index + content:len()
        messageCount = messageCount + 1
    end
    return messages
end

function ClassicLFGChatNetwork:CreatePackageHeaders(messageCount, hash, totalCount)
    return { Prefix = ClassicLFG.Config.Network.Prefix, Order = messageCount, Hash = hash, TotalCount = totalCount, Length = 4 + ClassicLFG.Config.Network.Prefix:len() + hash:len() + tostring(messageCount):len() + tostring(totalCount):len() }
end

function ClassicLFGChatNetwork:CreateNetworkPackage(headers, content)
    local header = headers.Prefix .. "#" .. headers.Hash .. "#" .. headers.Order .. "#" .. headers.TotalCount .. "#"
    return header .. content
end

function ClassicLFGChatNetwork:SplitNetworkPackage(package)
    local splitPackage = package:SplitString("#")
    local headers = self:CreatePackageHeaders(splitPackage[3], splitPackage[2], splitPackage[4])
    local content = splitPackage[5]
    return headers, content
end

function ClassicLFGChatNetwork:RandomHash(length)
    if( length == nil or length <= 0 ) then length = 32; end;
    local holder = "";
    local hash_chars = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E",
                    "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                    "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
                    "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};

    for i = 1, length do
        local index = math.random(1, #hash_chars);
        holder = holder .. hash_chars[index];
    end

    return holder;
end

--[[
local old = ChatFrame1.AddMessage
ChatFrame1.AddMessage = function(self, message, ...)
    if (message:find(ClassicLFG.Config.Network.Prefix)) then
        --old(self, "addon message detected " ..  message)
        --ClassicLFG.ChatNetwork:HandleAddonMessage("Suaddon", message)
    else
        if ((message:find("To")) and message:find(ClassicLFG.Config.Network.Prefix)) then
        else
            old(self, message, ...)
        end
    end
end

if (ChatFrame2) then
    local old2 = ChatFrame2.AddMessage
    ChatFrame2.AddMessage = function(self, message, ...)
        if (message:find(ClassicLFG.Config.Network.Prefix)) then
            --old(self, "addon message detected " ..  message)
            --ClassicLFG.ChatNetwork:HandleAddonMessage("Suaddon", message)
        else    
            if ((message:find("To")) and message:find(ClassicLFG.Config.Network.Prefix)) then
            else
                old2(self, message, ...)
            end 
        end
    end
end
]]--
ClassicLFG.ChatNetwork = ClassicLFGChatNetwork()