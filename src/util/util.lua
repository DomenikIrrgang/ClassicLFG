function ClassicLFG:IteratorToArray(iterator)
    local array = {}
    for v in iterator do
      array[#array + 1] = v
    end
    return array
  end

function ClassicLFG:SetFrameBackgroundColor(frame, color)
    frame:SetBackdropColor(color.Red, color.Green, color.Blue, color.Alpha)
end

function ClassicLFG:RandomHash(length)
    if( length == nil or length <= 0 ) then length = 32; end;
    local holder = "";
    local hash_chars = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E",
                    "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                    "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
                    "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};

    for i = 1, length do
        local index = math.random(1, #hash_chars);
        holder = holder .. hash_chars[index];
    end

    return holder;
end


function ClassicLFG:DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[self:DeepCopy(orig_key)] = self:DeepCopy(orig_value)
        end
        setmetatable(copy, self:DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function ClassicLFG:RecursivePrint(object, maxDepths, layer)
    layer = layer or 1
    if (type(object) == "table" and (maxDepths == nil or layer <= maxDepths)) then
        for key in pairs(object) do
            if (type(object[key]) == "table") then
                ClassicLFG:DebugPrint("Printing Table " .. key .. object[key])
                ClassicLFG:RecursivePrint(object[key], maxDepths, layer + 1)
            else
                ClassicLFG:DebugPrint(key ..  object[key])
            end
        end
    end
end

function ClassicLFG:ArrayContainsValue(array, val)
    for index, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end


function ClassicLFG:IsIgnored(playerName)
    for i = 1, C_FriendList.GetNumIgnores() do
        if (C_FriendList.GetIgnoreName(i) == playerName) then
            return true
        end
    end
    return false
end

function ClassicLFG:WhoIs(playerName)
    C_FriendList.SetWhoToUi(true)
    C_FriendList.SendWho('n-\"' .. playerName .. '\"')
end

local frame = CreateFrame("frame")
frame:RegisterEvent("WHO_LIST_UPDATE")
frame:SetScript("OnEvent", function(_, event, ...)
    if (event == "WHO_LIST_UPDATE") then
        for i=1, C_FriendList.GetNumWhoResults() do
            local info = C_FriendList.GetWhoInfo(i)
            --print(info.fullName, info.fullGuildName, info.level, info.classStr, info.raceStr)
        end
    end
end)