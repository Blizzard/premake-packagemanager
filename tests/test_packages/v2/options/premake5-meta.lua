return {
	includedirs = { 'include' },
	links       = { 'v2' },

	options     = {
		['multithreading'] = { kind = 'boolean', default = 'off', define='BC_ENABLE_MULTITHREADING' },
		['stacksize']      = { kind = 'integer', default = 1024, define='BC_STACK_SIZE' },
		['folder']         = { kind = 'path' }
	},

	premake     = 'options.lua'
}
