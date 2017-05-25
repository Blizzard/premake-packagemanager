---
-- Package management module
-- Deprecated API.
-- Copyright (c) 2014-2016 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

bnet = bnet or {}

---
-- Deprecate old cfg.bnet.variant context.
---
	function bnet.new()
		return {
			variant = function (cfg)
				p.warnOnce("cfg.bnet.variant", "'cfg.bnet.variant' is deprecated, use 'premake.packagemanager.buildVariantFromConfig(cfg)' instead.")
				return p.packagemanager.buildVariantFromConfig(cfg)
			end
		}
	end

	p.override(p.context, "new", function (base, cfgset, environ)
		local ctx = base(cfgset, environ)
		ctx.bnet = bnet.new()
		return ctx
	end)

---
-- Setup some defaults we use here and there.
---
	bnet.build_custom_variant = nil
	bnet.build_dir    = path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to or 'build')
	bnet.projects_dir = path.join(bnet.build_dir, 'projects')
	bnet.bin_dir      = path.join(_MAIN_SCRIPT_DIR, "bin/%{cfg.buildcfg}")
	bnet.obj_dir      = path.join(bnet.build_dir, "%{premake.packagemanager.buildVariantFromConfig(cfg)}/obj")
	bnet.lib_dir      = path.join(bnet.build_dir, "%{premake.packagemanager.buildVariantFromConfig(cfg)}/lib")

	verbosef("bnet.build_dir   : %s", bnet.build_dir)
	verbosef("bnet.projects_dir: %s", bnet.projects_dir)
	verbosef("bnet.obj_dir     : %s", bnet.obj_dir)
	verbosef("bnet.lib_dir     : %s", bnet.lib_dir)
	verbosef("bnet.bin_dir     : %s", bnet.bin_dir)

---
-- Deprecated 'global' functions.
---

	function _build_os(ctx)
		p.warnOnce("_build_os", "'_build_os(cfg)' is deprecated, use 'premake.packagemanager.translateSystem(cfg.system)'.")

		local var = ctx.system or premake.action.current().os or os.get()
		if var == 'windows' then
			var = "win32"
		elseif var == 'macosx' then
			var = "darwin"
		end
		return var
	end


	function _build_compiler(ctx)
		p.warnOnce("_build_compiler", "'_build_compiler(cfg)' is deprecated, use 'premake.packagemanager.translateAction(_ACTION)'.")

		local var = _ACTION
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
		elseif os.get() == 'linux' then
			return "gcc44"
		elseif os.get() == 'macosx' then
			return "clang"
		end
		return var
	end


	function _build_arch(ctx)
		p.warnOnce("_build_arch", "'_build_arch(cfg)' is deprecated, use 'premake.packagemanager.translateArchitecture(cfg.architecture)'.")

		local var = ctx.architecture
		if ctx.architecture == 'x86' then
			var = "i386"
		end
		if ctx.system == 'orbis' or ctx.system == 'durango' then
			return nil
		end
		return var
	end


	function _build_config(ctx)
		p.warnOnce("_build_config", "'_build_variant' is deprecated.")

		local var = ctx.buildcfg
		if var == "Debug" then
			var = "debug"
		elseif var == "Release" then
			var = "release"
		elseif var == "Public" then
			var = "public"
		end
		return var
	end


	function _build_variant(ctx, dontIncludeArch, dontIncludCompiler, dontIncludeConfig)
		p.warnOnce("_build_variant", "'_build_variant(cfg)' is deprecated, use 'premake.packagemanager.buildVariantFromConfig(cfg)'.")

		local var = _build_os(ctx)
		local compiler = _build_compiler(ctx)
		local arch = _build_arch(ctx)
		local config = _build_config(ctx)

		if not dontIncludeArch and arch and #arch > 0 then
			var = var .. "-" .. arch
		end
		if not dontIncludCompiler and compiler and #compiler > 0 then
			var = var .. "-" .. compiler
		end
		if not dontIncludeConfig and config and #config > 0 then
			var = var .. "-" .. config
		end
		return var
	end


---
-- Deprecated 'cache' interface.
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
