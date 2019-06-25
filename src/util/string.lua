function string:SplitString(seperator)
    local fields = {}
    local pattern = string.format("([^%s]+)", seperator)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function ClassicLFG:StringContainsTableValue(text, values)
    for key in pairs(values) do
        if (string.match(text, values[key]:lower()) ~= nil) then
            return values[key]
        end
    end
    return nil
end