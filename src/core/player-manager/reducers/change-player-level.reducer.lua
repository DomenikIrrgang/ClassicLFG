ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.ChangePlayerLevel, nil, function(self, action, state, newLevel)
    local player = state.Player
    player.Level = newLevel
    return ClassicLFG:MergeTables(state, { Player = player })
end)