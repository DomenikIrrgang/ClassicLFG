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

ClassicLFG:DefineRole("Healer", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0.31, 0.63, 0, 0.3)
ClassicLFG:DefineRole("Tank", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0, 0.31, 0.32, 0.63)
ClassicLFG:DefineRole("Dps", "Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", 0.31, 0.63, 0.32, 0.63)
ClassicLFG:DefineRole("Unknown", "Interface\\Icons\\Inv_misc_questionmark", 0.1, 0.9, 0.1, 0.9)