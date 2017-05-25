local suite = test.declare("filterfromvariant.lua")

local pm = premake.packagemanager

local function tableequals(a, b)
	if a == b then
		return true
	end
	if a == nil or b == nil then
		return false
	end
	for k, v in pairs(a) do
		if type(v) == 'table' then
			if not tableequals(b[k], v) then
				return false
			end
		elseif b[k] ~= v then
			return false
		end
	end
	return true
end


local function isTableEqual(a, b)
	if a == b then
		return
	end

	if not tableequals(a,b) or not tableequals(b,a) then
		test.fail("expected value:\n%s\ngot:\n%s\n", table.tostring(a, 2), table.tostring(b, 2))
	end
end


function suite.setup()
end

function suite.testVariant_android()
	isTableEqual({system = 'android'}, pm.filterFromVariant('android'))
end

function suite.testVariant_android_armeabi()
	isTableEqual({system = 'android', tags = {'armeabi'}}, pm.filterFromVariant('android-armeabi'))
end

function suite.testVariant_android_armeabi_gcc48()
	isTableEqual({system = 'android', toolset = 'gcc48', tags = {'armeabi'}}, pm.filterFromVariant('android-armeabi-gcc48'))
end

function suite.testVariant_android_armeabi_gcc48_debug()
	isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'debug', tags = {'armeabi'}}, pm.filterFromVariant('android-armeabi-gcc48-debug'))
end

function suite.testVariant_android_armeabi_gcc48_release()
	isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'release', tags = {'armeabi'}}, pm.filterFromVariant('android-armeabi-gcc48-release'))
end

function suite.testVariant_android_armeabiv7a()
	isTableEqual({system = 'android', tags = {'armeabiv7a'}}, pm.filterFromVariant('android-armeabiv7a'))
end

function suite.testVariant_android_armeabiv7a_gcc48()
	isTableEqual({system = 'android', toolset = 'gcc48', tags = {'armeabiv7a'}}, pm.filterFromVariant('android-armeabiv7a-gcc48'))
end

function suite.testVariant_android_armeabiv7a_gcc48_debug()
	isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'debug', tags = {'armeabiv7a'}}, pm.filterFromVariant('android-armeabiv7a-gcc48-debug'))
end

function suite.testVariant_android_armeabiv7a_gcc48_release()
	isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'release', tags = {'armeabiv7a'}}, pm.filterFromVariant('android-armeabiv7a-gcc48-release'))
end

function suite.testVariant_android_i386()
	isTableEqual({system = 'android', architecture = 'x86'}, pm.filterFromVariant('android-i386'))
end

function suite.testVariant_android_i386_clang_debug()
	isTableEqual({system = 'android', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('android-i386-clang-debug'))
end

function suite.testVariant_android_i386_gcc48_release()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('android-i386-gcc48-release'))
end

function suite.testVariant_android_mips()
	isTableEqual({system = 'android', architecture = 'mips'}, pm.filterFromVariant('android-mips'))
end

function suite.testVariant_android_mips_gcc48()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips'}, pm.filterFromVariant('android-mips-gcc48'))
end

function suite.testVariant_android_mips_gcc48_debug()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips', configurations = 'debug'}, pm.filterFromVariant('android-mips-gcc48-debug'))
end

function suite.testVariant_android_mips_gcc48_release()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips', configurations = 'release'}, pm.filterFromVariant('android-mips-gcc48-release'))
end

function suite.testVariant_android_x86()
	isTableEqual({system = 'android', architecture = 'x86'}, pm.filterFromVariant('android-x86'))
end

function suite.testVariant_android_x86_gcc48()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86'}, pm.filterFromVariant('android-x86-gcc48'))
end

function suite.testVariant_android_x86_gcc48_debug()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('android-x86-gcc48-debug'))
end

function suite.testVariant_android_x86_gcc48_release()
	isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('android-x86-gcc48-release'))
end

function suite.testVariant_arm_gcc48_android8()
	isTableEqual({toolset = 'gcc48', architecture = 'ARM', tags = {'android8'}}, pm.filterFromVariant('arm-gcc48-android8'))
end

function suite.testVariant_cell_ppu()
	isTableEqual({tags = {'cell', 'ppu'}}, pm.filterFromVariant('cell-ppu'))
end

function suite.testVariant_centos7_x86_64()
	isTableEqual({system = 'centos7', architecture = 'x86_64'}, pm.filterFromVariant('centos7-x86_64'))
end

function suite.testVariant_curl_7_50_3()
	isTableEqual({tags = {'curl', '7.50.3'}}, pm.filterFromVariant('curl-7.50.3'))
end

function suite.testVariant_darwin()
	isTableEqual({system = 'macosx'}, pm.filterFromVariant('darwin'))
end

function suite.testVariant_darwing_i386_clang_debug()
	isTableEqual({toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'darwing'}}, pm.filterFromVariant('darwing-i386-clang-debug'))
end

function suite.testVariant_darwin_i386()
	isTableEqual({system = 'macosx', architecture = 'x86'}, pm.filterFromVariant('darwin-i386'))
end

function suite.testVariant_darwin_i386_anticheat()
	isTableEqual({system = 'macosx', architecture = 'x86', tags = {'anticheat'}}, pm.filterFromVariant('darwin-i386-anticheat'))
