ClassicLFGWhisperNetwork = {}
ClassicLFGWhisperNetwork.__index = ClassicLFGWhisperNetwork

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

setmetatable(ClassicLFGWhisperNetwork, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGWhisperNetwork.new()
    local self = setmetatable({}, ClassicLFGWhisperNetwork)
    C_ChatInfo.RegisterAddonMessagePrefix(ClassicLFG.Config.Network.Prefix)
    self.NetworkThread = CreateFrame("frame")
    self.MessageBuffer = {}
    self.Count = 0
    C_Timer.NewTicker(15, function()
        self.Count = 0
    end)
	return self
end

function ClassicLFGWhisperNetwork:HandleAddonMessage(sender, message)
    local player, playerRealm = UnitFullName("player")
	if (sender ~= player .. "-" .. playerRealm) then
        local headers, content = self:SplitNetworkPackage(message)
        self.MessageBuffer[headers.Hash] = self.MessageBuffer[headers.Hash] or {}
        self.MessageBuffer[headers.Hash][headers.Order] = content
        if (self.MessageBuffer[headers.Hash]["count"] ~= nil and self.MessageBuffer[headers.Hash]["count"] >= 1) then
            self.MessageBuffer[headers.Hash]["count"] = self.MessageBuffer[headers.Hash]["count"] + 1
        else
            self.MessageBuffer[headers.Hash]["count"] = 1
        end
        --ClassicLFG:DebugPrint("Received package " .. headers.Order .. " of " .. headers.TotalCount .. ". Total: " .. self.MessageBuffer[headers.Hash]["count"])
        if (self.MessageBuffer[headers.Hash]["count"] == tonumber(headers.TotalCount)) then
            local successful, object = self:MessageToObject(self:MergeMessages(headers, self.MessageBuffer[headers.Hash]))
            ClassicLFG:DebugPrint("Network Package from " .. sender .. " complete! Event: " .. object.Event)
            self.MessageBuffer[headers.Hash] = nil
            ClassicLFG.EventBus:PublishEvent(object.Event, object.Payload, sender)
        end
    end
end

function ClassicLFGWhisperNetwork:SendObject(event, object, channel, target)
    ClassicLFG:DebugPrint("Network Event Send")
    ClassicLFG:DebugPrint("Event: " .. event .. " Channel: " .. channel)
    self:SendMessage(ClassicLFG.Config.Network.Prefix, self:ObjectToMessage({ Event = event, Payload = object }), channel, target)
end

function ClassicLFGWhisperNetwork:SendMessage(prefix, message, channel, target)
    local messages = self:SplitMessage(message)
    for key in pairs(messages) do
        self.Count = self.Count + 1
        SendChatMessage(messages[key], "WHISPER", nil, target)
    end
end

function ClassicLFGWhisperNetwork:MessageToObject(message)
	return Serializer:Deserialize(message)
end

function ClassicLFGWhisperNetwork:ObjectToMessage(object)
	return Serializer:Serialize(object)
end

function ClassicLFGWhisperNetwork:MergeMessages(headers, messages)
    local tmp = ""
    ClassicLFG:RecursivePrint(messages, 2)
    for i = 1, tonumber(headers.TotalCount) do
        tmp = tmp .. messages[tostring(i)]
    end
    return tmp
end

function ClassicLFGWhisperNetwork:SplitMessage(message)
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

function ClassicLFGWhisperNetwork:CreatePackageHeaders(messageCount, hash, totalCount)
    return { Prefix = ClassicLFG.Config.Network.Prefix, Order = messageCount, Hash = hash, TotalCount = totalCount, Length = 4 + ClassicLFG.Config.Network.Prefix:len() + hash:len() + tostring(messageCount):len() + tostring(totalCount):len() }
end

function ClassicLFGWhisperNetwork:CreateNetworkPackage(headers, content)
    local header = headers.Prefix .. "#" .. headers.Hash .. "#" .. headers.Order .. "#" .. headers.TotalCount .. "#"
    return header .. content
end

function ClassicLFGWhisperNetwork:SplitNetworkPackage(package)
    local splitPackage = package:SplitString("#")
    local headers = self:CreatePackageHeaders(splitPackage[3], splitPackage[2], splitPackage[4])
    local content = splitPackage[5]
    return headers, content
end

function ClassicLFGWhisperNetwork:RandomHash(length)
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


local old = ChatFrame1.AddMessage 
ChatFrame1.AddMessage = function(self, message, ...)
    if ((message:find("whispers")) and message:find(ClassicLFG.Config.Network.Prefix)) then
        --old(self, "addon message detected " ..  message)
        ClassicLFG.WhisperNetwork:HandleAddonMessage("Suaddon", message)
    else
        if  ((message:find("To")) and message:find(ClassicLFG.Config.Network.Prefix)) then
        else
            old(self, message, ...)
        end
    end
end

ClassicLFG.WhisperNetwork = ClassicLFGWhisperNetwork()