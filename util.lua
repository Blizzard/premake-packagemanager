---
-- Package management module
-- General utilities.
-- Copyright (c) 2014-2016 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager


if not _OPTIONS['compiler'] then
	if os.target() == 'linux' then
		_OPTIONS['compiler'] = 'gcc44'
	elseif os.target() == 'windows' then
		_OPTIONS['compiler'] = 'vc2010'
	else
		_OPTIONS['compiler'] = 'clang'
	end
end


function m.createPackageLocation(...)
	local location = path.join(...)
	location = path.normalize(location)
	location = location:gsub('%s+', '_')
	location = location:gsub('%(', '_')
	location = location:gsub('%)', '_')
	return location
end


function m.checkType(name, value, t)
	if value == nil then
		return true
	end
	if type(t) == "table" then
		local result = false
		for _, v in ipairs(t) do
			result = result or (type(value) ~= v)
		end

		if not result then
			p.error("'%s' field must be a '%s', got '%s'.", name, table.concat(t, " or "), type(value))
		end
	elseif type(value) ~= t then
		p.error("'%s' field must be a '%s', got '%s'.", name, t, type(value))
	end
end


function m.isSystem(expected, target)
	target =  os.getSystemTags(target or os.target())
	if type(target) == "table" then
		return table.contains(target, expected)
	else
		return target == expected
	end
end


function _get_lib_files(dir, system)
	if type(dir) == 'string' then
		if m.isSystem('windows', system) then
			return os.matchfiles(path.join(dir, '*.lib'))
		elseif m.isSystem('macosx', system) then
			return table.join(os.matchfiles(path.join(dir, 'lib*.a')), os.matchfiles(path.join(dir, 'lib*.dylib*')))
		else
			return table.join(os.matchfiles(path.join(dir, 'lib*.a')), os.matchfiles(path.join(dir, 'lib*.so*')))
		end
	elseif type(dir) == 'table' then
		local result = {}
		for _, val in ipairs(dir) do
			table.insertflat(result, _get_lib_files(val, system))
		end
		return result
	else
		return {}
	end
end


--
-- TableOrString data kind.
--
	local function mergeTableOrString(field, current, value, processor)
		result = {}
		for k, v in pairs(current) do
			if type(v) == 'string' then
				table.insert(result, v)
			elseif type(v) == 'table' then
				result[k] = v
			end
		end

		for k, v in pairs(value) do
			if type(v) == 'string' then
				table.insert(result, v)
			elseif type(v) == 'table' then
				result[k] = v
			end
		end

		return result
	end

	local function storeTableOrString(field, current, value, processor)
		if type(value) ~= "table" then
			return { value }
		end
		if current then
			return mergeTableOrString(field, current, value, processor)
		else
			return value
		end
	end

	p.field.kind("tableorstring", {
		store = storeTableOrString,
		merge = mergeTableOrString,
		compare = function(field, a, b, processor)
			if a == nil or b == nil or #a ~= #b then
				return false
			end
			for k, v in pairs(a) do
				if not processor(field, a[k], b[k]) then
					return false
				end
			end
			return true
		end
	})
