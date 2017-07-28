---
-- Package management module
-- Variant matching/creation code.
-- Copyright (c) 2017 Blizzard Entertainment
---

local p = premake
local m = p.modules.packagemanager

local __members = {
	filter      = "table",
	includes    = "table",
	links       = "table",
	libdirs     = "table",
	defines     = "table",
	bindirs     = "table",
	location    = "string",
	server      = "string",
	script      = "string",
	testscript  = "string",
	initializer = "function",
	loaded      = "boolean",
	package     = "table",
}

local api = {}


function m.validateFilter(f)
	local _validKeys = {
		["system"]         = "string",
		["architecture"]   = "string",
		["toolset"]        = "string",
		["action"]         = "string",
		["configurations"] = "string",
		["tags"]           = "table",
	}

	for key, _ in pairs(f) do
		if not _validKeys[key] then
			p.error("Invalid entry in filter: '%s'.", key)
		end
		m.checkType(key, f[key], _validKeys[key]);
	end

	return f
end


function api:matches(filter)
	if self.filter == nil then
		return true
	end

	if not self.__compiled_filter then
		local f = m.validateFilter(self.filter)

		local function add(tbl, name, value)
			if value ~= nil then
				table.insert(tbl, name .. value)
			end
		end

		local tbl = {}
		add(tbl, "system:" ,        f.system)
		add(tbl, "architecture:",   f.architecture)
		add(tbl, "toolset:",        f.toolset)
		add(tbl, "action:",         f.action)
		add(tbl, "configurations:", f.configurations)

		if f.tags then
			for _, tag in ipairs(f.tags) do
				table.insert(tbl, "tags:" .. tag)
			end
		end

		-- avoid the metatable check.
		rawset(self, "__compiled_filter", criteria.new(tbl))
	end

	return criteria.matches(self.__compiled_filter, filter)
end

function api:generateManifest(tbl, wks)
	if not self.loaded then
		return
	end

	tbl[self.name] = {
		location       = p.workspace.getrelative(wks, self.location),
		system         = self.filter.system,
		architecture   = self.filter.architecture,
		toolset        = self.filter.toolset,
		action         = self.filter.action,
		configurations = self.filter.configurations,
		tags           = self.filter.tags,
		includedirs    = self.includes,
		defines        = self.defines,
		links          = self.links,
		libdirs        = self.libdirs,
		bindirs        = self.bindirs,
	}
end


function m.createVariant(name)
	local variant = {
		name = name
	}

	-- return locked down variant.
	return setmetatable(variant, {
		__metatable = false,

		__index    = api,

		__newindex = function(tbl, key, value)
			local t = __members[key]
			if t ~= nil then
				if value == nil or type(value) == t then
					rawset(tbl, key, value)
				else
					p.error("'%s' expected a '%s', got: '%s'.", key, t, type(value))
				end
			else
				p.error("Attempt to write to unknown member '%s' (%s).", key, type(value))
			end
		end,

		__tostring = function()
			return "Variant"
		end,
	})
end
