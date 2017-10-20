local suite = test.declare("package_v2_options")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()

--
-- Setup
--
	local wks, prj, cfg

	function suite.setup()
		p.packagemanager.reset()
		p.packagemanager.folders = { path.join(test_dir, "test_packages") }
		p.packagemanager.servers = { }

		wks = test.createWorkspace()
	end

	local function prepare()
		wks = test.getWorkspace(wks)
		prj = test.getproject(wks, 2)
		cfg = test.getconfig(prj, "Debug")
	end

--
-- Test not setting options.
--
	function suite.no_options_set()
		import { ['v2'] = 'options' }
		prepare()

		test.isequal({ "MULTITHREADING=0", "STACKSIZE=1024" }, prj.defines)
	end

--
-- Test setting option to a value.
--
	function suite.options_set_on()
		import {
			['v2'] = {
				version = 'options',
				multithreading = 'on'
			}
		}

		prepare()

		test.isequal({ "MULTITHREADING=1", "STACKSIZE=1024" }, prj.defines)
	end

--
-- Test setting option to a value.
--
	function suite.options_set_off()
		import {
			['v2'] = {
				version = 'options',
				multithreading = 'off'
			}
		}
		prepare()

		test.isequal({ "MULTITHREADING=0", "STACKSIZE=1024" }, prj.defines)
	end


--
-- Test stacksize option
--
	function suite.options_set_stacksize()
		import {
			['v2'] = {
				version = 'options',
				stacksize = 4096
			}
		}
		prepare()

		test.isequal({ "MULTITHREADING=0", "STACKSIZE=4096" }, prj.defines)
	end

