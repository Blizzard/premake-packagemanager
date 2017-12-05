---
-- Package management module
-- Package dependency resolving code.
-- Copyright (c) 2014-2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

local project = p.project
local import_filter = {}

---
-- private helper function
---
	local function __matchLink(filename, match)
		if type(match) == 'function' then
			return match(filename)
		end
		return string.match(filename, match:lower())
	end

---
-- help filter to link only those libs that are mentioned.
---
	local function __createFilter(t)
		if t then
			return function(l)
				local matches = {}
				local nonmatches = {}
				local all_index = nil

				for k, link in ipairs(l) do
					local filename = path.getname(link):lower()
					for index, match in ipairs(t) do
						if match == '*' then
							all_index = index
						elseif __matchLink(filename, match) then
							if matches[index] then
								table.insert(matches[index], link)
							else
								matches[index] = {link}
							end
							break
						else
							table.insert(nonmatches, link)
						end
					end
				end

				if all_index then
					matches[all_index] = nonmatches
				end

				local linres = {}

				for key, val in ipairs(matches) do
					if t[key] == '*' then
						table.insertflat(linres, val)
					elseif #val > 0 then
						table.insert(linres, val[1])
					end
				end

				return linres;
			end
		else
			return function(l)
				return l
			end
		end
	end


---
--- Gets the default import filter
---
	local function __defaultImportFilter(name)
		if import_filter[name:lower()] then
			return import_filter[name:lower()]
		end
		return nil
	end


---
--- resolve packages, internal method.
---
	local function __resolvePackages(ctx)
		if ctx.packages_resolved then
			return
		end

		local function getpackage(wks, name)
			local result = p.packagemanager.getPackage(name)
			if not result then
				local prjname = iif(ctx.project, ctx.project.name, ctx.name)
				error("Package '" .. name .. "' was not imported, but the project '" .. prjname .. "' has a dependency on it.")
			end
			return result
		end

		local function sortedpairs(t)
			-- collect all the keys for entries that are not numbers.
			-- and store the values for entries that are numbers.
			local keys = {}
			local values = {}
			for k, v in pairs(t) do
				if tonumber(k) ~= nil then
					table.insert(values, v)
				else
					table.insert(keys, k)
				end
			end

			-- sort the keys.
			table.sort(keys)

			-- return the iterator function
			local i = 0
			local n = #values
			return function()
				i = i + 1
				if (i <= n) then
					return values[i], nil
				else
					local k = keys[i-n]
					if k then
						return k, t[k]
					end
				end
			end
		end

		local function insertkeyed(tbl, values)
			for _, value in ipairs(values) do
				table.insertkeyed(tbl, value)
			end
		end

		local function addOrMoveToBottom(tbl, values)
			for _, value in ipairs(values) do
				if not table.insertkeyed(tbl, value) then
					local idx = table.indexof(tbl, value)
					table.remove(tbl, idx)
					table.insert(tbl, value)
				end
			end
		end

		local function recursiveIncludeDependencies(ctx, deps)
			for name,_ in sortedpairs(deps) do
				local pkg = getpackage(ctx.workspace, name)
				insertkeyed(ctx.includedirs, pkg.auto_includes(ctx))
				insertkeyed(ctx.defines,     pkg.auto_defines(ctx))
				insertkeyed(ctx.dependson,   pkg.auto_dependson(ctx))
				recursiveIncludeDependencies(ctx, pkg.auto_includedependencies(ctx))
			end
		end

		local function recursiveLinkDependencies(ctx, deps)
			for name,value in sortedpairs(deps) do
				local filter = nil
				if type(value) == 'table' then
					filter = __createFilter(value)
				else
					filter = __createFilter(__defaultImportFilter(name))
				end

				local pkg = getpackage(ctx.workspace, name)
				addOrMoveToBottom(ctx.links, filter(pkg.auto_links(ctx)))

				insertkeyed(ctx.libdirs, pkg.auto_libdirs(ctx))
				recursiveLinkDependencies(ctx, pkg.auto_linkdependencies(ctx))
			end
		end

		-- resolve package includes & defines
		if ctx.includedependencies then
			recursiveIncludeDependencies(ctx, ctx.includedependencies);
		end

		-- resolve package binpath.
		if ctx.bindirdependencies then
			for name,_ in sortedpairs(ctx.bindirdependencies) do
				local pkg = getpackage(ctx.workspace, name)
				insertkeyed(ctx.bindirs, pkg.auto_bindirs(ctx))
			end
		end

		-- resolve package includes.
		if ctx.copybindependencies then
			local seperator = package.config:sub(1,1)
			local info = premake.config.gettargetinfo(ctx)
			local targetDir = ctx.copybintarget or info.directory

			for name, value in sortedpairs(ctx.copybindependencies) do
				local pkg = getpackage(ctx.workspace, name)
				for _, dir in ipairs(pkg.auto_bindirs(ctx)) do
					local src = project.getrelative(ctx.project, dir)
					local dst = project.getrelative(ctx.project, targetDir)

					local command = string.format('{COPY} "%s" "%s"',
						path.translate(src, seperator),
						path.translate(dst, seperator))

					table.insert(ctx.postbuildcommands, command)
				end
			end
		end

		-- resolve package links.
		if ctx.linkdependencies then
			recursiveLinkDependencies(ctx, ctx.linkdependencies)
		end

		ctx.packages_resolved = true
	end

---
--- inject package resolver into p.oven.bake
---
	function m.generateManifest(wks)
		local tbl = {}
		for _, pkg in pairs(wks.package_cache) do
			pkg:generateManifest(tbl, wks)
		end
		return tbl
	end


---
--- inject package resolver into p.oven.bake
---
	p.override(p.oven, 'bake', function(base)
		-- run bake first.
		base()

		-- Resolve Package dependencies.
		print('Resolving Packages...')
		verbosef('Package cache: %s', p.packagemanager.getCacheLocation())

		for wks in p.global.eachWorkspace() do
			for prj in p.workspace.eachproject(wks) do
				if not prj.external then
					verbosef("Resolving '%s'...", prj.name)

					if _ACTION == 'xcode' then
						if not cfg then
							cfg = prj
						end
						__resolvePackages(prj)
					end

					for cfg in project.eachconfig(prj) do
						__resolvePackages(cfg)
					end
				end
			end
		end

		-- Write package metadata.
		print('Generating Package Manifests...')
		for wks in p.global.eachWorkspace() do
			local mantbl = m.generateManifest(wks)
			local manifest, err = json.encode_pretty(mantbl)
			if manifest == nil then
				p.error(err)
			end

			if #manifest > 2 then
				p.generate(wks, ".pmanifest", function()
					p.utf8()
					p.outln(manifest)
				end)
			end
		end

		-- Force a lua GC.
		collectgarbage()
	end)


---
-- Import lib filter for a set of packages.
---
	function importlibfilter(table)
		if not table then
			return nil
		end

		-- import packages.
		for name, filter in pairs(table) do
			if not import_filter[name:lower()] then
				import_filter[name:lower()] = filter
			end
		end
	end
