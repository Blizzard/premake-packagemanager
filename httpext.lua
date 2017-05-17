---
-- Package management module
-- HTTP Extensions
-- Copyright (c) 2017 Blizzard Entertainment
---

if http == nil then
	return
end

function http.getVersion()
	return _PREMAKE_VERSION .. " (" .. _PREMAKE_COMMIT .. ")"
end


function http.getUser()
	return telemetry.getusername() or os.getenv('USERNAME') or os.getenv('LOGNAME') or '<unknown>'
end


function http.getComputer()
	return telemetry.gethostname() or os.getenv('COMPUTERNAME') or os.getenv('HOSTNAME') or '<unknown>'
end


function http.getHttpHeader()
	return {
		'X-Premake-Version: '   .. http.getVersion(),
		'X-Premake-User: '      .. http.getUser(),
		"X-Premake-Machine: "   .. http.getComputer(),
	}
end

function http.getJson(servers, link)
	for _, hostname in ipairs(servers) do
		local content, result_str, result_code = http.get(hostname .. link, { headers = http.getHttpHeader() })
		if content then
			local tbl = json.decode(content)
			if tbl ~= nil then
				return tbl
			end
		end
	end
	return nil
end
