ClassicLFGToastManager = {}
ClassicLFGToastManager.__index = ClassicLFGToastManager

setmetatable(ClassicLFGToastManager, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGToastManager.new()
    local self = setmetatable({}, ClassicLFGToastManager)
    self.ToastQueue = {}
    self.Toast = ClassicLFGToast(ClassicLFG.Store:GetState().Db.profile.Toast.X, ClassicLFG.Store:GetState().Db.profile.Toast.Y, 260, 65)
    self.Movable = false
    self.Toast.OnToastFinished = function()
        if (self.Movable == false) then
            table.remove(self.ToastQueue, 1)
            if (#self.ToastQueue > 0) then
                self.Toast:Show(self.ToastQueue[1].Title, self.ToastQueue[1].Message, self.ToastQueue[1].Duration, self.ToastQueue[1].Object, self.ToastQueue[1].Callback)
            end
        else
            self.Toast:Show("MOVE ME", "", 3)
        end
    end
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupJoined, self, self.OnDungeonGroupJoined)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DungeonGroupLeft, self, self.OnDungeonGroupLeft)
    ClassicLFG.EventBus:RegisterCallback(ClassicLFG.Config.Events.DeclineApplicant, self, self.OnApplicationDeclined)
    return self
end

function ClassicLFGToastManager:OnDungeonGroupJoined(dungeonGroup)
    self:ShowToast(ClassicLFG.Locale["Dungeon group joined!"], ClassicLFG.Locale["Joined group for "] .. ClassicLFG.Locale[dungeonGroup.Dungeon.Name], 3)
end

function ClassicLFGToastManager:OnDungeonGroupLeft(dungeonGroup)
    self:ShowToast(ClassicLFG.Locale["Dungeon group left!"], ClassicLFG.Locale["Left group for "] .. ClassicLFG.Locale[dungeonGroup.Dungeon.Name], 3)
end

function ClassicLFGToastManager:OnApplicationDeclined(dungeonGroup)
    self:ShowToast(ClassicLFG.Locale["Application declined"], ClassicLFG.Locale["You have been declined by the group: \""] .. dungeonGroup.Title .. "\" (" .. ClassicLFG.Locale[dungeonGroup.Dungeon.Name] .. ")", 5)
end

function ClassicLFGToastManager:ShowToast(title, message, duration, object, callback)
    if (ClassicLFG.Store:GetState().Db.profile.Toast.Enabled == true) then
        if (#self.ToastQueue == 0) then
            self.Toast:Show(title, message, duration, object, callback)
        end
        table.insert(self.ToastQueue, { Title = title, Message = message, Duration = duration, Object = object, Callback = callback })
    end
end

function ClassicLFGToastManager:SetMovable(movable)
    self.Movable = movable
    self.Toast.Window:SetMovable(self.Movable)
    ClassicLFG.DB.profile.Toast.X = self.Toast.Window.Frame:GetLeft()
    ClassicLFG.DB.profile.Toast.Y = self.Toast.Window.Frame:GetTop() - GetScreenHeight()
    if (self.Movable == true and self.Toast.Window.Frame:IsVisible() == false) then
        self:ShowToast("MOVE ME", "", 3)
    end
end