end

function suite.testVariant_darwin_i386_clang()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86'}, pm.filterFromVariant('darwin-i386-clang'))
end

function suite.testVariant_darwin_i386_clang_6_0_release()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'6.0'}}, pm.filterFromVariant('darwin-i386-clang-6.0-release'))
end

function suite.testVariant_darwin_i386_clang_6_0_release_libc__()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'6.0', 'libc++'}}, pm.filterFromVariant('darwin-i386-clang-6.0-release-libc++'))
end

function suite.testVariant_darwin_i386_clang_debug()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('darwin-i386-clang-debug'))
end

function suite.testVariant_darwin_i386_clang_debug_blz()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('darwin-i386-clang-debug-blz'))
end

function suite.testVariant_darwin_i386_clang_debug_libc__()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'libc++'}}, pm.filterFromVariant('darwin-i386-clang-debug-libc++'))
end

function suite.testVariant_darwin_i386_clang_debug_std()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('darwin-i386-clang-debug-std'))
end

function suite.testVariant_darwin_i386_clang_debug_stl()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'stl'}}, pm.filterFromVariant('darwin-i386-clang-debug-stl'))
end

function suite.testVariant_darwin_i386_clang_release()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('darwin-i386-clang-release'))
end

function suite.testVariant_darwin_i386_clang_release_blz()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('darwin-i386-clang-release-blz'))
end

function suite.testVariant_darwin_i386_clang_release_libc__()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'libc++'}}, pm.filterFromVariant('darwin-i386-clang-release-libc++'))
end

function suite.testVariant_darwin_i386_clang_release_std()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('darwin-i386-clang-release-std'))
end

function suite.testVariant_darwin_i386_clang_release_stl()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'stl'}}, pm.filterFromVariant('darwin-i386-clang-release-stl'))
end

function suite.testVariant_darwin_i386_debug()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('darwin-i386-debug'))
end

function suite.testVariant_darwin_i386_debug_std()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('darwin-i386-debug-std'))
end

function suite.testVariant_darwin_i386_gcc42_debug()
	isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('darwin-i386-gcc42-debug'))
end

function suite.testVariant_darwin_i386_gcc42_release()
	isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('darwin-i386-gcc42-release'))
end

function suite.testVariant_darwin_i386_libcpp_debug()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug', tags = {'libcpp'}}, pm.filterFromVariant('darwin-i386-libcpp-debug'))
end

function suite.testVariant_darwin_i386_libcpp_release()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release', tags = {'libcpp'}}, pm.filterFromVariant('darwin-i386-libcpp-release'))
end

function suite.testVariant_darwin_i386_pic()
	isTableEqual({system = 'macosx', architecture = 'x86', tags = {'pic'}}, pm.filterFromVariant('darwin-i386-pic'))
end

function suite.testVariant_darwin_i386_public()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'public'}, pm.filterFromVariant('darwin-i386-public'))
end

function suite.testVariant_darwin_i386_release()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('darwin-i386-release'))
end

function suite.testVariant_darwin_i386_release_std()
	isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('darwin-i386-release-std'))
end

function suite.testVariant_darwin_x86_64()
	isTableEqual({system = 'macosx', architecture = 'x86_64'}, pm.filterFromVariant('darwin-x86_64'))
end

function suite.testVariant_darwin_x86_64_clang()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64'}, pm.filterFromVariant('darwin-x86_64-clang'))
end

function suite.testVariant_darwin_x86_64_clang_debug()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('darwin-x86_64-clang-debug'))
end

function suite.testVariant_darwin_x86_64_clang_debug_blz()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('darwin-x86_64-clang-debug-blz'))
end

function suite.testVariant_darwin_x86_64_clang_debug_libc__()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'libc++'}}, pm.filterFromVariant('darwin-x86_64-clang-debug-libc++'))
end

function suite.testVariant_darwin_x86_64_clang_debug_std()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('darwin-x86_64-clang-debug-std'))
end

function suite.testVariant_darwin_x86_64_clang_debug_stl()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, pm.filterFromVariant('darwin-x86_64-clang-debug-stl'))
end

function suite.testVariant_darwin_x86_64_clang_release()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('darwin-x86_64-clang-release'))
end

function suite.testVariant_darwin_x86_64_clang_release_blz()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('darwin-x86_64-clang-release-blz'))
end

function suite.testVariant_darwin_x86_64_clang_release_libc__()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'libc++'}}, pm.filterFromVariant('darwin-x86_64-clang-release-libc++'))
end

function suite.testVariant_darwin_x86_64_clang_release_std()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('darwin-x86_64-clang-release-std'))
end

function suite.testVariant_darwin_x86_64_clang_release_stl()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, pm.filterFromVariant('darwin-x86_64-clang-release-stl'))
end

function suite.testVariant_darwin_x86_64_debug()
	isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('darwin-x86_64-debug'))
end

function suite.testVariant_darwin_x86_64_libcpp_debug()
	isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'debug', tags = {'libcpp'}}, pm.filterFromVariant('darwin-x86_64-libcpp-debug'))
end

function suite.testVariant_darwin_x86_64_libcpp_release()
	isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release', tags = {'libcpp'}}, pm.filterFromVariant('darwin-x86_64-libcpp-release'))
end

