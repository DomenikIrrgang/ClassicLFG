ClassicLFGPlayerManager = {}
ClassicLFGPlayerManager.__index = ClassicLFGPlayerManager

setmetatable(ClassicLFGPlayerManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGPlayerManager.new()
    local self = setmetatable({}, ClassicLFGPlayerManager)
    self.Frame = CreateFrame("Frame", nil, nil, nil)
    self.Frame:RegisterEvent("PLAYER_LEVEL_CHANGED")
    self.Players = ClassicLFGLinkedList()
    
    self.BroadcastTimers = {}

    
    self.Frame:SetScript("OnEvent", function(_, event, _, newLevel)
        ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ChangePlayerLevel, newLevel)
    end)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonPlayerUpdated, self, self.ReceivePlayer)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerListed, self, self.ReceivePlayer)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.PlayerDelisted, self, self.HandleDequeuePlayer)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.ChatDungeonPlayerFound, self, self.HandleChatDungeonPlayerFound)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonPlayerBroadcasterCanceled, self, self.HandleDungeonPlayerBroadcasterCanceled)
     return self
end


function ClassicLFGPlayerManager:HandleChatDungeonPlayerFound(dungeonGroup)
    --ClassicLFG:DebugPrint("Found dungeonPlayer in chat: " .. dungeonGroup )
            
    if (dungeonGroup.Leader.Name ~= UnitName("player") and self:ContainsPlayer(dungeonGroup) == false ) then
        self.BroadcastTimers[dungeonGroup.Hash] = ClassicLFGPlayerBroadCaster(dungeonGroup)
        self.BroadcastTimers[dungeonGroup.Hash]:Start(math.random(1, ClassicLFG.Config.BroadcastInterval))
    end
end



function ClassicLFGPlayerManager:ReceivePlayer(dungeonGroup)
    if (not self:GroupContainsIgnoredMember(dungeonGroup)) then
        if (dungeonGroup.Leader.Name ~= UnitName("player")) then
            local groupIndex = self:HasPlayer(self.Players, dungeonGroup) 
            dungeonGroup.UpdateTime = GetTime()
            if (groupIndex ~= nil) then
                if (dungeonGroup.Source.Type == "ADDON" or self.Players:GetItem(groupIndex).Source.Type == dungeonGroup.Source.Type) then
                    self.Players:SetItem(groupIndex, dungeonGroup)
                end
            else
                self.Players:AddItem(dungeonGroup)
                
            end
        end
    end
end

function ClassicLFGPlayerManager:GroupContainsIgnoredMember(dungeonGroup)
    for i = 0, dungeonGroup.Members.Size - 1 do
        local member = ClassicLFGLinkedList.GetItem(dungeonGroup.Members, i)
        if (ClassicLFG:IsIgnored(member.Name)) then
            return true
        end
    end
    return false
end

function ClassicLFGPlayerManager:HandleDequeuePlayer(dungeonGroup)
    local index = self:HasPlayer(self.Groups, dungeonGroup)
    if (index ~= nil) then
        self.Players:RemoveItem(index)
        -- index = self:LeaderHasPlayer(self.Players, dungeonGroup.Leader.Name)
        -- if (index ~= nil) then
        --     self.Players:RemoveItem(index)
        -- end
    end
end

function ClassicLFGPlayerManager:HasPlayer(players, dungeonGroup)
    for i=0, players.Size - 1 do
        if (players:GetItem(i).Hash== dungeonGroup.Hash) then
            return i
        end
    end
    return nil
end

function ClassicLFGPlayerManager:ContainsPlayer(dungeonGroup)
    local index = self:HasPlayer(self.Players, dungeonGroup)
    return index ~= nil
end


function ClassicLFGPlayerManager:FilterPlayersByDungeon(dungeons)
    local players = {}
    for i=0, self.Players.Size - 1 do
        local player = self.Players:GetItem(i)
        if (ClassicLFG:ArrayContainsValue(dungeons, player.Dungeon.Name)) then
            table.insert(players, player)
        end
    end
    return players
end


function ClassicLFGPlayerManager:HandleDungeonPlayerBroadcasterCanceled(dungeonGroup)
    self.BroadcastTimers[dungeonGroup.Hash] = nil
end

ClassicLFG.PlayerManager = ClassicLFGPlayerManager()