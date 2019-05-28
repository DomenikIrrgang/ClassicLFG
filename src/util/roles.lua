ClassicLFG.Role = {}

function ClassicLFG:DefineRole(name, icon, left, right, top, bottom)
    ClassicLFG.Role[name:upper()] = {
        Name = name,
        Icon = icon,
        Offset = {
            Left = left,
            Right = right,
            Top = top,
            Bottom = bottom
        }
    }
end

ClassicLFG:DefineRole("Healer", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0.31, 0.65, 0, 0.3)
ClassicLFG:DefineRole("Tank", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0, 0.31, 0.3, 0.65)
ClassicLFG:DefineRole("Dps", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0.31, 0.65, 0.3, 0.65)