function suite.testVariant_darwin_x86_64_pic()
	isTableEqual({system = 'macosx', architecture = 'x86_64', tags = {'pic'}}, pm.filterFromVariant('darwin-x86_64-pic'))
end

function suite.testVariant_darwin_x86_64_release()
	isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('darwin-x86_64-release'))
end

function suite.testVariant_darwin_x86_64_release_std()
	isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('darwin-x86_64-release-std'))
end

function suite.testVariant_durango_vc110_debug()
	isTableEqual({system = 'durango', toolset = 'msc-v110', configurations = 'debug'}, pm.filterFromVariant('durango-vc110-debug'))
end

function suite.testVariant_durango_vc110_release()
	isTableEqual({system = 'durango', toolset = 'msc-v110', configurations = 'release'}, pm.filterFromVariant('durango-vc110-release'))
end

function suite.testVariant_durango_vc140_debug()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'debug'}, pm.filterFromVariant('durango-vc140-debug'))
end

function suite.testVariant_durango__vc140_debug()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'debug'}, pm.filterFromVariant('durango--vc140-debug'))
end

function suite.testVariant_durango_vc140_release()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'release'}, pm.filterFromVariant('durango-vc140-release'))
end

function suite.testVariant_durango__vc140_release()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'release'}, pm.filterFromVariant('durango--vc140-release'))
end

function suite.testVariant_example()
	isTableEqual({tags = {'example'}}, pm.filterFromVariant('example'))
end

function suite.testVariant_ios_arm64()
	isTableEqual({system = 'ios', architecture = 'ARM64'}, pm.filterFromVariant('ios-arm64'))
end

function suite.testVariant_ios_arm64_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64'}, pm.filterFromVariant('ios-arm64-clang'))
end

function suite.testVariant_ios_arm64_clang_debug()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64', configurations = 'debug'}, pm.filterFromVariant('ios-arm64-clang-debug'))
end

function suite.testVariant_ios_arm64_clang_public()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64', configurations = 'public'}, pm.filterFromVariant('ios-arm64-clang-public'))
end

function suite.testVariant_ios_arm64_clang_release()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64', configurations = 'release'}, pm.filterFromVariant('ios-arm64-clang-release'))
end

function suite.testVariant_ios_armv6_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv6'}, pm.filterFromVariant('ios-armv6-clang'))
end

function suite.testVariant_ios_armv7()
	isTableEqual({system = 'ios', architecture = 'ARMv7'}, pm.filterFromVariant('ios-armv7'))
end

function suite.testVariant_ios_armv7_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7'}, pm.filterFromVariant('ios-armv7-clang'))
end

function suite.testVariant_ios_armv7_clang_debug()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7', configurations = 'debug'}, pm.filterFromVariant('ios-armv7-clang-debug'))
end

function suite.testVariant_ios_armv7_clang_public()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7', configurations = 'public'}, pm.filterFromVariant('ios-armv7-clang-public'))
end

function suite.testVariant_ios_armv7_clang_release()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7', configurations = 'release'}, pm.filterFromVariant('ios-armv7-clang-release'))
end

function suite.testVariant_ios_armv7s()
	isTableEqual({system = 'ios', architecture = 'ARMv7s'}, pm.filterFromVariant('ios-armv7s'))
end

function suite.testVariant_ios_armv7s_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s'}, pm.filterFromVariant('ios-armv7s-clang'))
end

function suite.testVariant_ios_armv7s_clang_debug()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s', configurations = 'debug'}, pm.filterFromVariant('ios-armv7s-clang-debug'))
end

function suite.testVariant_ios_armv7s_clang_public()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s', configurations = 'public'}, pm.filterFromVariant('ios-armv7s-clang-public'))
end

function suite.testVariant_ios_armv7s_clang_release()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s', configurations = 'release'}, pm.filterFromVariant('ios-armv7s-clang-release'))
end

function suite.testVariant_ios_i386()
	isTableEqual({system = 'ios', architecture = 'x86'}, pm.filterFromVariant('ios-i386'))
end

function suite.testVariant_ios_i386_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86'}, pm.filterFromVariant('ios-i386-clang'))
end

function suite.testVariant_ios_i386_clang_debug()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('ios-i386-clang-debug'))
end

function suite.testVariant_ios_i386_clang_public()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86', configurations = 'public'}, pm.filterFromVariant('ios-i386-clang-public'))
end

function suite.testVariant_ios_i386_clang_release()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('ios-i386-clang-release'))
end

function suite.testVariant_ios_x86_64()
	isTableEqual({system = 'ios', architecture = 'x86_64'}, pm.filterFromVariant('ios-x86_64'))
end

function suite.testVariant_ios_x86_64_clang()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64'}, pm.filterFromVariant('ios-x86_64-clang'))
end

function suite.testVariant_ios_x86_64_clang_debug()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('ios-x86_64-clang-debug'))
end

function suite.testVariant_ios_x86_64_clang_public()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64', configurations = 'public'}, pm.filterFromVariant('ios-x86_64-clang-public'))
end

function suite.testVariant_ios_x86_64_clang_release()
	isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('ios-x86_64-clang-release'))
end

function suite.testVariant_linux()
	isTableEqual({system = 'linux'}, pm.filterFromVariant('linux'))
end

