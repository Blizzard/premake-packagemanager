local suite = test.declare("package_v2_multi_variant")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()

local wks, prj


function suite.setup()
	p.packagemanager.reset()
	p.packagemanager.folders = { path.join(test_dir, "test_packages") }
	p.packagemanager.servers = { }

	local wks = workspace "MyWorkspace"
		platforms { "windows", "linux" }
		configurations { "Debug", "Release" }

		import { ['v2'] = 'multi-variant' }

		filter { 'platforms:windows' }
			system 'windows'
			architecture 'x86'

		filter { 'platforms:linux' }
			system 'linux'
			architecture 'x86_64'
end


function suite.import()
	local pkg = package.get("v2")
	test.isnotnil(pkg.variants["linux-i386"])
	test.isnotnil(pkg.variants["linux-x86_64"])
	test.isnotnil(pkg.variants["win32-i386"])
	test.isnotnil(pkg.variants["win32-x86_64"])

	test.isfalse(pkg.variants["linux-i386"].loaded)
	test.isfalse(pkg.variants["linux-x86_64"].loaded)
	test.isfalse(pkg.variants["win32-i386"].loaded)
	test.isfalse(pkg.variants["win32-x86_64"].loaded)
end


function suite.includedependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		includedependencies { 'v2' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v2/multi-variant/include')
	test.isequal({expected}, cfg.includedirs)

	local cfg = test.getConfig(prj, "Debug", "linux")
	local expected = path.join(test_dir, 'test_packages/v2/multi-variant/include')
	test.isequal({expected}, cfg.includedirs)
end


function suite.linkdependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		linkdependencies { 'v2' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v2/multi-variant/libs/win32/x86/v2.lib')
	test.isequal({expected}, cfg.links)

	local cfg = test.getConfig(prj, "Debug", "linux")
	local expected = path.join(test_dir, 'test_packages/v2/multi-variant/libs/linux/x64/libv2.a')
	test.isequal({expected}, cfg.links)
end


