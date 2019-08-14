ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.ToggleShowAllDungeons, nil, function(self, action, state)
    state.Db.profile.ShowAllDungeons = not state.Db.profile.ShowAllDungeons
    return ClassicLFG:MergeTables(state, { Db = state.Db })
end)