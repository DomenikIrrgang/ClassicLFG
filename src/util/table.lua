function table.super(target, base, ...)
end

function table.inherit(target, base, ...)
	local superInstance = base(...)
	GlobalTestTable = setmetatable({}, target)
	return  setmetatable(GlobalTestTable, table.inheritAttributes(getmetatable(GlobalTestTable), getmetatable(superInstance)))
end

function table.inheritAttributes(target, base)
	for key, value in pairs(base) do
		if (target[key] == nil) then
			target[key] = value
		end
	end
	return target
end

function table.filter(target, fun)
	local out = {}

	for _, value in pairs(target) do
		if fun(value) then
			table.insert(out, value)
		end
	end
  
	return out
end
