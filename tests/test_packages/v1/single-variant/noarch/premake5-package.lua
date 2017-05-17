return function ()
	package.current.links = { "v1" }
	package.current.includes = { "include" }

	project "v1"
		kind "StaticLib"
end
