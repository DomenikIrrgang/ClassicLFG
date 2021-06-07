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
            if (self:HasInviteKeyword(message)) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.InviteWhisperReceived, player, message)
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

        if (not self:HasLFMTag(lowerMessage) and self:HasLFGTag(lowerMessage) and dungeon ~= nil) then
            ClassicLFG:DebugPrint("[ChatParser] Found LFG in chat: " .. message .. " (" .. dungeon.Name .. ")")
            ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.ChatLFGFound, sender, message, dungeon)
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
        "looking for more",
        "lf3d",
        "lf2d",
        "lf1d"
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

function ClassicLFGChatParser:HasInviteKeyword(text)
    local found = false
    for _, tag in pairs(ClassicLFG.Locale["InviteKeywords"]) do
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
            if (ClassicLFG:ArrayContainsValue(message:gsub(",+", ""):SplitString(" "), abbreviation)) then
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

function ClassicLFGChatParser:OnChatMessage(onChatMessage)
    return function(chatFrame, message, ...)
        local containsDungeon = self:HasDungeonName(message:lower()) or self:HasDungeonAbbreviation(message:lower())
        if (not self:HasLFMTag(message:lower()) or not containsDungeon or ClassicLFG.DB.profile.FilterChat == false) then
            --message = message .. " " .. tostring(not self:HasLFMTag(message:lower())) .. " "  .. tostring(not containsDungeon) .. " " .. tostring(ClassicLFG.DB.profile.FilterChat == false)
            onChatMessage(chatFrame, message, ...)
        end
    end
end

ClassicLFG.ChatParser = ClassicLFGChatParser()
ChatFrame1.AddMessage = ClassicLFG.ChatParser:OnChatMessage(ChatFrame1.AddMessage)
if (ChatFrame2) then
    ChatFrame2.AddMessage = ClassicLFG.ChatParser:OnChatMessage(ChatFrame2.AddMessage)
end
if (ChatFrame3) then
    ChatFrame3.AddMessage = ClassicLFG.ChatParser:OnChatMessage(ChatFrame3.AddMessage)
end