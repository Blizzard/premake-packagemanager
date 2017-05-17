local suite = test.declare("package_v2_single_variant")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()


function suite.setup()
	p.packagemanager.reset()
	p.packagemanager.folders = { path.join(test_dir, "test_packages") }
	p.packagemanager.servers = { }

	--verbosef = function(msg, ...)
	--	test.print(string.format(msg, ...))
	--end

	local wks = workspace "MyWorkspace"
		platforms { "windows", "linux" }
		configurations { "Debug", "Release" }
		import { ['v2'] = 'single-variant' }
end


function suite.import()
	local pkg = package.get("v2")
	test.isnotnil(pkg.variants["noarch"])
	test.istrue(pkg.variants["noarch"].loaded)
	test.isequal({"include"}, pkg.variants["noarch"].includes)
	test.isequal({"v2"}, pkg.variants["noarch"].links)
end


function suite.includedependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		includedependencies { 'v2' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v2/single-variant/include')
	test.isequal({expected}, cfg.includedirs)
end


function suite.linkdependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		linkdependencies { 'v2' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	test.isequal({"v2"}, cfg.links)
end
