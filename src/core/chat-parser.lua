ClassicLFGChatParser = {}
ClassicLFGChatParser.__index = ClassicLFGChatParser

setmetatable(ClassicLFGChatParser, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGChatParser.new()
    local self = setmetatable({}, ClassicLFGChatParser)
    self.Frame = CreateFrame("frame")
    self.Frame:RegisterEvent("CHAT_MSG_SAY")
    self.Frame:RegisterEvent("CHAT_MSG_CHANNEL")
    self.Frame:RegisterEvent("CHAT_MSG_YELL")
    self.Frame:RegisterEvent("CHAT_MSG_WHISPER")
    self.Frame:SetScript("OnEvent", function(_, event, ...)
        if (event == "CHAT_MSG_CHANNEL") then
            local message, player, _, _, _, _, _, _, channelName = ...
            self:ParseMessage(player, message, channelName)
        end

        if (event == "CHAT_MSG_SAY") then
            local message, player, _, _, _, _, _, _, channelName = ...
            self:ParseMessage(player, message, "SAY")
        end

        if (event == "CHAT_MSG_YELL") then
            local message, player, _, _, _, _, _, _, channelName = ...
            self:ParseMessage(player, message, "YELL")
        end

        if (event == "CHAT_MSG_WHISPER") then
            local message, player = ...
            if (message:find(ClassicLFG.DB.profile.InviteKeyword) ~= nil) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.InviteWhisperReceived, player)
            end
        end
    end)
    return self
end

function ClassicLFGChatParser:ParseMessage(sender, message, channel)
    local lowerMessage = string.lower(message)
    local dungeon = self:HasDungeonName(lowerMessage) or self:HasDungeonAbbreviation(lowerMessage)
    if (self:HasLFMTag(lowerMessage) and dungeon ~= nil) then
        local dungeonGroup = ClassicLFGDungeonGroup(dungeon, ClassicLFGPlayer(sender), message, "", { Type = "CHAT", Channel = channel})
        ClassicLFG:DebugPrint("Found Dungeongroup in chat: " .. message .. " (" .. dungeon.Name .. ")")
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChatDungeonGroupFound, dungeonGroup)
    end

    if (self:HasLFMTag(lowerMessage) and dungeon == nil) then
        local dungeonGroup = ClassicLFGDungeonGroup(ClassicLFG.Dungeon["Custom"], ClassicLFGPlayer(sender), message, "", { Type = "CHAT", Channel = channel})
        ClassicLFG:DebugPrint("Found Dungeongroup in chat: " .. message .. " (" .. ClassicLFG.Dungeon["Custom"].Name .. ")")
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChatDungeonGroupFound, dungeonGroup)
    end
end

function ClassicLFGChatParser:HasLFMTag(text)
    return string.find(text, "lfm") ~= nil or string.find(text, "lf3m") ~= nil or string.find(text, "lf2m") ~= nil or string.find(text, "lf1m") ~= nil
end

function ClassicLFGChatParser:HasDungeonName(message)
    return ClassicLFG.Dungeon[ClassicLFG:StringContainsTableValue(message, ClassicLFG.DungeonList)]
end

function ClassicLFGChatParser:HasDungeonAbbreviation(message)
    for key in pairs(ClassicLFG.Dungeon) do
        if (ClassicLFG:StringContainsTableValue(message, ClassicLFG.Dungeon[key].Abbreviations)) then
            return ClassicLFG.Dungeon[key]
        end
    end
    return nil
end

ClassicLFG.ChatParser = ClassicLFGChatParser()