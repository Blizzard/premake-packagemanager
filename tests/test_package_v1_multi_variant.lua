local suite = test.declare("package_v1_multi_variant")

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

		import { ['v1'] = 'multi-variant' }

		filter { 'platforms:windows' }
			system 'windows'
			architecture 'x86'

		filter { 'platforms:linux' }
			system 'linux'
			architecture 'x86_64'
end


function suite.import()
	local pkg = package.get("v1")
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
		includedependencies { 'v1' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v1/multi-variant/win32-i386/include')
	test.isequal({expected}, cfg.includedirs)

	local cfg = test.getConfig(prj, "Debug", "linux")
	local expected = path.join(test_dir, 'test_packages/v1/multi-variant/linux-x86_64/include')
	test.isequal({expected}, cfg.includedirs)
end


function suite.linkdependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		linkdependencies { 'v1' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected = path.join(test_dir, 'test_packages/v1/multi-variant/win32-i386/lib/v1.lib')
	test.isequal({expected}, cfg.links)

	local cfg = test.getConfig(prj, "Debug", "linux")
	local expected = path.join(test_dir, 'test_packages/v1/multi-variant/linux-x86_64/lib/libv1.a')
	test.isequal({expected}, cfg.links)
end

