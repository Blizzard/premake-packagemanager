---
-- Package management module
-- Package API to wrap around 'projects'.
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

-- Package API ----------------------------------------------------------------

local packageAPI = {}

function packageAPI:loadvariants(filter)
end

function packageAPI:loadvariant(variant)
end

-- Importing API --------------------------------------------------------------

function m.createProjectPackage(name, version)
	local result = m.createPackageBase(name, version)

	-- override base method.
	result.auto_includes = function(cfg)
		return {}
	end

	-- override base method.
	result.auto_defines = function(cfg)
		return {}
	end

	-- override base method.
	result.auto_links = function(cfg)
		return { name }
	end

	-- override base method.
	result.auto_libdirs = function(cfg)
		return {}
	end

	-- override base method.
	result.auto_bindirs = function(cfg)
		return { cfg.targetdir }
	end

	-- override base method.
	function result:initialize()
	end

	return setmetatable(result, {
		__metatable = false,

		__index    = packageAPI,

		__newindex = function(tbl, key, value)
			error("Attempt to modify readonly table.")
		end,

		__tostring = function()
			return "Project Package"
		end,
	})
end
