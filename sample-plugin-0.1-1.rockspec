package = "sample-plugin"
version = "0.1-1"
supported_platforms = { "linux" }
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
	"lua ~> 5.1"
}
build = {
	type = "builtin",
	modules = {
		["kong.plugins.sample-plugin.migrations.cassandra"] = "kong/plugins/sample/migrations/cassandra.lua",
		["kong.plugins.sample-plugin.handler"] = "kong/plugins/sample-plugin/handler.lua",
    		["kong.plugins.sample-plugin.schema"] = "kong/plugins/sample-plugin/schema.lua",
    		["kong.plugins.sample-plugin.daos"] = "kong/plugins/sample-plugin/daos.lua",
		["kong.plugins.sample-plugin.access"] = "kong/plugins/sample-plugin/access.lua",	

	}
}
