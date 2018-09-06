local plugin_config = require ("kong.dao.migrations.helper").plugin_config_iterator

return {
	{
		name = "kong_custom_sample_plugin",
		up = [[  -- load the schema in cassandra for the plugin   cmd :  with kong migrations up
			CREATE TABLE IF NOT EXISTS sample_plugin(
				id uuid,
				consumer_id uuid,
				key text,
				created_at timestamp,
				PRIMARY KEY(id)
			);
			CREATE INDEX IF NOT EXISTS sample_plugin_key ON sample_plugin(key);
			CREATE INDEX IF NOT EXISTS sample_plugin_token ON sample_plugin(token); 
			]],
		down = [[   -- dissolve the database schema in cassandra  cmd : with kong migrations down
				DROP TABLE IF EXISTS sample_plugin;
				DROP INDEX IF EXISTS sample_plugin_key;
				DROP INDEX IF EXISTS sample_plugin_token;
			]]
	},
	{
		name = "kong_custom_sample_plugin_config_preflight_default",
		up = function (_, _, dao)  -- loaded only once to tie the plugin with the kong modules for setting up the configuration 
			for ok , config , update in plugin_config(dao, "sample-plugin") do
				if not ok then
				  return config
				end
				if config.run_on_preflight == nil then
					config.run_on_preflight = true
					local _, err = update (config)
					if err then
					  return err
					end
				end
			end
		     end,
		     down = function (_,_, dao) end   -- down shall be triggered while preflight isnt loaded successfully
	},
}
