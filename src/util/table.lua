function table.inherit(target, base)
	for key, value in pairs(base) do
		if (target[key] == nil) then target[key] = value end
	end
	target["super"] = base
	return target
end

function table.Merge(target, source)
	for key, value in pairs(source) do
		if (istable(value) and istable(target[key])) then
			table.Merge(target[key], value)
		else
			target[key] = value
		end
	end
	return target
end