function suite.testVariant_linux_i386()
	isTableEqual({system = 'linux', architecture = 'x86'}, pm.filterFromVariant('linux-i386'))
end

function suite.testVariant_linux_i386_gcc41_debug()
	isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('linux-i386-gcc41-debug'))
end

function suite.testVariant_linux_i386_gcc41_release()
	isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('linux-i386-gcc41-release'))
end

function suite.testVariant_linux_i386_gcc44_debug()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('linux-i386-gcc44-debug'))
end

function suite.testVariant_linux_i386_gcc44_release()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('linux-i386-gcc44-release'))
end

function suite.testVariant_linux_i386_gcc47()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86'}, pm.filterFromVariant('linux-i386-gcc47'))
end

function suite.testVariant_linux_i386_gcc47_debug()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('linux-i386-gcc47-debug'))
end

function suite.testVariant_linux_i386_gcc47_release()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('linux-i386-gcc47-release'))
end

function suite.testVariant_linux_i386_gcc48_debug()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('linux-i386-gcc48-debug'))
end

function suite.testVariant_linux_i386_gcc48_release()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('linux-i386-gcc48-release'))
end

function suite.testVariant_linux_i386_gcc_debug()
	isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('linux-i386-gcc-debug'))
end

function suite.testVariant_linux_i386_gcc_release()
	isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('linux-i386-gcc-release'))
end

function suite.testVariant_linux_x64()
	isTableEqual({system = 'linux', architecture = 'x86_64'}, pm.filterFromVariant('linux-x64'))
end

function suite.testVariant_linux_x86_64()
	isTableEqual({system = 'linux', architecture = 'x86_64'}, pm.filterFromVariant('linux-x86_64'))
end

function suite.testVariant_linux_x86_64_debug()
	isTableEqual({system = 'linux', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_4_debug()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc4.4-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_4_release()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc4.4-release'))
end

function suite.testVariant_linux_x86_64_gcc4_8_debug()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc4.8-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_8_release()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc4.8-release'))
end

function suite.testVariant_linux_x86_64_gcc41_debug()
	isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc41-debug'))
end

function suite.testVariant_linux_x86_64_gcc41_release()
	isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc41-release'))
end

function suite.testVariant_linux_x86_64_gcc44()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64'}, pm.filterFromVariant('linux-x86_64-gcc44'))
end

function suite.testVariant_linux_x86_64_gcc44_debug()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc44-debug'))
end

function suite.testVariant_linux_x86_64_gcc44_debug_blz()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('linux-x86_64-gcc44-debug-blz'))
end

function suite.testVariant_linux_x86_64_gcc44_debug_stl()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, pm.filterFromVariant('linux-x86_64-gcc44-debug-stl'))
end

function suite.testVariant_linux_x86_64_gcc44_release()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc44-release'))
end

function suite.testVariant_linux_x86_64_gcc44_release_()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', tags = {'release_'}}, pm.filterFromVariant('linux-x86_64-gcc44-release_'))
end

function suite.testVariant_linux_x86_64_gcc44_release_blz()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('linux-x86_64-gcc44-release-blz'))
end

function suite.testVariant_linux_x86_64_gcc44_release_stl()
	isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, pm.filterFromVariant('linux-x86_64-gcc44-release-stl'))
end

function suite.testVariant_linux_x86_64_gcc47()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64'}, pm.filterFromVariant('linux-x86_64-gcc47'))
end

function suite.testVariant_linux_x86_64_gcc47_debug()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc47-debug'))
end

function suite.testVariant_linux_x86_64_gcc47_release()
	isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc47-release'))
end

function suite.testVariant_linux_x86_64_gcc48()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64'}, pm.filterFromVariant('linux-x86_64-gcc48'))
end

function suite.testVariant_linux_x86_64_gcc48_debug()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc48-debug'))
end

function suite.testVariant_linux_x86_64_gcc48_debug_blz()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('linux-x86_64-gcc48-debug-blz'))
end

function suite.testVariant_linux_x86_64_gcc48_release()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc48-release'))
end

function suite.testVariant_linux_x86_64_gcc48_release_blz()
	isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('linux-x86_64-gcc48-release-blz'))
end

function suite.testVariant_linux_x86_64_gcc_debug()
	isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('linux-x86_64-gcc-debug'))
end

function suite.testVariant_linux_x86_64_gcc_release()
	isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-gcc-release'))
end

function suite.testVariant_linux_x86_64_pic()
	isTableEqual({system = 'linux', architecture = 'x86_64', tags = {'pic'}}, pm.filterFromVariant('linux-x86_64-pic'))
end

