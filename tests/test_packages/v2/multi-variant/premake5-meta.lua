return {
	variants = { "linux-i386", "linux-x86_64", "win32-i386", "win32-x86_64" },

	["linux-i386"] = {
		system       = "linux",
		architecture = "x86",

		includedirs  = { "include" },
		libdirs      = { "libs/linux/x86" },
	},

	["linux-x86_64"] = {
		system       = "linux",
		architecture = "x86_64",

		includedirs  = { "include" },
		libdirs      = { "libs/linux/x64" },
	},

	["win32-i386"] = {
		system       = "windows",
		architecture = "x86",

		includedirs  = { "include" },
		libdirs      = { "libs/win32/x86" },
	},

	["win32-x86_64"] = {
		system       = "windows",
		architecture = "x86_64",

		includedirs  = { "include" },
		libdirs      = { "libs/win32/x64" },
	}
}
