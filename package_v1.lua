---
-- Package management module
-- Version 1.0 Package API.
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

-- Package API ----------------------------------------------------------------

local function __packageLocation(...)
	local location = path.join(...)
	location = path.normalize(location)
	location = location:gsub('%s+', '_')
	location = location:gsub('%(', '_')
	location = location:gsub('%)', '_')
	return location
end


local function __createVariant(name, location, server)
	local variant = m.createVariant(name)
	variant.filter   = p.packagemanager.filterFromVariant(name)
	variant.location = location
	variant.server   = server
	return variant
end


local function __getVariants(name, version)
	local result = {}

	-- test if version is a folder name.
	if os.isdir(version) then
		for i, dir in pairs(os.matchdirs(version .. '/*')) do
			local n, variant = string.match(dir, '(.+)[\\|/](.+)')
			variant = variant:lower()
			result[variant] = __createVariant(variant, dir, nil)
		end
		return result
	end

	-- test if we have the package locally.
	for i, folder in ipairs(p.packagemanager.folders) do
		local location = __packageLocation(folder, name, version)
		if os.isdir(location) then
			for i, dir in pairs(os.matchdirs(location .. '/*')) do
				local n, variant = string.match(dir, '(.+)[\\|/](.+)')
				variant = variant:lower()
				result[variant] = __createVariant(variant, dir, nil)
			end
			return result
		end
	end

	-- if we don't want server queries, just return the local results.
	if _OPTIONS['no-http'] then
		return result
	end

	-- Query the server for variant information.
	local link = '/archives?name=' .. http.escapeUrlParam(name) .. '&version=' .. http.escapeUrlParam(version)
	for _, hostname in ipairs(p.packagemanager.servers) do
		local content, result_str, result_code = http.get(hostname .. link, { headers = http.getHttpHeader() })
		if content then
			local variant_tbl = json.decode(content)
			for i, variant in pairs(variant_tbl) do
				variant = path.getbasename(variant):lower()
				if not result[variant] then
					verbosef('[%s/%s] Adding variant: %s from %s.', name, version, variant, hostname)
					result[variant] = __createVariant(variant, nil, hostname)
				end
			end
		else
			p.warn('A problem occured trying to contact %s.\n%s(%d).', hostname, result_str, result_code)
		end
	end

	return result
end

local function __download(hostname, name, version, variant)
	-- first see if we can find the package locally.
	for i, folder in pairs(p.packagemanager.folders) do
		local location = __packageLocation(folder, name, version, variant)
		if os.isdir(location) then
			verbosef('LOCAL: %s', location)
			return location
		end
	end

	-- then try the package cache.
	local location = __packageLocation(p.packagemanager.getCacheLocation(), name, version, variant)
	if os.isdir(location) then
		verbosef('CACHED: %s', location)
		return location
	end

	-- if we don't have a host name, we can't download it.
	if not hostname then
		premake.error("Package '" .. name .. "/" .. version .. "' not found on any server.")
	end

	-- calculate standard file_url.
	local file        = http.escapeUrlParam(name) .. '/' .. http.escapeUrlParam(version) .. '/' .. http.escapeUrlParam(variant) .. '.zip'
	local file_url    = hostname .. '/' .. file

	-- get link information from server.
	local link_url = '/link?name=' .. http.escapeUrlParam(name) .. '&version=' .. http.escapeUrlParam(version) .. '&variant=' .. http.escapeUrlParam(variant)
	local content, result_str, result_code = http.get(hostname .. link_url, { headers = http.getHttpHeader() })
	if content then
		local info_tbl = json.decode(content)
		if info_tbl.url then
			file_url = info_tbl.url
		end

		if type(info_tbl.state) == "string" and info_tbl.state:lower() ~= 'active' then
			premake.warn('"%s/%s" is marked "%s", consider upgrading to a known good version.', name, version, info_tbl.state)
		end

		if info_tbl.version then
			location = __packageLocation(p.packagemanager.getCacheLocation(), name, info_tbl.version, variant)
			if os.isdir(location) then
				verbosef('CACHED: %s', location)
				return location
			end
		end
	end

	-- Download the file.
	local destination = location .. '.zip'

	print(' DOWNLOAD: ' .. file_url)
	os.mkdir(path.getdirectory(destination))
	local result_str, response_code = http.download(file_url, destination,
	{
		headers = http.getHttpHeader(),
		progress = iif(_OPTIONS.verbose, http.reportProgress, nil)
	})

	if result_str ~= "OK" then
		premake.error('Download of %s failed (%d)\n%s', file_url, response_code, result_str)
	end

	-- Unzip it
	verbosef(' UNZIP   : %s', destination)
	zip.extract(destination, location)
	os.remove(destination)
	return location
end


local function __makeExecutable(directory_bin)
	if os.ishost('linux') or os.ishost('macosx') then
		for num, file in pairs(os.matchfiles(path.join(directory_bin, '*'))) do
			os.execute("chmod +x \"" .. file .. "\"")
		end
	end