function suite.testVariant_linux_x86_64_release()
	isTableEqual({system = 'linux', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('linux-x86_64-release'))
end

function suite.testVariant_mips_gcc48_android9()
	isTableEqual({toolset = 'gcc48', architecture = 'mips', tags = {'android9'}}, pm.filterFromVariant('mips-gcc48-android9'))
end

function suite.testVariant_ndk_r9c_windows_x86_64()
	isTableEqual({system = 'windows', architecture = 'x86_64', tags = {'ndk', 'r9c'}}, pm.filterFromVariant('ndk-r9c-windows-x86_64'))
end

function suite.testVariant_noarch()
	isTableEqual({}, pm.filterFromVariant('noarch'))
end

function suite.testVariant_noarch_old()
	isTableEqual({tags = {'noarch_old'}}, pm.filterFromVariant('noarch_old'))
end

function suite.testVariant_noarch_original()
	isTableEqual({tags = {'noarch_original'}}, pm.filterFromVariant('noarch_original'))
end

function suite.testVariant_noarch_orig()
	isTableEqual({tags = {'orig'}}, pm.filterFromVariant('noarch-orig'))
end

function suite.testVariant_noarch_src()
	isTableEqual({tags = {'src'}}, pm.filterFromVariant('noarch-src'))
end

function suite.testVariant_orbis___debug()
	isTableEqual({system = 'orbis', configurations = 'debug'}, pm.filterFromVariant('orbis---debug'))
end

function suite.testVariant_orbis___release()
	isTableEqual({system = 'orbis', configurations = 'release'}, pm.filterFromVariant('orbis---release'))
end

function suite.testVariant_orbis_vc110_debug()
	isTableEqual({system = 'orbis', toolset = 'msc-v110', configurations = 'debug'}, pm.filterFromVariant('orbis-vc110-debug'))
end

function suite.testVariant_orbis_vc110_release()
	isTableEqual({system = 'orbis', toolset = 'msc-v110', configurations = 'release'}, pm.filterFromVariant('orbis-vc110-release'))
end

function suite.testVariant_orbis_vc120_debug()
	isTableEqual({system = 'orbis', toolset = 'msc-v120', configurations = 'debug'}, pm.filterFromVariant('orbis-vc120-debug'))
end

function suite.testVariant_orbis_vc120_release()
	isTableEqual({system = 'orbis', toolset = 'msc-v120', configurations = 'release'}, pm.filterFromVariant('orbis-vc120-release'))
end

function suite.testVariant_orbis_vc140_debug()
	isTableEqual({system = 'orbis', toolset = 'msc-v140', configurations = 'debug'}, pm.filterFromVariant('orbis-vc140-debug'))
end

function suite.testVariant_orbis_vc140_release()
	isTableEqual({system = 'orbis', toolset = 'msc-v140', configurations = 'release'}, pm.filterFromVariant('orbis-vc140-release'))
end

function suite.testVariant_osx()
	isTableEqual({system = 'macosx'}, pm.filterFromVariant('osx'))
end

function suite.testVariant_osx_i386_clang()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86'}, pm.filterFromVariant('osx-i386-clang'))
end

function suite.testVariant_osx_i386_gcc42()
	isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86'}, pm.filterFromVariant('osx-i386-gcc42'))
end

function suite.testVariant_osx_i386_gcc42_debug()
	isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('osx-i386-gcc42-debug'))
end

function suite.testVariant_osx_i386_gcc42_release()
	isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('osx-i386-gcc42-release'))
end

function suite.testVariant_osx_x86_64_clang()
	isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64'}, pm.filterFromVariant('osx-x86_64-clang'))
end

function suite.testVariant_package()
	isTableEqual({tags = {'package'}}, pm.filterFromVariant('package'))
end

function suite.testVariant_posix_x86_64_gcc44_debug()
	isTableEqual({system = 'posix', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('posix-x86_64-gcc44-debug'))
end

function suite.testVariant_posix_x86_64_gcc44_release()
	isTableEqual({system = 'posix', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('posix-x86_64-gcc44-release'))
end

function suite.testVariant_posix_x86_64_gcc48_debug()
	isTableEqual({system = 'posix', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('posix-x86_64-gcc48-debug'))
end

function suite.testVariant_posix_x86_64_gcc48_release()
	isTableEqual({system = 'posix', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('posix-x86_64-gcc48-release'))
end

function suite.testVariant_premake_generated_vs2015()
	isTableEqual({toolset = 'msc-v140', tags = {'premake', 'generated'}}, pm.filterFromVariant('premake-generated-vs2015'))
end

function suite.testVariant_ps3()
	isTableEqual({tags = {'ps3'}}, pm.filterFromVariant('ps3'))
end

function suite.testVariant_ps3_debug()
	isTableEqual({configurations = 'debug', tags = {'ps3'}}, pm.filterFromVariant('ps3-debug'))
end

function suite.testVariant_ps3_release()
	isTableEqual({configurations = 'release', tags = {'ps3'}}, pm.filterFromVariant('ps3-release'))
end

function suite.testVariant_ps4_debug()
	isTableEqual({system = 'orbis', configurations = 'debug'}, pm.filterFromVariant('ps4-debug'))
end

function suite.testVariant_ps4_profile()
	isTableEqual({system = 'orbis', configurations = 'profile'}, pm.filterFromVariant('ps4-profile'))
end

function suite.testVariant_ps4_release()
	isTableEqual({system = 'orbis', configurations = 'release'}, pm.filterFromVariant('ps4-release'))
end

function suite.testVariant_Release_1_0_5576_39384()
	isTableEqual({tags = {'Release.1.0.5576.39384'}}, pm.filterFromVariant('Release.1.0.5576.39384'))
end

function suite.testVariant_universal()
	isTableEqual({}, pm.filterFromVariant('universal'))
end

function suite.testVariant_win32()
	isTableEqual({system = 'windows'}, pm.filterFromVariant('win32'))
end

function suite.testVariant_win32_development()
	isTableEqual({system = 'windows', configurations = 'development'}, pm.filterFromVariant('win32-development'))
end

function suite.testVariant_win32_i386()
	isTableEqual({system = 'windows', architecture = 'x86'}, pm.filterFromVariant('win32-i386'))
end

function suite.testVariant_win32_i386_anticheat()
	isTableEqual({system = 'windows', architecture = 'x86', tags = {'anticheat'}}, pm.filterFromVariant('win32-i386-anticheat'))
end

function suite.testVariant_win32_i386_debug()
	isTableEqual({system = 'windows', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('win32-i386-debug'))
end

function suite.testVariant_win32_i386_public()
	isTableEqual({system = 'windows', architecture = 'x86', configurations = 'public'}, pm.filterFromVariant('win32-i386-public'))
end

function suite.testVariant_win32_i386_release()
	isTableEqual({system = 'windows', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('win32-i386-release'))
end

function suite.testVariant_win32_i386_vc100()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86'}, pm.filterFromVariant('win32-i386-vc100'))
end

function suite.testVariant_win32_i386_vc100_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('win32-i386-vc100-debug'))
end

function suite.testVariant_win32_i386_vc100_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc100-debug-blz'))
end

function suite.testVariant_win32_i386_vc100_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc100-debug-mt'))
end

function suite.testVariant_win32_i386_vc100_debug_mt_noidn()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'mt', 'noidn'}}, pm.filterFromVariant('win32-i386-vc100-debug-mt-noidn'))
end

function suite.testVariant_win32_i386_vc100_debug_s()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'s'}}, pm.filterFromVariant('win32-i386-vc100-debug-s'))
end

