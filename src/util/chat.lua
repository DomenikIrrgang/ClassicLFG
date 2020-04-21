function ClassicLFG:Print(message)
    print("|cFF7777FFClassicLFG:|cFFFFFFFF", message)
end

function ClassicLFG:DebugPrint(message)
    if (self.Config.Debug == true) then
        print("|cFF7777FFClassicLFG Debug:|cFFFFFFFF", message)
    end
end

function ClassicLFG:NetworkDebugPrint(message)
    if (self.Config.Network.Debug == true) then
        self:DebugPrint(message)
    end
end
