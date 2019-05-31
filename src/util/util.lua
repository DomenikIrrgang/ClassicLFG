function ClassicLFG:IteratorToArray(iterator)
    local array = {}
    for v in iterator do
      array[#array + 1] = v
    end
    return array
  end

  function string:SplitString(seperator)
    local fields = {}
    local pattern = string.format("([^%s]+)", seperator)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function ClassicLFG:SplitString(text, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    text:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end


function ClassicLFG:DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
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
                ClassicLFG:DebugPrint("Printing Table ", key, object[key])
                ClassicLFG:RecursivePrint(object[key], maxDepths, layer + 1)
            else
                ClassicLFG:DebugPrint(key, object[key])
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