function suite.testVariant_win32_i386_vc100_debug_static()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'static'}}, pm.filterFromVariant('win32-i386-vc100-debug-static'))
end

function suite.testVariant_win32_i386_vc100_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc100-debug-std'))
end

function suite.testVariant_win32_i386_vc100_debug_stl()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'stl'}}, pm.filterFromVariant('win32-i386-vc100-debug-stl'))
end

function suite.testVariant_win32_i386_vc100_public()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'public'}, pm.filterFromVariant('win32-i386-vc100-public'))
end

function suite.testVariant_win32_i386_vc100_release()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('win32-i386-vc100-release'))
end

function suite.testVariant_win32_i386_vc100_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc100-release-blz'))
end

function suite.testVariant_win32_i386_vc100_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc100-release-mt'))
end

function suite.testVariant_win32_i386_vc100_release_mt_noidn()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'mt', 'noidn'}}, pm.filterFromVariant('win32-i386-vc100-release-mt-noidn'))
end

function suite.testVariant_win32_i386_vc100_release_s()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'s'}}, pm.filterFromVariant('win32-i386-vc100-release-s'))
end

function suite.testVariant_win32_i386_vc100_release_static()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'static'}}, pm.filterFromVariant('win32-i386-vc100-release-static'))
end

function suite.testVariant_win32_i386_vc100_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc100-release-std'))
end

function suite.testVariant_win32_i386_vc100_release_stl()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'stl'}}, pm.filterFromVariant('win32-i386-vc100-release-stl'))
end

function suite.testVariant_win32_i386_vc110()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86'}, pm.filterFromVariant('win32-i386-vc110'))
end

function suite.testVariant_win32_i386_vc110_xp_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc110_xp-debug-std'))
end

function suite.testVariant_win32_i386_vc110_xp_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc110_xp-release-std'))
end

function suite.testVariant_win32_i386_vc110_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('win32-i386-vc110-debug'))
end

function suite.testVariant_win32_i386_vc110_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc110-debug-blz'))
end

function suite.testVariant_win32_i386_vc110_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc110-debug-mt'))
end

function suite.testVariant_win32_i386_vc110_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc110-debug-std'))
end

function suite.testVariant_win32_i386_vc110_release()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('win32-i386-vc110-release'))
end

function suite.testVariant_win32_i386_vc110_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc110-release-blz'))
end

function suite.testVariant_win32_i386_vc110_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc110-release-mt'))
end

function suite.testVariant_win32_i386_vc110_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc110-release-std'))
end

function suite.testVariant_win32_i386_vc120_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('win32-i386-vc120-debug'))
end

function suite.testVariant_win32_i386_vc120_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc120-debug-blz'))
end

function suite.testVariant_win32_i386_vc120_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc120-debug-mt'))
end

function suite.testVariant_win32_i386_vc120_public()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'public'}, pm.filterFromVariant('win32-i386-vc120-public'))
end

function suite.testVariant_win32_i386_vc120_release()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('win32-i386-vc120-release'))
end

function suite.testVariant_win32_i386_vc120_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-i386-vc120-release-blz'))
end

function suite.testVariant_win32_i386_vc120_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc120-release-mt'))
end

function suite.testVariant_win32_i386_vc140()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86'}, pm.filterFromVariant('win32-i386-vc140'))
end

function suite.testVariant_win32_i386_vc140_xp_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc140_xp-debug-std'))
end

function suite.testVariant_win32_i386_vc140_xp_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-i386-vc140_xp-release-std'))
end

function suite.testVariant_win32_i386_vc140_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'debug'}, pm.filterFromVariant('win32-i386-vc140-debug'))
end

function suite.testVariant_win32_i386_vc140_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc140-debug-mt'))
end

