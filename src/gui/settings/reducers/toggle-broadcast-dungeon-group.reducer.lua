ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.ToggleBroadcastDungeonGroup, nil, function(self, action, state)
    state.Db.profile.BroadcastDungeonGroup = not state.Db.profile.BroadcastDungeonGroup
    return ClassicLFG:MergeTables(state, { Db = state.Db })
end)