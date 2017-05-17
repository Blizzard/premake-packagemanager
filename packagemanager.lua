---
-- Package management module
-- Copyright (c) 2014-2017 Blizzard Entertainment
---

local p = premake

p.modules.packagemanager = {}
p.modules.packagemanager._VERSION = p._VERSION

local m = p.modules.packagemanager

-- include the rest of the module ---------------------------------------------

include 'util.lua'
include 'context.lua'
include 'httpext.lua'
include 'variant.lua'
include 'package.lua'
include 'package_base.lua'
include 'package_project.lua'
include 'packageresolver.lua'

--[ Global package manager ] --------------------------------------------------

p.packagemanager = {
	cache_location    = nil,
	folders           = {},
	servers           = {
		'http://***REMOVED***',
		'http://***REMOVED***'
	},
	systems = {
		dofile("package_v2.lua"),
		dofile("package_v1.lua"),
	},
}

local pm = p.packagemanager

local __loaded = {}

--[ private functions ]----------------------------------------------------

---
-- Get the alias information from the package server.
---
	local function __getAliasTable(name)
		-- if we don't want server queries, just return the local results.
		if _OPTIONS['no-http'] or (pm.servers == nil) then
			return name:lower(), {}
		end

		-- query servers for alias information.
		local link = '/aliases?name=' .. http.escapeUrlParam(name)
		local tbl = http.getJson(pm.servers, link)
		if tbl ~= nil then
			local aliases = {}
			for _, alias in ipairs(tbl.Aliases or {}) do
				table.insert(aliases, alias:lower())
			end
			return tbl.RealName:lower(), aliases
		end

		return name:lower(), {}
	end


---
-- Import a single package...
---
	local function __importPackage(name, version)
		-- create the --use-<name> option.
		local optionname = 'use-' .. name
		p.option.add({
			trigger     = optionname,
			value       = '<path>',
			default     = version,
			description = 'Path or Version for ' .. name .. ' package.',
			category    = 'Package Manager'
		})

		-- option overrides version from table.
		version = _OPTIONS[optionname] or version

		for _, pkgsys in ipairs(pm.systems) do
			local pkg = pkgsys(name, version)
			if pkg ~= nil then
				return pkg
			end
		end

		error(string.format("No package '%s' version '%s' was found.", name, version))
	end



--[ public functions ]----------------------------------------------------

---
-- Get the location of where the package manager should download packages.
---
	function pm.getCacheLocation()
		local folder = os.getenv('PACKAGE_CACHE_PATH')
		if folder then
			return folder
		else
			if pm.cache_location then
				return pm.cache_location
			end
			return path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to or 'build', 'package_cache')
		end
	end


---
-- Import packages.
---
	function pm.import(tbl)
		if (not tbl) or (type(tbl) ~= "table") then
			error("Invalid argument to import.")
		end

		-- we always need to have a workspace.
		local scope = p.api.scope.current
		local wks   = p.api.scope.workspace
		if (wks == nil) or (wks ~= scope) then
			error("Workspace must be the current scope.")
		end

		-- import packages.
		local init_table = {}
		for name, version in pairs(tbl) do
			local realname, aliases = __getAliasTable(name)

			if not wks.package_cache[realname] then
				local pkg = __importPackage(realname, version)
				table.insert(init_table, pkg)

				wks.package_cache[realname] = pkg
				for _, alias in ipairs(aliases) do
					verbosef("ALIAS: '%s' aliased to '%s'.", realname, alias)
					wks.package_cache[alias] = pkg
				end
			else
				p.warn("Package '%s' already imported.", realname)
			end
		end

		-- setup a filter with the action and system 'filters', we don't know the rest yet.
		local filter = {
			action = _ACTION,
			system = os.getSystemTags(os.target()),
		}

		-- load all variants that match the filter.
		for _, pkg in ipairs(init_table) do
			pkg:loadvariants(filter)
		end

		-- initialize.
		for _, pkg in ipairs(init_table) do
			if not __loaded[pkg.name] then
				__loaded[pkg.name] = true
			else
				p.api._isIncludingExternal = true
			end

			-- and initialize all loaded variants.
			pkg:initialize()

			p.api._isIncludingExternal = nil
		end

		-- restore current scope.
		p.api.scope.current = scope
	end


---
-- Get a package by name from the current workspace.
---
	function pm.getPackage(name)
		local wks = p.api.scope.workspace
		if wks == nil then
			error("No workspace in scope.", 3)
		end
		return wks.package_cache[name:lower()]
	end


---
-- Resets the state of the package manager to it's default state.
---
	function pm.reset()
		__loaded = {}
		pm.cache_location    = nil
		pm.folders           = {}
		pm.servers           = {
			'http://***REMOVED***',
			'http://***REMOVED***'
		}
	end


---
-- override 'workspace' so that we can initialize a package cache.
---
	p.override(p.workspace, 'new', function(base, name)
		local wks = base(name)
		wks.package_cache = wks.package_cache or {}
		return wks
	end)


---
-- override 'project' so that when a package defines a new project we initialize it with some default values.
---
	p.override(p.project, 'new', function(base, name, parent)
		local prj = base(name, parent)

		if not prj.package then
			if package.current then
				-- set package on project.
				prj.package = package.current.package

				-- set some default package values.
				prj.blocks[1].targetdir = bnet.lib_dir
				prj.blocks[1].objdir    = path.join(bnet.obj_dir, name)
				prj.blocks[1].location  = path.join(bnet.projects_dir, 'packages')

			elseif parent ~= nil then
				local p = parent.package_cache[name:lower()]
				if p then
					error("Package '" .. name .. "' already exists in the solution.")
				end

				-- set package on project.
				prj.package = m.createProjectPackage(name)
				parent.package_cache[name:lower()] = prj.package
			end

			-- add project to package.
			table.insert(prj.package.projects, prj)
		end

		return prj
	end)


---
-- Set metatable on global package manager, locking it down.
---
	setmetatable(pm, {
		__metatable = false,

		__index = function(tbl, key)
			return rawget(tbl, key)
		end,

		__newindex = function(tbl, key, value)
			if (key == "cache_location") then
				assert(value == nil or type(value) == "string", "cache_location must be a string or nil.")
				rawset(tbl, key, value)
			elseif (key == "folders") then
				assert(type(value) == "table", "folders must be a table.")
				rawset(tbl, key, value)
			elseif (key == "servers") then
				assert(type(value) == "table", "servers must be a table.")
				rawset(tbl, key, value)
			else
				error("Attempt to modify packagemanager field: " .. key)
			end
		end,

		__tostring = function()
			return "Package Manager"
		end,
	})


-- return the module pointer.
return p.modules.packagemanager
