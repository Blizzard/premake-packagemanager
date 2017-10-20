return {
	includedirs = { 'include' },
	links       = { 'v2' },

	options     = {
		['multithreading'] = { kind = 'boolean', default = 'off' },
		['stacksize']      = { kind = 'integer', default = 1024 },
		['folder']         = { kind = 'path' }
	},

	premake     = 'options.lua'
}
