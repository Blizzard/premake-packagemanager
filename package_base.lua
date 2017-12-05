---
-- Package management module
-- Package Base 'class'.
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager


function m.createPackageBase(name, version)
	local pkg = {
		name         = name,
		version      = version,
		projects     = {},
		variants     = {},
		optionValues = {}
	}

	local _cache = {}

	local function getCache(name, cfg)
		local c = _cache[name]
		if not c then
			return nil
		end
		return c[cfg.name]
	end

	local function setCache(name, cfg, value)
		_cache[name] = _cache[name] or {}
		_cache[name][cfg.name] = value
	end

	local function getProperties(name, cfg, join)
		local result = getCache(name, cfg)
		if result then
			return result
		end

		local filter = {
			action         = _ACTION,
			system         = os.getSystemTags(cfg.system or os.target()),
			architecture   = cfg.architecture,
			toolset        = cfg.toolset,
			configurations = cfg.buildcfg,
			tags           = cfg.tags,
			cfg            = cfg
		}

		result = {}
		local cacheresult = true

		-- get variants that match this filter.
		local variants = pkg:loadvariants(filter)

		-- initialize variants that have just been loaded.
		pkg:initialize()

		-- combine properties.
		for _, v in ipairs(variants) do
			local items = v[name]

			if type(items) == "function" then
				items = items(cfg)
				cacheresult = false
			end
			if items then
				for _, value in ipairs(items) do
					value = p.detoken.expand(value, cfg.environ, {pathVars=true}, v.location)
					if join then
						table.insert(result, path.join(v.location, value))
					else
						table.insert(result, value)
					end
				end
			end
		end

		if cacheresult then
			setCache(name, cfg, result)
		end

		return result
	end

	-- setup auto-resolve for includes.
	function pkg.auto_includes(cfg)
		return getProperties('includes', cfg, true)
	end

	-- setup auto-resolve for defines.
	function pkg.auto_defines(cfg)
		return getProperties('defines', cfg, false)
	end

	-- setup auto-resolve for dependson.
	function pkg.auto_dependson(cfg)
		return getProperties('dependson', cfg, false)
	end

	-- setup auto-resolve for links.
	function pkg.auto_links(cfg)
		return getProperties('links', cfg, false)
	end

	-- setup auto-resolve for libdirs.
	function pkg.auto_libdirs(cfg)
		return getProperties('libdirs', cfg, true)
	end

	-- setup auto-resolve for bindirs.
	function pkg.auto_bindirs(cfg)
		return getProperties('bindirs', cfg, true)
	end

	-- setup auto-resolve for includedependencies.
	function pkg.auto_includedependencies(cfg)
		return getProperties('includedependencies', cfg, false)
	end

	-- setup auto-resolve for linkdependencies.
	function pkg.auto_linkdependencies(cfg)
		return getProperties('linkdependencies', cfg, false)
	end

	-- setup auto-resolve for includepath.
	function pkg.auto_includepath(cfg)
		local r = pkg.auto_includes(cfg)
		if (r and #r > 0) then
			return r[1]
		end
		return nil
	end

	-- setup auto-resolve for binpath.
	function pkg.auto_binpath(cfg)
		local r = pkg.auto_bindirs(cfg)
		if (r and #r > 0) then
			return r[1]
		end
		return nil
	end

	-- Initializer method.
	function pkg:initialize()
		-- Remember the current _SCRIPT and working directory so we can restore them.
		local cwd = os.getcwd()
		local script = _SCRIPT
		local scriptDir = _SCRIPT_DIR

		-- Store current scope.
		local scope = p.api.scope.current

		-- add the criteria prefixes temporarily.
		if self.options then
			for option, kind in pairs(self.options) do
				if criteria._validPrefixes[option] then
					p.error('Cannot use a predefined filter prefix: %s', option)
				end
				criteria._validPrefixes[option] = true
			end
		end

		-- go through each variant that is loaded, and execute the initializer.
		local errors = {}
		for name, variant in pairs(self.variants) do
			if variant.loaded and variant.initializer then
				-- Set the new _SCRIPT and working directory
				_SCRIPT     = variant.script
				_SCRIPT_DIR = variant.location
				os.chdir(variant.location)

				-- store current package context.
				local previous_package = package.current
				package.current = variant

				-- execute the callback, capture errors until the end, when scope is restored.
				verbosef('initialize(%s, %s, %s)', self.name, name, operation or 'nil')
				local ok, err = pcall(variant.initializer, 'project')
				if not ok then
					table.insert(errors, err)
				end

				-- and clear it, so we don't do it again in the future.
				variant.initializer = nil

				-- restore package context.
				package.current = previous_package
			end
		end

		-- restore the criteria prefixes.
		if self.options then
			for option, kind in pairs(self.options) do
				criteria._validPrefixes[option] = nil
			end
		end

		-- restore current scope.
		p.api.scope.current = scope

		-- Finally, restore the previous _SCRIPT variable and working directory
		_SCRIPT = script
		_SCRIPT_DIR = scriptDir
		os.chdir(cwd)

		-- throw the error if there was any.
		if #errors > 0 then
			p.error(table.concat(errors, "\n"))
		end
	end

	function pkg:includeTests()
		-- Remember the current _SCRIPT and working directory so we can restore them.
		local cwd = os.getcwd()
		local script = _SCRIPT
		local scriptDir = _SCRIPT_DIR

		-- Store current scope.
		local scope = p.api.scope.current

		-- go through each variant that is loaded, and execute the initializer.
		for name, variant in pairs(self.variants) do
			if variant.loaded and variant.testscript ~= nil then
				-- Set the new _SCRIPT and working directory
				_SCRIPT     = variant.testscript
				_SCRIPT_DIR = variant.location
				os.chdir(variant.location)

				-- store current package context.
				local previous_package = package.current
				package.current = variant

				-- execute the testscript
				dofile(variant.testscript)

				-- restore package context.
				package.current = previous_package
			end
		end

		-- restore current scope.
		p.api.scope.current = scope

		-- Finally, restore the previous _SCRIPT variable and working directory
		_SCRIPT = script
		_SCRIPT_DIR = scriptDir
		os.chdir(cwd)
	end

	return pkg
end
