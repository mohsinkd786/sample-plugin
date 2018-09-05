local SCHEMA = {
		primary_key = { "id" },
		table = "sample_plugin",
		fields = {
				id = { type = "id" , dao_insert_value = true },
				consumer_id = { type = "id" , required = true , foreign = "consumers:id" },
				user = { type = "string" , dao_insert_value = true },
				token = { type = "string" , dao_insert_value = true},
				created_at = { type ="timestamp" , immutable = true, dao_insert_value = true }	
			},
}

return { 
	sample_plugin = SCHEMA 
	}
