---
-- Package management module
-- Version 2.0 Package API.
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

-- Package API ----------------------------------------------------------------

local packageAPI = {}

function packageAPI:loadvariants(filter)
	local result = {}

	-- load all variants that match the filter.
	for _, variant in pairs(self.variants) do
		if variant:matches(filter) then
			local r = self:loadvariant(variant)
			if r then
				table.insert(result, r)
			end
		end
	end

	return result
end

function packageAPI:loadvariant(variant)
	-- if it's a string, find it.
	if type(variant) == "string" then
		variant = self.variants[variant:lower()]
	end

	-- if the variant doesn't exist, or is already loaded, return.
	if not variant or variant.loaded then
		return variant
	end

	-- now load it.
	verbosef(' LOAD %s/%s', self.name, variant.name)

	-- register package as loaded
	variant.loaded = true

	return variant
end

function packageAPI:generateManifest(tbl, wks)
	local vtbl = {}
	for _, v in pairs(self.variants) do
		v:generateManifest(vtbl, wks)
	end
	if next(vtbl) == nil then
		vtbl = nil
	end

	tbl[self.name] = {
		type = "2.0",
		version = self.version,
		variants = vtbl
	}
end

-- Importing API --------------------------------------------------------------

local function __isPackage(folder)
	local filename = path.join(folder, 'premake5-meta.lua')
	return os.isfile(filename)
end


local function __getPackageFolder(name, version)
	-- test if version is a folder name.
	if os.isdir(version) then
		if __isPackage(version) then
			verbosef(' LOCAL: %s', version)
			return version
		end
	end

	-- test if we have the package locally.
	for _, folder in ipairs(p.packagemanager.folders) do
		local location = m.createPackageLocation(folder, name, version)
		if __isPackage(location) then
			verbosef(' LOCAL: %s', location)
			return location
		end
	end

	-- test if we downloaded it already.
	local location = m.createPackageLocation(p.packagemanager.getCacheLocation(), name, version)
	if __isPackage(location) then
		verbosef(' CACHED: %s', location)
		return location
	end

	-- if we don't want server queries, we stop here.
	if _OPTIONS['no-http'] then
		return nil
	end

	-- ask if any of the servers has it? First hit gets it.
	local link_url = '/api/v1/link/' .. http.escapeUrlParam(name) .. '/' .. http.escapeUrlParam(version)
	local info = http.getJson(p.packagemanager.servers, link_url)
	if info ~= nil and info.url ~= nil then
		if type(info.state) == "string" and info.state:lower() ~= 'active' then
			p.warn('"%s/%s" is marked "%s", consider upgrading to a known good version.', name, version, info.state)
		end

		if info.version then
			version = info.version
			location = m.createPackageLocation(p.packagemanager.getCacheLocation(), name, version)
			if __isPackage(location) then
				verbosef(' CACHED: %s', location)
				return location
			end
		end

		-- create destination folder.
		os.mkdir(location)

		-- download to packagecache/name-version.zip.
		local destination = m.createPackageLocation(p.packagemanager.getCacheLocation(), name .. '-' .. version .. '.zip')

		print(' DOWNLOAD: ' .. info.url)
		local result_str, response_code = http.download(info.url, destination,
		{
			headers  = http.getHttpHeader(),
			progress = iif(_OPTIONS.verbose, http.reportProgress, nil)
		})

		if result_str ~= "OK" then
			p.error('Download of %s failed (%d)\n%s', info.url, response_code, result_str)
		end

		-- Unzip it
		verbosef(' UNZIP   : %s', destination)
		zip.extract(destination, location)
		os.remove(destination)
		return location
	end

	return nil
end


local function __createFilter(meta)
	return m.validateFilter({
		system         = meta.system,
		architecture   = meta.architecture,
		toolset        = meta.toolset,
		action         = meta.action,
		configurations = meta.configurations,
		tags           = meta.tags
	})
end


local function __createVariant(pkg, name, meta, dir)
	if meta == nil then
		error("Metadata entry for '" .. name .."' does not exist.")
	end

	m.checkType("includedirs", meta.includedirs, "table")
	m.checkType("links",       meta.links,       "table")
	m.checkType("libdirs",     meta.libdirs,     "table")
	m.checkType("defines",     meta.defines,     "table")
	m.checkType("bindirs",     meta.bindirs,     "table")
	m.checkType("premake",     meta.premake,     "string")
	m.checkType("tests",       meta.tests,       "string")
	m.checkType("options",     meta.options,     "table")

	local variant = m.createVariant(name)
	variant.filter     = __createFilter(meta)
	variant.includes   = meta.includedirs
	variant.links      = meta.links
	variant.libdirs    = meta.libdirs
	variant.defines    = meta.defines
	variant.bindirs    = meta.bindirs
	variant.location   = dir
	variant.script     = meta.premake
	variant.testscript = meta.tests
	variant.options    = meta.options
	variant.package    = pkg
	variant.loaded     = false

	-- if links wasn't set, then enumerate the libdirs if set
	if meta.links == nil and meta.libdirs ~= nil then
		variant.links = variant.links or {}
		for _, libdir in ipairs(meta.libdirs) do
			libdir = path.join(dir, libdir)
			table.insertflat(variant.links, _get_lib_files(libdir, variant.filter.system))
		end
	end

	-- setup the initializer.
	if meta.premake ~= nil then
		variant.initializer = function()
			dofile(meta.premake)
		end
	end

	return variant
end


return function (name, version)
	local dir = __getPackageFolder(name, version)
	if not dir then
		return nil
	end

	-- make dir absolute.
	dir = path.getabsolute(dir)

	-- load the meta data file.
	local env = {}
	local filename = path.join(dir, 'premake5-meta.lua');
	if not os.isfile(filename) then
		error('Package in folder "' .. dir .. '" does not have a premake5-meta.lua script.')
	end
	local untrusted_function, message = loadfile(filename, 't', env)
	if not untrusted_function then
		error(message)
	end

	-- now execute it, so we can get the data.
	local result, meta = pcall(untrusted_function)
	if not result then
		error(meta)
	end

	-- create package from metadata.
	local pkg = m.createPackageBase(name, version)
	pkg.variants['noarch'] = __createVariant(pkg, 'noarch', meta, dir)

	if meta.variants ~= nil then
		for _, v in ipairs(meta.variants) do
			if variant == "noarch" then
				p.error("'noarch' variant is reserved for the top-level meta-data.")
			end

			pkg.variants[v] = __createVariant(pkg, v, meta[v], dir)
		end
	end

	-- return package with PackageV2 metadata attachment.
	return setmetatable(pkg, {
		__metatable = false,

		__index    = packageAPI,

		__newindex = function(tbl, key, value)
			error("Attempt to modify readonly table.")
		end,

		__tostring = function()
			return "Package V2"
		end,
	})
end
