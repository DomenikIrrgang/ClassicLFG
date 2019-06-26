ClassicLFGNetwork = {}
ClassicLFGNetwork.__index = ClassicLFGNetwork

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

setmetatable(ClassicLFGNetwork, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGNetwork.new()
    local self = setmetatable({}, ClassicLFGNetwork)
    C_ChatInfo.RegisterAddonMessagePrefix(ClassicLFG.Config.Network.Prefix)
    self.NetworkThread = CreateFrame("frame")
    self.MessageBuffer = {}
	self.SendingInterval = 20000
    self.LastMessageSend = GetTime()
	self.NetworkThread:SetScript("OnUpdate", function()
		--print("Network Thread invoked!")
    end)
    self.NetworkThread:RegisterEvent("CHAT_MSG_ADDON")
    self.NetworkThread:RegisterEvent("CHAT_MSG_ADDON_LOGGED")
    self.NetworkThread:SetScript("OnEvent", function(_, event, ...)
        if (event == "CHAT_MSG_ADDON" or event == "CHAT_MSG_ADDON_LOGGED") then
            self:HandleAddonMessage(...)
        end
	end)
	return self
end

function ClassicLFGNetwork:HandleAddonMessage(...)
    local prefix, message, channel, sender = ...
    local player, playerRealm = UnitFullName("player")
	if (prefix:find(ClassicLFG.Config.Network.Prefix) and sender ~= player .. "-" .. playerRealm) then
        local headers, content = self:SplitNetworkPackage(message)
        self.MessageBuffer[headers.Hash] = self.MessageBuffer[headers.Hash] or {}
        self.MessageBuffer[headers.Hash][headers.Order] = content
        if (self.MessageBuffer[headers.Hash]["count"] ~= nil and self.MessageBuffer[headers.Hash]["count"] >= 1) then
            self.MessageBuffer[headers.Hash]["count"] = self.MessageBuffer[headers.Hash]["count"] + 1
        else
            self.MessageBuffer[headers.Hash]["count"] = 1
        end
        if (self.MessageBuffer[headers.Hash]["count"] == tonumber(headers.TotalCount)) then
            local successful, object = self:MessageToObject(self:MergeMessages(headers,self.MessageBuffer[headers.Hash]))
            ClassicLFG:DebugPrint("Network Package from " .. sender .. " complete! Event: " .. object.Event)
            self.MessageBuffer[headers.Hash] = nil
            ClassicLFG.EventBus:PublishEvent(object.Event, object.Payload, sender)
        end
    end
end

function ClassicLFGNetwork:SendObject(event, object, channel, target)
    ClassicLFG:DebugPrint("Network Event Send")
    ClassicLFG:DebugPrint("Event: " .. event .. " Channel: " .. channel)
    self:SendMessage(ClassicLFG.Config.Network.Prefix, self:ObjectToMessage({ Event = event, Payload = object }), channel, target)
end

function ClassicLFGNetwork:SendMessage(prefix, message, channel, target)
    local messages = self:SplitMessage(message)
    for key in pairs(messages) do
        C_ChatInfo.SendAddonMessage(prefix, messages[key], channel, target)
    end
end

function ClassicLFGNetwork:MessageToObject(message)
	return Serializer:Deserialize(message)
end

function ClassicLFGNetwork:ObjectToMessage(object)
	return Serializer:Serialize(object)
end

function ClassicLFGNetwork:MergeMessages(headers, messages)
    local tmp = ""
    for i = 1, tonumber(headers.TotalCount) do
        tmp = tmp .. messages[tostring(i)]
    end
    return tmp
end

function ClassicLFGNetwork:SplitMessage(message)
    local messages = {}
    local hash = self:RandomHash(8)
    -- Note: -3 for Splitting Characters in protocol and -2 for MessageCount and TotalCount and - hashlength
    local maxSize = 255 - 3 - 2 - hash:len()
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

function ClassicLFGNetwork:CreatePackageHeaders(messageCount, hash, totalCount)
    return { Order = messageCount, Hash = hash, TotalCount = totalCount, Length = 3 + hash:len() + tostring(messageCount):len() + tostring(totalCount):len() }
end

function ClassicLFGNetwork:CreateNetworkPackage(headers, content)
    local header = headers.Hash .. "\a" .. headers.Order .. "\a" .. headers.TotalCount .. "\a"
    return header .. content
end

function ClassicLFGNetwork:SplitNetworkPackage(package)
    local splitPackage = package:SplitString("\a")
    local headers = self:CreatePackageHeaders(splitPackage[2], splitPackage[1], splitPackage[3])
    local content = splitPackage[4]
    return headers, content
end

function ClassicLFGNetwork:RandomHash(length)
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

ClassicLFG.Network = ClassicLFGNetwork()