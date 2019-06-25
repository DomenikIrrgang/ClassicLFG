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

function table.merge(target, source)
	for key, value in pairs(source) do
		if (istable(value) and istable(target[key])) then
			table.Merge(target[key], value)
		else
			target[key] = value
		end
	end
	return target
end