end


local function __getFrameworkFolders(dir)
	if os.istarget('macosx') then
		local pattern = path.join(dir, '*.framework')
		return os.matchdirs(pattern)
	else
		return {}
	end
end


-- Package API ----------------------------------------------------------------

local packageAPI = {}

---
-- load all the variant compatible with a specific config.
---
function packageAPI:loadvariants(filter)
	local options = self.variants
	local check   = { }

	-- Check if there is a build_custom_variant method, and use that.
	if filter.cfg ~= nil and type(bnet.build_custom_variant) == 'function' then
		--p.warnOnce("build_custom_variant", "'bnet.build_custom_variant(cfg, options)' is deprecated, use the 'variantmap' API instead.")
		table.insertflat(check, bnet.build_custom_variant(filter.cfg, options))
	end

	-- Check the default variants.
	table.insertflat(check, p.packagemanager.buildVariantsFromFilter(filter))
	table.insert(check, 'noarch')
	table.insert(check, 'universal')

	-- load all those variants, if they exists.
	local result = {}
	for _, v in ipairs(check) do
		local r = self:loadvariant(v)
		if r then
			table.insert(result, r)
		end
	end

	return result
end


---
-- load a specific variant if not already loaded.
---
function packageAPI:loadvariant(variant)
	-- if it's a string, find it.
	if type(variant) == "string" then
		variant = self.variants[variant:lower()]
	end

	-- if the variant doesn't exist, or is already loaded, return.
	if not variant or variant.loaded then
		return variant
	end

	verbosef(' LOAD %s/%s', self.name, variant.name)

	-- download it first, in case that hasn't happened yet?
	local directory = __download(variant.server, self.name, self.version, variant.name)

	-- register package as loaded
	variant.loaded   = true
	variant.package  = self
	variant.location = directory

	-- does it contain an include directory?
	local directory_include = path.join(directory, 'include')
	if os.isdir(directory_include) then
		verbosef(' INC ' .. directory_include)

		variant.includes = variant.includes or {}
		table.insert(variant.includes, 'include')
	end

	-- does it contain an bin directory?
	local directory_bin = path.join(directory, 'bin')
	if os.isdir(directory_bin) then
		verbosef(' BIN ' .. directory_bin)
		__makeExecutable(directory_bin)

		variant.bindirs = variant.bindirs or {}
		table.insert(variant.bindirs, 'bin')
	end

	-- does it contain an runtime directory?
	local directory_runtime = path.join(directory, 'runtime')
	if os.isdir(directory_runtime) then
		verbosef(' BIN ' .. directory_runtime)
		__makeExecutable(directory_runtime)

		variant.bindirs = variant.bindirs or {}
		table.insert(variant.bindirs, 'runtime')
	end

	-- does it contain a library directory?
	local directory_lib = path.join(directory, 'lib')
	if os.isdir(directory_lib) then
		verbosef(' LIB ' .. directory_lib)

		variant.libdirs = variant.libdirs or {}
		table.insert(variant.libdirs, 'lib')

		variant.links = variant.links or {}
		table.insertflat(variant.links, _get_lib_files(directory_lib, variant.filter.system))
	end

	-- on mac does it contain a framework directory?
	if m.isSystem('macosx', variant.filter.system) then
		local directory_fw = path.join(directory, 'framework')
		if os.isdir(directory_fw) then
			verbosef(' FRAMEWORK ' .. directory_fw)

			variant.libdirs = variant.libdirs or {}
			table.insert(variant.libdirs, 'framework')

			variant.links = variant.links or {}
			table.insertflat(variant.links, __getFrameworkFolders(directory_fw))
		end
	end

	-- does it contain a package premake directive?
	local path_premake = path.join(directory, 'premake5-package.lua')
	if os.isfile(path_premake) then
		-- store current package context.
		local previous_package = package.current
		package.current = v

		-- load the script.
		verbosef('dofile(%s)', path_premake)
		variant.script      = path_premake;
		variant.initializer = dofile(path_premake)

		-- restore package context.
		package.current = previous_package
	end

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
		type = "1.0",
		version = self.version,
		variants = vtbl
	}
end


-- Import function ------------------------------------------------------------

return function (name, version)
	local available_variants = __getVariants(name, version)
	if next(available_variants) == nil then
		return nil
	end

	local pkg    = m.createPackageBase(name, version)

	-- bind the found variants to the package.
	pkg.variants = available_variants
	for name, variant in ipairs(available_variants) do
		variant.package = pkg
	end

	-- set metadata.
	return setmetatable(pkg, {
		__metatable = false,

		__index    = packageAPI,

		__newindex = function(tbl, key, value)
			error("Attempt to modify readonly table.")
		end,

		__tostring = function()
			return "Package V1"
		end,
	})
end
