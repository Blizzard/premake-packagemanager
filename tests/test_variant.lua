local suite = test.declare("variant")

local p = premake
local m = p.modules.packagemanager

local __filter = {
	action         = "vs2015",
	system         = os.getSystemTags("windows"),
	architecture   = "x86",
	toolset        = "msc-v140",
	configurations = "debug",
	tags           = {"a", "b", "c", "d"},
}


function suite.setup()
end

function suite.NilFilter()
	local variant = m.createVariant("test")
	variant.filter = nil

	test.istrue(variant:matches(__filter))
end


function suite.EmptyFilter()
	local variant = m.createVariant("test")
	variant.filter = {}

	test.istrue(variant:matches(__filter))
end

function suite.ActionFilter()
	local variant = m.createVariant("test")
	variant.filter = {
		action = "vs*"
	}

	test.istrue(variant:matches(__filter))
end

function suite.SystemFilter()
	local variant = m.createVariant("test")
	variant.filter = {
		system = "windows"
	}

	test.istrue(variant:matches(__filter))
end

function suite.SystemFilterNoMatch()
	local variant = m.createVariant("test")
	variant.filter = {
		system = "linux"
	}

	test.isfalse(variant:matches(__filter))
end


function suite.TagsFilter()
	local variant = m.createVariant("test")
	variant.filter = {
		tags = {"a", "b"}
	}

	test.istrue(variant:matches(__filter))
end

function suite.TagsFilterNoMatch()
	local variant = m.createVariant("test")
	variant.filter = {
		tags = {"a", "e"}
	}

	test.isfalse(variant:matches(__filter))
end


function suite.ConfigFilter()
	local variant = m.createVariant("test")
	variant.filter = {
		configurations = "debug"
	}

	test.istrue(variant:matches(__filter))
end

function suite.ConfigFilterNoMatch()
	local variant = m.createVariant("test")
	variant.filter = {
		configurations = "release"
	}

	test.isfalse(variant:matches(__filter))
end

