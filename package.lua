---
-- Package management module
-- Legacy "Package" API.
-- Copyright (c) 2014-2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

package = package or {}

---
-- get a previously imported package by name.
---
	function package.get(name)
		local result = p.packagemanager.getPackage(name)
		if not result then
			error("Package was not imported; use 'import { ['" .. name .. "'] = 'version' }'.")
		end
		return result
	end

---
-- See if a previously imported package was imported.
---
	function package.isimported(name)
		return p.packagemanager.getPackage(name) ~= nil
	end


---
-- Import a set of packages.
---
	function import(tbl)
		if package.current then
			error('Packages cannot import other package, only the top-level workspace can do that')
		end

		return p.packagemanager.import(tbl)
	end


---
-- Old 'cache' interface.
---
local m = {}

function m.use_env_var_location()
	local folder = os.getenv('PACKAGE_CACHE_PATH')
	if folder and os.isdir(folder) then
		p.packagemanager.cache_location = folder
		return true
	end
	return false
end

function m.get_folder()
	p.warnOnce("cache_get_folder", "'cache.get_folder()' is deprecated, use 'premake.packagemanager.getCacheLocation()' instead.")
	return p.packagemanager.getCacheLocation()
end

cache = setmetatable(m, {
	__metatable = false,

	__index = function(tbl, key)
		return rawget(tbl, key)
	end,

	__newindex = function(tbl, key, value)
		if (key == "package_hostname") then
			p.warn("'cache.package_hostname' is deprecated, use 'premake.packagemanager.servers = {}' instead.")
			assert(type(value) == "string", "package_hostname must be a string.")
			p.packagemanager.servers = { value }
			rawset(tbl, key, value)

		elseif (key == "location_override") then
			p.warn("'cache.location_override' is deprecated, use 'premake.packagemanager.cache_location' instead.")
			assert(value == nil or type(value) == "string", "location_override must be a string or nil.")
			p.packagemanager.cache_location = value
			rawset(tbl, key, value)

		elseif (key == "servers") then
			p.warn("'cache.servers' is deprecated, use 'premake.packagemanager.servers' instead.")
			assert(type(value) == "table", "servers must be a table.")
			p.packagemanager.servers = value
			rawset(tbl, key, value)

		elseif (key == "folders") then
			p.warn("'cache.folders' is deprecated, use 'premake.packagemanager.folders' instead.")
			assert(type(value) == "table", "folders must be a table.")
			p.packagemanager.folders = value
			rawset(tbl, key, value)

		else
			error("Access to 'cache' deprecated: " .. key)
		end
	end,
})