function suite.testVariant_win32_i386_vc140_release()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'release'}, pm.filterFromVariant('win32-i386-vc140-release'))
end

function suite.testVariant_win32_i386_vc140_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-i386-vc140-release-mt'))
end

function suite.testVariant_win32_i386_x64_debug()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-i386-x64-debug'))
end

function suite.testVariant_win32_i386_x64_release()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-i386-x64-release'))
end

function suite.testVariant_win32_production()
	isTableEqual({system = 'windows', configurations = 'production'}, pm.filterFromVariant('win32-production'))
end

function suite.testVariant_win32_vc100()
	isTableEqual({system = 'windows', toolset = 'msc-v100'}, pm.filterFromVariant('win32-vc100'))
end

function suite.testVariant_win32_vc110()
	isTableEqual({system = 'windows', toolset = 'msc-v110'}, pm.filterFromVariant('win32-vc110'))
end

function suite.testVariant_win32_vc120()
	isTableEqual({system = 'windows', toolset = 'msc-v120'}, pm.filterFromVariant('win32-vc120'))
end

function suite.testVariant_win32_vc140()
	isTableEqual({system = 'windows', toolset = 'msc-v140'}, pm.filterFromVariant('win32-vc140'))
end

function suite.testVariant_win32_x64_vc100_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x64-vc100-debug'))
end

function suite.testVariant_win32_x64_vc100_release()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x64-vc100-release'))
end

function suite.testVariant_win32_x64_vc110_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x64-vc110-debug'))
end

function suite.testVariant_win32_x64_vc110_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-x64-vc110-debug-std'))
end

function suite.testVariant_win32_x64_vc110_release()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x64-vc110-release'))
end

function suite.testVariant_win32_x64_vc110_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-x64-vc110-release-std'))
end

function suite.testVariant_win32_x64_vc140_xp_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-x64-vc140_xp-debug-std'))
end

function suite.testVariant_win32_x64_vc140_xp_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-x64-vc140_xp-release-std'))
end

function suite.testVariant_win32_x64_vc140_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x64-vc140-debug'))
end

function suite.testVariant_win32_x64_vc140_release()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x64-vc140-release'))
end

function suite.testVariant_win32_x86_64()
	isTableEqual({system = 'windows', architecture = 'x86_64'}, pm.filterFromVariant('win32-x86_64'))
end

function suite.testVariant_win32_x86_64_anticheat()
	isTableEqual({system = 'windows', architecture = 'x86_64', tags = {'anticheat'}}, pm.filterFromVariant('win32-x86_64-anticheat'))
end

function suite.testVariant_win32_x86_64_debug()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x86_64-debug'))
end

function suite.testVariant_win32_x86_64_profile()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'profile'}, pm.filterFromVariant('win32-x86_64-profile'))
end

function suite.testVariant_win32_x86_64_public()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'public'}, pm.filterFromVariant('win32-x86_64-public'))
end

function suite.testVariant_win32_x86_64_release()
	isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x86_64-release'))
end

function suite.testVariant_win32_x86_64_vc100()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64'}, pm.filterFromVariant('win32-x86_64-vc100'))
end

function suite.testVariant_win32_x86_64_vc100_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x86_64-vc100-debug'))
end

function suite.testVariant_win32_x86_64_vc100_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc100-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc100_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc100-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc100_debug_static()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'static'}}, pm.filterFromVariant('win32-x86_64-vc100-debug-static'))
end

function suite.testVariant_win32_x86_64_vc100_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc100-debug-std'))
end

function suite.testVariant_win32_x86_64_vc100_debug_stl()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, pm.filterFromVariant('win32-x86_64-vc100-debug-stl'))
end

function suite.testVariant_win32_x86_64_vc100_public()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'public'}, pm.filterFromVariant('win32-x86_64-vc100-public'))
end

function suite.testVariant_win32_x86_64_vc100_release()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x86_64-vc100-release'))
end

function suite.testVariant_win32_x86_64_vc100_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc100-release-blz'))
end

function suite.testVariant_win32_x86_64_vc100_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc100-release-mt'))
end

function suite.testVariant_win32_x86_64_vc100_release_static()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'static'}}, pm.filterFromVariant('win32-x86_64-vc100-release-static'))
end

function suite.testVariant_win32_x86_64_vc100_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc100-release-std'))
end

function suite.testVariant_win32_x86_64_vc100_release_stl()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, pm.filterFromVariant('win32-x86_64-vc100-release-stl'))
end

function suite.testVariant_win32_x86_64_vc110_xp_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc110_xp-debug-std'))
end

function suite.testVariant_win32_x86_64_vc110_xp_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc110_xp-release-std'))
end

function suite.testVariant_win32_x86_64_vc110_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x86_64-vc110-debug'))
end

function suite.testVariant_win32_x86_64_vc110_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc110-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc110_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc110-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc110_debug_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc110-debug-std'))
end

function suite.testVariant_win32_x86_64_vc110_release()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x86_64-vc110-release'))
end

function suite.testVariant_win32_x86_64_vc110_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc110-release-blz'))
end

function suite.testVariant_win32_x86_64_vc110_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc110-release-mt'))
end

function suite.testVariant_win32_x86_64_vc110_release_std()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, pm.filterFromVariant('win32-x86_64-vc110-release-std'))
end

