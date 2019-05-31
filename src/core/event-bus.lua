ClassicLFGEventBus = {}
ClassicLFGEventBus.__index = ClassicLFGEventBus

setmetatable(ClassicLFGEventBus, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGEventBus.new(name, guild, level, class, talents)
    local self = setmetatable({}, ClassicLFGEventBus)
    self.Listeners = {}
    return self
end

function ClassicLFGEventBus:RegisterCallback(event, object, callback)
    if (self.Listeners[event] == nil) then
        self.Listeners[event] = {}
    end
    table.insert(self.Listeners[event], { Object = object, Callback = callback })
end

function ClassicLFGEventBus:PublishEvent(event, ...)
    ClassicLFG:DebugPrint("Event published: " .. event)
    if (self.Listeners[event] ~= nil) then
        for key in pairs(self.Listeners[event]) do
            self.Listeners[event][key].Callback(self.Listeners[event][key].Object, ...)
        end
    end
end

ClassicLFG.EventBus = ClassicLFGEventBus()