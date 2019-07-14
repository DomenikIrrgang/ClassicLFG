ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.DequeueDungeonGroup, nil, function(self, action, state)
    return ClassicLFG:MergeTables(state, { DungeonGroupQueued = false, DungeonGroup = nil })
end)