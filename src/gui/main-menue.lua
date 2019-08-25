---------------------------------
-- Window
---------------------------------

ClassicLFG.QueueWindow = ClassicLFGWindow("ClassicLFGQueueWindow", UIParent, 400, 600)
ClassicLFG.QueueWindow:SetTitle("ClassicLFG");
ClassicLFG.QueueWindow.Padding = 6
ClassicLFG.QueueWindow.Frame.CloseButton.OnClick = function()
    ClassicLFG.Store:PublishAction(ClassicLFG.Actions.ToggleMainWindow)
end
table.insert(UISpecialFrames, ClassicLFG.QueueWindow.Frame:GetName())

---------------------------------
-- Window - Tabs
---------------------------------

ClassicLFG.QueueWindow.SearchGroup, ClassicLFG.QueueWindow.CreateGroup, ClassicLFG.QueueWindow.Settings =  ClassicLFG.QueueWindow:CreateTabs(3, ClassicLFG.Locale["Search Group"], ClassicLFG.Locale["Create Group"], ClassicLFG.Locale["Settings"])

---------------------------------
-- State
---------------------------------

ClassicLFG.Store:AddActionReducer(ClassicLFG.Actions.ToggleMainWindow, ClassicLFG.QueueDungeonGroupWindow, function(self, action, state)
    return ClassicLFG:MergeTables(state, { MainWindowOpen = not ClassicLFG.QueueWindow:IsShown() })
end)

ClassicLFG.Store:AddListener(ClassicLFG.Actions.ToggleMainWindow, ClassicLFG.QueueDungeonGroupWindow, function(self, action, state)
    if (ClassicLFG.Initialized == true) then
        if (state.MainWindowOpen == true) then
            ClassicLFG.QueueWindow:Show()
        else
            ClassicLFG.QueueWindow:Hide()
        end
    end
end)