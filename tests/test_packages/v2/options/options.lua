project 'v2'
	kind 'StaticLib'

	filter { 'multithreading:on' }
		defines { 'MULTITHREADING=1'}

	filter { 'multithreading:not on' }
		defines { 'MULTITHREADING=0'}

	filter {}

	defines {
		'STACKSIZE=%{getpackageoption("stacksize") or 1024}'
	}


