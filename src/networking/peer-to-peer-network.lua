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
    self.FriendSpreadingFactor = 3
    self.ChannelSpreadingFactor = 1
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
    self:BroadCastObjectToBattleNet(broadcastObject)
    -- self:BroadCastObjectToChannel(broadcastObject)
end

function ClassicLFGPeerToPeer:BroadCastObjectToFriends(broadcastObject)
    local friends = ClassicLFG:GetOnlineFriends()
    local friendBroadcastsSend = 0
    local i = 1
    while (friendBroadcastsSend < self.FriendSpreadingFactor and i < #friends) do
        if ClassicLFG:IsInPlayersGuild(friends[i].name) == false then
            ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectFriend, broadcastObject, "WHISPER", friends[i].name)
            friendBroadcastsSend = friendBroadcastsSend + 1
        end
        i = i + 1
    end
end

function ClassicLFGPeerToPeer:BroadCastObjectToChannel(broadcastObject)
    local numberOfChannelMembers = ClassicLFG:GetNumberOfChannelMembers(ClassicLFG.Config.Network.Channel.Name)
    local channelBroadcastsSend = 0
    local channelBroadcastsAttempts = 0
    while (channelBroadcastsSend < self.ChannelSpreadingFactor and channelBroadcastsSend < numberOfChannelMembers and self.ChannelSpreadingFactor < numberOfChannelMembers and channelBroadcastsAttempts < self.ChannelSpreadingFactor * 3) do
        local i = fastrandom(1, numberOfChannelMembers)
        local name = ClassicLFG:GetChannelMemberByIndex(ClassicLFG.Config.Network.Channel.Name, i)
        print("sending to", name, ClassicLFG.Config.Network.Channel.Name, numberOfChannelMembers, i)
        if (name and ClassicLFG:IsInPlayersGuild(name) == false and ClassicLFG:PlayerIsFriend(name) == false) then
            ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectFriend, broadcastObject, "WHISPER", name)
            channelBroadcastsSend = channelBroadcastsSend + 1
        end
        channelBroadcastsAttempts = channelBroadcastsAttempts + 1
    end
end

function ClassicLFGPeerToPeer:BroadCastObjectToBattleNet(broadcastObject)
    local numberOfBroadcastsSend = 0
    for i = 1, BNGetNumFriends() do
        local _, characterName, _, realm, _, faction = BNGetFriendGameAccountInfo(i, 1)
        if (characterName ~= nil and characterName ~= "" and realm == GetRealmName():gsub("%s+", "") and faction == UnitFactionGroup("player") and ClassicLFG:IsInPlayersGuild(characterName) == false and ClassicLFG:PlayerIsFriend(characterName) == false) then
            ClassicLFG.Network:SendObject(ClassicLFG.Config.Events.BroadcastObjectFriend, broadcastObject, "WHISPER", characterName)
            numberOfBroadcastsSend = numberOfBroadcastsSend + 1
            if (numberOfBroadcastsSend >= self.FriendSpreadingFactor) then
                break
            end
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
        self:BroadCastObject(broadcastObject)
    end
end

ClassicLFG.PeerToPeer = ClassicLFGPeerToPeer()