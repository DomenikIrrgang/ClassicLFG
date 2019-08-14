ClassicLFGStore = {}
ClassicLFGStore.__index = ClassicLFGStore

setmetatable(ClassicLFGStore, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ClassicLFGStore.new()
    local self = setmetatable({}, ClassicLFGStore)
    self.state = {}
    self.actionReducers = {}
    self.globalReducers = {}
    self.listeners = {}
	return self
end

function ClassicLFGStore:PublishAction(action, ...)
    ClassicLFG:DebugPrint("[Store] Published Action: " .. action)
    for _, reducer in pairs(self.globalReducers) do
        self.state = reducer.Callback(reducer.Object, action, self.state, ...)
    end
    if (self.actionReducers[action]) then
        for _, reducer in pairs(self.actionReducers[action]) do
            self.state = reducer.Callback(reducer.Object, action, self.state, ...)
        end
    end
    if (self.listeners[action]) then
        for _, listener in pairs(self.listeners[action]) do
            listener.Callback(listener.Object, action, self.state, ...)
        end
    end
end

function ClassicLFGStore:AddActionReducer(action, object, callback)
    if (self.actionReducers[action] == nil) then
        self.actionReducers[action] = {}
    end
    table.insert(self.actionReducers[action], ({ Object = object, Callback = callback }))
end

function ClassicLFGStore:SetState(state) 
    ClassicLFG:DebugPrint("[Store] New state set")
    self.state = state
    for _, listeners in pairs(self.listeners) do
        for _, listener in pairs(listeners) do
            listener.Callback(listener.Object, nil, self.state)
        end
    end
end

function ClassicLFGStore:AddGlobalReducer(action, object, callback)
    table.insert(self.globalReducers, ({ Object = object, Callback = callback }))
end

function ClassicLFGStore:AddListener(action, object, callback)
    if (self.listeners[action] == nil) then
        self.listeners[action] = {}
    end
    table.insert(self.listeners[action], ({ Object = object, Callback = callback }))
end

function ClassicLFGStore:GetState()
    return self.state
end

ClassicLFG.Store = ClassicLFGStore()