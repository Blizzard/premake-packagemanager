local suite = test.declare("package_v2_transitive")

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
		import {
			['a'] = '1.0.0',
			['b'] = '1.0.0',
			['c'] = '1.0.0',
		}
end


function suite.includedependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		usedependencies { 'c' }

	local cfg = test.getConfig(prj, "Debug", "windows")
	local expected =
	{
		path.join(test_dir, 'test_packages/c/1.0.0/include'),
		path.join(test_dir, 'test_packages/b/1.0.0/include'),
		path.join(test_dir, 'test_packages/a/1.0.0/include'),
	}
	test.isequal(3, #cfg.includedirs)
	test.isequal(expected, cfg.includedirs)
end


function suite.linkdependencies()
	local prj = project "MyProject"
		language "C++"
		kind "ConsoleApp"
		usedependencies { 'c' }

	local cfg = test.getConfig(prj, "Debug", "windows")

	test.isequal(3, #cfg.links)
	test.isequal({'c', 'b', 'a'}, cfg.links)
end
