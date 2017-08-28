---
-- Package management module
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake

---
-- Load the entire module.
---
	require("packagemanager")

---
-- Command line options.
---
	newoption {
		trigger = "compiler",
		value	 = "gcc44",
		description = "Select which compiler to use for package system"
	}

	newoption {
		trigger = 'no-http',
		description = 'Disable http queries to package server.'
	}

	newoption
	{
		trigger = 'to',
		default = 'build',
		value   = 'path',
		description = 'Set the output location for the generated files'
	}

---
-- Premake API keys.
---
	p.api.register {
		name = 'includedependencies',
		scope = 'config',
		kind = 'tableorstring'
	}

	p.api.register {
		name = 'linkdependencies',
		scope = 'config',
		kind = 'tableorstring'
	}

	p.api.register {
		name = 'bindirdependencies',
		scope = 'config',
		kind = 'tableorstring'
	}

	p.api.register {
		name = 'copybindependencies',
		scope = 'config',
		kind = 'tableorstring',
	}

	p.api.register {
		name = 'copybintarget',
		scope = 'config',
		kind = 'path',
		tokens = true,
		pathVars = true,
	}

	p.api.register {
		name  = 'lockfile',
		scope = 'global',
		kind  = 'file',
	}


---
-- API's to control the output folders for imported packages.
---
	p.api.register {
		name     = 'package_location',
		scope    = 'project',
		kind     = 'path',
		tokens   = true,
		pathVars = true,
	}

	p.api.register {
		name     = 'package_buildlog',
		scope    = 'config',
		kind     = 'path',
		tokens   = true,
		pathVars = true,
	}

	p.api.register {
		name     = 'package_objdir',
		scope    = 'config',
		kind     = 'path',
		tokens   = true,
		pathVars = true,
	}

	p.api.register {
		name     = 'package_libdir', -- this controls the targetdir for StaticLib projects.
		scope    = 'config',
		kind     = 'path',
		tokens   = true,
		pathVars = true,
	}

	p.api.register {
		name     = 'package_bindir', -- this controls the targetdir for SharedLib, WindowedApp and ConsoleApp projects.
		scope    = 'config',
		kind     = 'path',
		tokens   = true,
		pathVars = true,
	}

	-- initialize sane defaults.
	package_location (path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to, 'projects/packages'))
	package_bindir   (path.join(_MAIN_SCRIPT_DIR, "bin/%{premake.packagemanager.buildVariantFromConfig(cfg)}"))
	package_objdir   (path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to, '%{premake.packagemanager.buildVariantFromConfig(cfg)}', 'obj'))
	package_libdir   (path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to, '%{premake.packagemanager.buildVariantFromConfig(cfg)}', 'lib'))

---
-- shortcut if you need both include & link dependencies
---
	function usedependencies(table)
		includedependencies(table)
		linkdependencies(table)
	end


---
-- Module must always be loaded.
---
	return function(cfg)
		return true
	end
