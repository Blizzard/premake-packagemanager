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
