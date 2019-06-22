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
    StaticPopup1Button2:SetScript("OnHide", function() self:DeclineGroupInvite() end)
    self.Frame:SetScript("OnEvent", function(_, event, message, ...)
        if (event == "CHAT_MSG_SYSTEM") then
            if (not IsInGroup() and message:find(ClassicLFG.Locale[" has invited you to join a group."])) then
                message = message:gsub("|Hplayer", "") 
                self.InvitePending = message:sub(2, message:find("%[") - 3)
            end
        end
    end)
    return self
end

function ClassicLFGGroupInviteManager:DeclineGroupInvite()
    if (self.InvitePending ~= nil) then
        DeclineGroup()
        ClassicLFG.EventBus:PublishEvent(ClassicLFG.Config.Events.GroupInviteDeclined, self.InvitePending)
        self.InvitePending = nil
    end
end


ClassicLFG.GroupInviteManager = ClassicLFGGroupInviteManager()