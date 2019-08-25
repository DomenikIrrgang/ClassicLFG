ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.ToggleShareTalents, nil, function(self, action, state)
    state.Db.profile.ShareTalents = not state.Db.profile.ShareTalents
    return ClassicLFG:MergeTables(state, { Db = state.Db })
end)