function suite.testVariant_win32_x86_64_vc120_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x86_64-vc120-debug'))
end

function suite.testVariant_win32_x86_64_vc120_debug_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc120-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc120_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc120-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc120_release()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x86_64-vc120-release'))
end

function suite.testVariant_win32_x86_64_vc120_release_blz()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, pm.filterFromVariant('win32-x86_64-vc120-release-blz'))
end

function suite.testVariant_win32_x86_64_vc120_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc120-release-mt'))
end

function suite.testVariant_win32_x86_64_vc140_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win32-x86_64-vc140-debug'))
end

function suite.testVariant_win32_x86_64_vc140_debug_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc140-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc140_release()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win32-x86_64-vc140-release'))
end

function suite.testVariant_win32_x86_64_vc140_release_mt()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, pm.filterFromVariant('win32-x86_64-vc140-release-mt'))
end

function suite.testVariant_win32_xi386_vc120_release()
	isTableEqual({system = 'windows', toolset = 'msc-v120', configurations = 'release', tags = {'xi386'}}, pm.filterFromVariant('win32-xi386-vc120-release'))
end

function suite.testVariant_win64()
	isTableEqual({system = 'windows'}, pm.filterFromVariant('win64'))
end

function suite.testVariant_win64_x64()
	isTableEqual({system = 'windows', architecture = 'x86_64'}, pm.filterFromVariant('win64-x64'))
end

function suite.testVariant_win64_x64_vc100()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64'}, pm.filterFromVariant('win64-x64-vc100'))
end

function suite.testVariant_win64_x64_vc100_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win64-x64-vc100-debug'))
end

function suite.testVariant_win64_x64_vc100_release()
	isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win64-x64-vc100-release'))
end

function suite.testVariant_win64_x64_vc110()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64'}, pm.filterFromVariant('win64-x64-vc110'))
end

function suite.testVariant_win64_x64_vc110_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win64-x64-vc110-debug'))
end

function suite.testVariant_win64_x64_vc110_release()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win64-x64-vc110-release'))
end

function suite.testVariant_win64_x64_vc140()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64'}, pm.filterFromVariant('win64-x64-vc140'))
end

function suite.testVariant_wind32_i386()
	isTableEqual({architecture = 'x86', tags = {'wind32'}}, pm.filterFromVariant('wind32-i386'))
end

function suite.testVariant_windows()
	isTableEqual({system = 'windows'}, pm.filterFromVariant('windows'))
end

function suite.testVariant_win_x64_vc110_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win-x64-vc110-debug'))
end

function suite.testVariant_win_x64_vc110_release()
	isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win-x64-vc110-release'))
end

function suite.testVariant_win_x64_vc140_debug()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, pm.filterFromVariant('win-x64-vc140-debug'))
end

function suite.testVariant_win_x64_vc140_release()
	isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, pm.filterFromVariant('win-x64-vc140-release'))
end

function suite.testVariant_x64()
	isTableEqual({architecture = 'x86_64'}, pm.filterFromVariant('x64'))
end

function suite.testVariant_x86_gcc48_android9()
	isTableEqual({toolset = 'gcc48', architecture = 'x86', tags = {'android9'}}, pm.filterFromVariant('x86-gcc48-android9'))
end

function suite.testVariant_xbox()
	isTableEqual({tags = {'xbox'}}, pm.filterFromVariant('xbox'))
end

function suite.testVariant_xbox360()
	isTableEqual({system = 'xbox360'}, pm.filterFromVariant('xbox360'))
end

function suite.testVariant_xbox360_debug()
	isTableEqual({system = 'xbox360', configurations = 'debug'}, pm.filterFromVariant('xbox360-debug'))
end

function suite.testVariant_xbox360_release()
	isTableEqual({system = 'xbox360', configurations = 'release'}, pm.filterFromVariant('xbox360-release'))
end

function suite.testVariant_xboxone_debug()
	isTableEqual({system = 'durango', configurations = 'debug'}, pm.filterFromVariant('xboxone-debug'))
end

function suite.testVariant_xboxone_release()
	isTableEqual({system = 'durango', configurations = 'release'}, pm.filterFromVariant('xboxone-release'))
end

function suite.testVariant_xboxone_vc110_debug()
	isTableEqual({system = 'durango', toolset = 'msc-v110', configurations = 'debug'}, pm.filterFromVariant('xboxone-vc110-debug'))
end

function suite.testVariant_xboxone_vc110_release()
	isTableEqual({system = 'durango', toolset = 'msc-v110', configurations = 'release'}, pm.filterFromVariant('xboxone-vc110-release'))
end

function suite.testVariant_xboxone_vc140_debug()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'debug'}, pm.filterFromVariant('xboxone-vc140-debug'))
end

function suite.testVariant_xboxone_vc140_profile()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'profile'}, pm.filterFromVariant('xboxone-vc140-profile'))
end

function suite.testVariant_xboxone_vc140_release()
	isTableEqual({system = 'durango', toolset = 'msc-v140', configurations = 'release'}, pm.filterFromVariant('xboxone-vc140-release'))
end

function suite.testVariant_xnoarch()
	isTableEqual({tags = {'xnoarch'}}, pm.filterFromVariant('xnoarch'))
end

