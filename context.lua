---
-- Package management module
-- Legacy "Package" API.
-- Copyright (c) 2014-2016 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

bnet = bnet or {}

	local function __concat(...)
		return table.concat(table.filterempty({...}), '-'):lower()
	end

	function bnet.translateSystem(system)
		assert(type(system) == "string")
		if system == "windows" then
			return "win32"
		elseif system == 'macosx' then
			return "darwin"
		end
		return system
	end

	function bnet.translateAction(action)
		local var = action or _ACTION

		if var == "vs2010" then
			return "vc100"
		elseif var == "vs2012" then
			return "vc110"
		elseif var == "vs2013" then
			return "vc120"
		elseif var == "vs2015" then
			return "vc140"
		elseif var == "vs2017" then
			return "vc141"
		end

		if _OPTIONS['compiler'] then
			return _OPTIONS['compiler']
		elseif os.istarget('linux') then
			return "gcc44"
		elseif os.istarget('macosx') then
			return "clang"
		end

		return var
	end

	function bnet.translateArchitecture(arch)
		if arch == 'x86' then
			arch = "i386"
		end
		return arch
	end

	function bnet.translateConfig(config)
		return config
	end


---
-- Create a variant from the current configuration
---
	function bnet.buildVariantFromConfig(cfg)
		local os         = bnet.translateSystem(cfg.system or os.target())
		local action     = bnet.translateAction(_ACTION)
		local arch       = bnet.translateArchitecture(cfg.architecture)
		local config     = bnet.translateConfig(cfg.buildcfg)
		return __concat(os, arch, action, config):lower()
	end


---
-- Deprecate old cfg.bnet.variant context.
---
	function bnet.new()
		return {
			variant = function (cfg)
				p.warnOnce("cfg.bnet.variant", "'cfg.bnet.variant' is deprecated, use 'bnet.buildVariantFromConfig(cfg)' instead.")
				return bnet.buildVariantFromConfig(cfg)
			end
		}
	end

	p.override(p.context, "new", function (base, cfgset, environ)
		local ctx = base(cfgset, environ)
		ctx.bnet = bnet.new()
		return ctx
	end)


---
-- Create a table of variants.
---
	function bnet.buildVariantsFromFilter(filter)
		local action   = bnet.translateAction(filter.action)
		local arch     = bnet.translateArchitecture(filter.architecture)
		local config   = bnet.translateConfig(filter.configuration)

		local result = {}
		for _, sys in ipairs(filter.system) do
			local os = bnet.translateSystem(sys)
			table.insert(result, __concat(os, arch, action, config)) -- Check for [os]-[arch]-[action]-[config]
			table.insert(result, __concat(os, arch, action))         -- Check for [os]-[arch]-[action]
			table.insert(result, __concat(os, arch, config))         -- Check for [os]-[arch]-[config]
			table.insert(result, __concat(os, arch))                 -- Check for [os]-[arch]
			table.insert(result, __concat(os, action, config))       -- Check for [os]-[action]-[config]
			table.insert(result, __concat(os, action))               -- Check for [os]-[action]
			table.insert(result, __concat(os, config))               -- Check for [os]-[config]
			table.insert(result, os)                                 -- Check for [os]
		end

		return table.unique(result)
	end


---
-- Local helper to find tags out of a map, and remove them from the list.
---
	local function __find(map, tags)
		local function findOne()
			for i, tag in ipairs(tags) do
				local m = map[tag]
				if m then
					table.remove(tags, i)
					return m
				end
			end
		end

		local r, final
		repeat
			r = findOne()
			if r then
				final = r
			end
		until not r

		return final
	end


---
-- Find a system tag in a set of tags.
---
	function bnet.findSystem(tags)
		local map = {
			["android"] = "android",
			["posix"] = "posix",
			["linux"] = "linux",
			["centos6"] = "centos6",
			["centos7"] = "centos7",
			["osx"] = "macosx",
			["mac"] = "macosx",
			["macosx"] = "macosx",
			["darwin"] = "macosx",
			["windows"] = "windows",
			["win32"] = "windows",
			["win64"] = "windows",
			["win"] = "windows",
			["durango"] = "durango",
			["xboxone"] = "durango",
			["xbox360"] = "xbox360",
			["ios"] = "ios",
			["orbis"] = "orbis",
			["ps4"] = "orbis",
		}
		return __find(map, tags)
	end


