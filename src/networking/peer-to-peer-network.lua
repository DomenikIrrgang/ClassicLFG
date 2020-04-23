ClassicLFGPeerToPeer = {}
ClassicLFGPeerToPeer.__index = ClassicLFGPeerToPeer

setmetatable(ClassicLFGPeerToPeer, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGPeerToPeer.new()
    local self = setmetatable({}, ClassicLFGPeerToPeer)
    self.TimeToLive = 5
    self.FriendSpreadingFactor = 2
    self.ChannelSpreadingFactor = 2
    self.HashSeen = {}
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.BroadcastObjectGuild, self, self.OnBroadcastObjectGuildReceived)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.BroadcastObjectFriend, self, self.OnBroadcastObjectFriendReceived)
	return self
end

function ClassicLFGPeerToPeer:StartBroadcastObject(event, object)
    self:BroadCastObject(self:CreateBroadcastObject(event, object))
end

function ClassicLFGPeerToPeer:BroadCastObject(broadcastObject)
    self:BroadCastObjectToGuild(broadcastObject)
    self:BroadCastObjectToFriends(broadcastObject)
end

function ClassicLFGPeerToPeer:BroadCastObjectToFriends(broadcastObject)
    local friends = ClassicLFG:GetOnlineFriends()
    local friendBroadcastsSend = 0
    local channelBroadcastsSend = 0
    local i = 1
    local numberOfChannelMembers = 0
    --[[local numberOfChannelMembers = ClassicLFG:GetNumberOfChannelMembers(ClassicLFG.Config.Network.Channel.Name)
    if numberOfChannelMembers < 1 then
        i = 1
    else
        i = math.random(1, numberOfChannelMembers - self.ChannelSpreadingFactor)
    end
    while (channelBroadcastsSend < self.ChannelSpreadingFactor and i <= numberOfChannelMembers) do
        local name = ClassicLFG:GetChannelMemberByIndex(ClassicLFG.Config.Network.Channel.Name, i)
        if ClassicLFG:IsInPlayersGuild(name) == false then
            ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectFriend, broadcastObject, "WHISPER", name)
            channelBroadcastsSend = channelBroadcastsSend + 1
        end
        i = i + 1
    end--]]
    i = 1
    if (numberOfChannelMembers == 0) then
        while (friendBroadcastsSend < self.FriendSpreadingFactor and i <= #friends) do
            if ClassicLFG:IsInPlayersGuild(friends[i].name) == false then
                ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectFriend, broadcastObject, "WHISPER", friends[i].name)
                friendBroadcastsSend = friendBroadcastsSend + 1
            end
            i = i + 1
        end
    end
end

function ClassicLFGPeerToPeer:BroadCastObjectToGuild(broadcastObject)
    if (IsInGuild()) then
        ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectGuild, broadcastObject, "GUILD")
    end
end

function ClassicLFGPeerToPeer:CreateBroadcastObject(event, object)
    return { Hash = ClassicLFG:RandomHash(8), Object = object, Event = event, TimeToLive = self.TimeToLive, Jumps = 0 }
end

function ClassicLFGPeerToPeer:ShouldForwardObject(broadcastObject)
    return broadcastObject.Jumps <= broadcastObject.TimeToLive and self:ObjectSeen(broadcastObject) == false
end

function ClassicLFGPeerToPeer:ObjectSeen(broadcastObject)
    for _, value in pairs(self.HashSeen) do
        if value == broadcastObject.Hash then
            return true
        end
    end
    return false
end

function ClassicLFGPeerToPeer:ObjectReceived(broadcastObject)
    table.insert(self.HashSeen, broadcastObject.Hash)
    broadcastObject.Jumps = broadcastObject.Jumps + 1
end

function ClassicLFGPeerToPeer:OnBroadcastObjectGuildReceived(broadcastObject)
    ClassicLFG:DebugPrint("[PeerToPeer] Guild Message Received")
    if (self:ObjectSeen(broadcastObject) == false) then
        ClassicLFG.EventBus:PublishEvent(broadcastObject.Event, broadcastObject.Object)
    end
    self:ObjectReceived(broadcastObject)
    if (self:ShouldForwardObject(broadcastObject)) then
        self:BroadCastObjectToFriends(broadcastObject)
    end
end

function ClassicLFGPeerToPeer:OnBroadcastObjectFriendReceived(broadcastObject)
    ClassicLFG:DebugPrint("[PeerToPeer] Friend Message Received")
    if (self:ObjectSeen(broadcastObject) == false) then
        ClassicLFG.EventBus:PublishEvent(broadcastObject.Event, broadcastObject.Object)
    end
    self:ObjectReceived(broadcastObject)
    if (self:ShouldForwardObject(broadcastObject)) then
        self:BroadCastObjectToFriends(broadcastObject)
        self:BroadCastObjectToGuild(broadcastObject)
    end
end

ClassicLFG.PeerToPeer = ClassicLFGPeerToPeer()