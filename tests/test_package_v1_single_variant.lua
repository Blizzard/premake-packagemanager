local suite = test.declare("package_v1_single_variant")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()


function suite.setup()
	p.packagemanager.reset()
	p.packagemanager.folders = { path.join(test_dir, "test_packages") }
	p.packagemanager.servers = { }

	local wks = workspace "MyWorkspace"
		platforms { "windows", "linux" }
		configurations { "Debug", "Release" }
		import { ['v1'] = 'single-variant' }
end


function suite.import()
	local pkg = package.get("v1")
	test.isnotnil(pkg.variants["noarch"])
	test.istrue(pkg.variants["noarch"].loaded)
	test.isequal({"include"}, pkg.variants["noarch"].includes)
	test.isequal({"v1"}, pkg.variants["noarch"].links)
end


function suite.includedependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		includedependencies { 'v1' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v1/single-variant/noarch/include')
	test.isequal({expected}, cfg.includedirs)
end

function suite.linkdependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		linkdependencies { 'v1' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	test.isequal({"v1"}, cfg.links)
end
