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
            if (message == ClassicLFG.DB.profile.InviteKeyword) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.InviteWhisperReceived, player)
            end
        end
    end)
    return self
end

function ClassicLFGChatParser:HasIgnoreMessageTag(text)
    return string.find(text, "#noclassiclfg") ~= nil
end

function ClassicLFGChatParser:ParseMessage(sender, message, channel)
    local lowerMessage = string.lower(message)
    self:HasRoleName(lowerMessage)
    local dungeon = self:HasDungeonName(lowerMessage) or self:HasDungeonAbbreviation(lowerMessage)
    if (not self:HasIgnoreMessageTag(lowerMessage)) then
        if ((self:HasLFMTag(lowerMessage) or self:HasRoleName(lowerMessage)) and not self:HasLFGTag(lowerMessage) and dungeon ~= nil) then
            local dungeonGroup = ClassicLFGDungeonGroup(dungeon, ClassicLFGPlayer(sender), message, "", { Type = "CHAT", Channel = channel})
            ClassicLFG:DebugPrint("Found Dungeongroup in chat: " .. message .. " (" .. dungeon.Name .. ")")
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChatDungeonGroupFound, dungeonGroup)
        end

        if (self:HasLFMTag(lowerMessage) and not self:HasLFGTag(lowerMessage) and dungeon == nil) then
            local dungeonGroup = ClassicLFGDungeonGroup(ClassicLFG.DungeonManager.Dungeons["Custom"], ClassicLFGPlayer(sender), message, "", { Type = "CHAT", Channel = channel})
            ClassicLFG:DebugPrint("Found Dungeongroup in chat: " .. message .. " (" .. ClassicLFG.DungeonManager.Dungeons["Custom"].Name .. ")")
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChatDungeonGroupFound, dungeonGroup)
        end
    end
end

function ClassicLFGChatParser:HasLFGTag(message)
    if (string.find(message, "lfg")) then
        return true
    end
    return false
end

function ClassicLFGChatParser:HasLFMTag(text)
    local lfmTags = {
        "lfm",
        "lf3m",
        "lf2m",
        "lf1m",
        "looking for more"
    }
    local found = false
    for _, tag in pairs(lfmTags) do
        if (string.find(text, tag)) then
            found = true
            break
        end
    end
    return found
end

function ClassicLFGChatParser:HasDungeonName(message)
    for dungeonName, dungeon in pairs(ClassicLFG.DungeonManager:GetAllDungeons()) do
        if (string.find(message, ClassicLFG.Locale[dungeonName]:lower())) then
            return ClassicLFG.DungeonManager.Dungeons[dungeonName]
        end
    end
    return nil
end

function ClassicLFGChatParser:HasDungeonAbbreviation(message)
    for key, dungeon in pairs(ClassicLFG.DungeonManager.Dungeons) do
        for _, abbreviation in pairs(dungeon.Abbreviations) do
            if (ClassicLFG:ArrayContainsValue(message:SplitString(" "), abbreviation)) then
                return dungeon
            end
        end
    end
    return nil
end

function ClassicLFGChatParser:HasRoleName(message)
    local words = message:SplitString(" ")
    return ClassicLFG:ArrayContainsArrayValue(words, ClassicLFG.Locale["RolesArray"])
end

ClassicLFG.ChatParser = ClassicLFGChatParser()