ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.QueueDungeonGroup, nil, function(self, action, state, dungeonGroup)
    return ClassicLFG:MergeTables(state, { DungeonGroupQueued = true, DungeonGroup = dungeonGroup })
end)