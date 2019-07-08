ClassicLFGGroupInviteManager = {}
ClassicLFGGroupInviteManager.__index = ClassicLFGGroupInviteManager

setmetatable(ClassicLFGGroupInviteManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGGroupInviteManager.new()
    local self = setmetatable({}, ClassicLFGGroupInviteManager)
    self.Frame = CreateFrame("frame")
    self.InvitePending = nil
    self.Frame:RegisterEvent("CHAT_MSG_SYSTEM")
    self.Frame:RegisterEvent("PARTY_INVITE_REQUEST")
    StaticPopup1Button2:SetScript("OnHide", function() self:DeclineGroupInvite() end)
    self.Frame:SetScript("OnEvent", function(_, event, message, ...)
        if (event == "CHAT_MSG_SYSTEM") then
            if (not IsInGroup() and message:find(ClassicLFG.Locale[" has invited you to join a group."])) then
                message = message:gsub("|Hplayer", "") 
                local player = message:sub(2, message:find("%[") - 3)
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteReceived, player)
            end

            if(message:find(ClassicLFG.Locale[" declines your group invitation."])) then
                local player = message:gsub(ClassicLFG.Locale[" declines your group invitation."], "")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteDeclined, player)
            end

            if(message:find(ClassicLFG.Locale[" leaves the party."])) then
                local player = message:gsub(ClassicLFG.Locale[" leaves the party."], "")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupMemberLeft, player)
            end

            if(message:find(ClassicLFG.Locale[" is already in a group."])) then
                local player = message:gsub(ClassicLFG.Locale[" is already in a group."], "")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteAlreadyInGroup, player)
            end

            if (message:find(ClassicLFG.Locale["Your group has been disbanded."])) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupDisbanded)
            end

            if (message:find(ClassicLFG.Locale["You leave the group."])) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupLeft)
            end

            if (message:find(ClassicLFG.Locale["You have been removed from the group."])) then
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupKicked)
            end
            
            if(message:find(ClassicLFG.Locale[" joins the party."])) then
                local player = message:gsub(ClassicLFG.Locale[" joins the party."], "")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupMemberJoined, player)
            end

            if(message:find(ClassicLFG.Locale[" to join your group."])) then
                local player = message:gsub(ClassicLFG.Locale[" to join your group."], "")
                player = player:gsub(ClassicLFG.Locale["You have invited "], "")
                ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteSend, player)
            end
        end

        if (event == "PARTY_INVITE_REQUEST") then
            if (ClassicLFG.DB.profile.AutoAcceptInvite == true) then
                for key, group in pairs(ClassicLFG.GroupManager.AppliedGroups:ToArray()) do
                    if (group.Leader.Name == message) then
                        AcceptGroup()
                        StaticPopup1:Hide()
                    end
                end
            end
        end
    end)

    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.GroupInviteReceived, self, self.OnGroupInviteReceived)
    return self
end

function ClassicLFGGroupInviteManager:OnGroupInviteReceived(player)
    self.InvitePending = player
end

function ClassicLFGGroupInviteManager:DeclineGroupInvite()
    if (self.InvitePending ~= nil) then
        DeclineGroup()
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteDecline, self.InvitePending)
        self.InvitePending = nil
    end
end


ClassicLFG.GroupInviteManager = ClassicLFGGroupInviteManager()