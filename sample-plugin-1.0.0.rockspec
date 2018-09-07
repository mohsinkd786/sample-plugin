package = "sample-plugin"
version = "1.0.0"
supported_platforms = { "linux", "macos" }
source = {
	url = "git://github.com/mohsinkd786/sample-plugin"
}

description = {
	summary = "KONG Sample Plugin",
	license = "Anonymous",
	homepage = "",
	detailed = [[
		Simple Kong Custom Plugin	
	]]
}
dependencies = {
	"lua ~> 5.2"
}
build = {
	type = "builtin",
	modules = {
		[ "kong.plugins.sample_plugin.handler" ] = "handler.lua",
		[ "kong.plugins.sample_plugin.schema" ] = "schema.lua",
		[ "kong.plugins.sample_plugin.dao" ] = daos.lua,
		[ "kong.plugins.sample_plugin.access" ] = access.lua,
	}
}
