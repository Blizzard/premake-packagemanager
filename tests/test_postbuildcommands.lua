

local suite = test.declare("test_postbuildcommands")
local gmake2 = premake.modules.gmake2

local wks, prj, cfg

function suite.setup()
	wks = test.createWorkspace()
end

local function prepare()
	wks = test.getWorkspace(wks)
	prj = test.getproject(wks, 1)
	cfg = test.getconfig(prj, "Debug")

	local toolset = gmake2.getToolSet(cfg)
	gmake2.postBuildCmds(cfg, toolset)
end

function suite.postbuildcommands()
	targetname "blink"
	kind "StaticLib"
	language "C++"
	targetdir ("%{cfg.package_libdir}")

	postbuildcommands
	{
		"mkdir %{cfg.package_bindir}/www",
		"mkdir %{cfg.package_bindir}/www"
	}

	prepare()

	test.capture [[
define POSTBUILDCMDS
	@echo Running postbuild commands
	mkdir bin/win32-test-debug/www
	mkdir bin/win32-test-debug/www
endef
]]
end