---
-- Find a toolset tag in a set of tags.
---
	function bnet.findToolset(tags)
		local map = {
			["gcc"]      = "gcc",
			["gcc41"]    = "gcc41",
			["gcc42"]    = "gcc42",
			["gcc44"]    = "gcc44",
			["gcc4.4"]   = "gcc44",
			["gcc47"]    = "gcc47",
			["gcc48"]    = "gcc48",
			["gcc4.8"]   = "gcc48",
			["clang"]    = "clang",
			["vc100"]    = "msc-v100",
			["vc110"]    = "msc-v110",
			["vc120"]    = "msc-v120",
			["vc140"]    = "msc-v140",
			["vs2015"]   = "msc-v140",
			["vc141"]    = "msc-v141",
			["vc110_xp"] = "msc-vc110_xp",
			["vc140_xp"] = "msc-vc140_xp",
		}
		return __find(map, tags)
	end


---
-- Find an architecture tag in a set of tags.
---
	function bnet.findArchitecture(tags)
		local map = {
			["x86"]    = "x86",
			["i386"]   = "x86",
			["x86_64"] = "x86_64",
			["x64"]    = "x86_64",
			["mips"]   = "mips",
			["arm"]    = "ARM",
			["arm64"]  = "ARM64",
			["armv6"]  = "ARMv6",
			["armv7"]  = "ARMv7",
			["armv7s"] = "ARMv7s",
		}
		return __find(map, tags)
	end

---
-- Find an configuration tag in a set of tags.
---
	function bnet.findConfig(tags)
		local map = {
			["debug"]       = "debug",
			["debugopt"]    = "debugopt",
			["release"]     = "release",
			["public"]      = "public",
			["profile"]     = "profile",
			["development"] = "development",
			["production"]  = "production",
		}
		return __find(map, tags)
	end


---
-- Create a filter table from a variant name.
---
	function bnet.filterFromVariant(name)
		if (name == "noarch") or (name == "universal") then
			return {}
		end

		local result = {}
		local parts = string.explode(name, "-", true)

		-- remove noarch, universal and empty tags.
		local ignore = {
			["noarch"]    = "noarch",
			["universal"] = "universal",
			[""]          = "empty",
		}
		__find(ignore, parts)

		-- find system, toolset, architecture and config.
		result.system         = bnet.findSystem(parts)
		result.toolset        = bnet.findToolset(parts)
		result.architecture   = bnet.findArchitecture(parts)
		result.configurations = bnet.findConfig(parts)

		-- the remaining tags are uses as 'tags'
		if #parts > 0 then
			result.tags    = parts
		end

		return m.validateFilter(result)
	end


---
-- Setup some defaults we use here and there.
---
	bnet.build_custom_variant = nil
	bnet.build_dir    = path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to or 'build')
	bnet.projects_dir = path.join(bnet.build_dir, 'projects')
	bnet.bin_dir      = path.join(_MAIN_SCRIPT_DIR, "bin/%{cfg.buildcfg}")
	bnet.obj_dir      = path.join(bnet.build_dir, "%{bnet.buildVariantFromConfig(cfg)}/obj")
	bnet.lib_dir      = path.join(bnet.build_dir, "%{bnet.buildVariantFromConfig(cfg)}/lib")

	verbosef("bnet.build_dir   : %s", bnet.build_dir)
	verbosef("bnet.projects_dir: %s", bnet.projects_dir)
	verbosef("bnet.obj_dir     : %s", bnet.obj_dir)
	verbosef("bnet.lib_dir     : %s", bnet.lib_dir)
	verbosef("bnet.bin_dir     : %s", bnet.bin_dir)

