ClassicLFG.Class = {}

function ClassicLFG:DefineClass(name, spec1, spec1Role, spec2, spec2Role, spec3, spec3Role)
    ClassicLFG.Class[name:upper()] = {
        Name = name,
        Specialization = {},
        Color = { GetClassColor(name:upper()) }
    }
    ClassicLFG.Class[name:upper()].Specialization[1] = {
        Name = spec1,
        Role = spec1Role,
    }
    ClassicLFG.Class[name:upper()].Specialization[2] = {
        Name = spec2,
        Role = spec2Role
    }
    ClassicLFG.Class[name:upper()].Specialization[3] = {
        Name = spec3,
        Role = spec3Role
    }
end

ClassicLFG:DefineClass("Warrior", "Arms", ClassicLFG.Role.DPS, "Furor", ClassicLFG.Role.DPS, "Protection", ClassicLFG.Role.TANK)
ClassicLFG:DefineClass("Paladin", "Holy", ClassicLFG.Role.HEALER, "Protection", ClassicLFG.Role.TANK, "Retribution", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Hunter", "Beastmastery", ClassicLFG.Role.DPS, "Marksmanship", ClassicLFG.Role.DPS, "Survival", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Rogue", "Assasination", ClassicLFG.Role.DPS, "Combat", ClassicLFG.Role.DPS, "Sublety", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Priest", "Discipline", ClassicLFG.Role.HEALER, "Holy", ClassicLFG.Role.HEALER, "Shadow", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Shaman", "Elemental", ClassicLFG.Role.DPS, "Enhancement", ClassicLFG.Role.DPS, "Restoration", ClassicLFG.Role.HEALER)
ClassicLFG:DefineClass("Warlock", "Affliction", ClassicLFG.Role.DPS, "Demonology", ClassicLFG.Role.DPS, "Destruction", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Druid", "Balance", ClassicLFG.Role.DPS, "Feral", ClassicLFG.Role.DPS, "Restoration", ClassicLFG.Role.HEALER)
ClassicLFG:DefineClass("Mage", "Arcane", ClassicLFG.Role.DPS, "Fire", ClassicLFG.Role.DPS, "Frost", ClassicLFG.Role.DPS)
ClassicLFG:DefineClass("Monk", "Windwalker", ClassicLFG.Role.DPS, "Brewmaster", ClassicLFG.Role.DPS, "Mistweaver", ClassicLFG.Role.DPS)