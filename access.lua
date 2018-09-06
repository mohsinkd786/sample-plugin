local constants = require "kong.constants"
local _D = {}

local function add_consumer(consumer, credential)
	local const = constants.HEADERS
	local headers = {
				[const.CONSUMER_ID] = consumer.id,
				[const.CONSUMER_CUSTOM_ID] = tostring(consumer.custom_id),
				[const.CONSUMER_USERNAME] = consumer.username		
			}
	-- pushing the consumer as authenticated
	kong.ctx.shared.authenticated_consumer = consumer
	
	if credential then
		kong.ctx.shared.authenciated_credential = credential
		headers[const.CREDENTIAL] = credential
	
	else
		headers[conts.ANONYMOUS] = true
	end
	
	kong.service.request.set_headers(headers)	

end  -- end of add_consumer

-- login verify the consumer details with the service

local function login(config)
	if type(config.key_names) ~= "table" then
		kong.log.err("Config Key names not Set ")
		return nil, { status = 500 , message = "Configuration seems to be Incorrect" }
	end

	local key
	local body
	local token
	local headers = kong.request.get_headers()
	local query = kong.request.get_query()

	if config.key_in_body then
		local err
		body , err = kong.request.get_body()
		
		if err then
			kong.log.err(" Body not found ",err)
			return nil , { status = 400 , message = "Request Body couldn't be fetched" }
		end
	end

	-- traversal 
	for i = 1, #config.key_names do 
		local uname = config.key_names[i]
		-- lookup in headers
		local vals = headers[uname]
		
		if not vals then
			vals = query [uname]
		end
		
		if not vals and config.key_in_body then 
			vals = body[uname]
		end
		
		if type(vals) == "string" then
			key = vals
			
			if config.hide_credentials then
				query[uname] = nil
				kong.service.request.set_query(query)
				kong.service.request.clear_header(uname)
				
				if config.key_in_body then
					body[name] = nil
					kong.service.request.set_body(body)
				end
			end

		else if type(vals) == "table" then
			return nil, { status = 401 , message = "Key Already Exists" }
		end
	end
	
	local key_frm_cache = kong.dao.sample_plugin:cache_key(key)
	-- fetch the credentials 
	local credential , err = kong.cache:get(key_frm_cache, nil, fetch_credentials , key)
	
	if err then  -- if an error was raised
	   kong.log.err(err)
	   return kong.response.exit(500, "Internal Server Error")
	end

	if not credentials then  -- if the details dont exist in DB
		return nil, { status = 403 , message = "Please try with valida credentials" }
	end
	
	local key_consumer_from_cache = kong.db.consumer:cache_key(credential.consumer_id)
	-- fetch consumer
	local consumer , err = kong.cache:get(key_consumer_from_cache,nil, fetch_consumer, credential.consumer_id)

	if err then
	   kong.log.err(err)
	   return nil, { status = 500, message = "Internal Server Error"}
	end

	-- add the consumer & its credentials in the kong context
	add_consumer(consumer,crendentials)
	
	return true
			
end

local function fetch_credentials(k)
	local res, err = kong.dao.sample_plugin:find_all({ key = key })
	if not res then
		return nil, err
	end
	return res[1]
end



local function fetch_consumer(c_id, anonymous)
	local res , err = kong.db.consumer:select({ id = c_id})
	if not res then
		if anonymous and not err then
			err = 'Consumer is Unknown "' .. c_id
		end

		return nil, err
	end
	return res
end

function _D.run(config)
	-- kong.dao
	-- kong.db

	-- kong.singletons
	-- ngx   --> requuest / response  ( headers + body )
	-- ng.ctx --> context of the current requests

	if ngx.ctx.authenticated_credential and config.anonymous ~= "" then

	  return
	end

	local ok, err = login(config)

	if not ok then
		if config.anonymous ~= "" then  -- fetch for anonymous user
			local key_cache_consumer = kong.db.consumers:cache_key(config.anonymous)
			local consumer , err = kong.cache:get(key_cache_consumer, nil,
								fetch_consumer,
								config.anonymous, true)
			if err then
				kong.log.err(err)
				return kong.response.exit(500, { message = "Internal Server Error" } )
			end
			add_consumer(consumer,nil)
		else
			return kong.response.exit(err.status, { message = err.message }, err.headers)
		end
	end
	-- TODO : consumer id needs to be loaded seperately
	--local consumer_id = 0
	--local cache_key_for_consumer = singletons.db.consumers:cache_key(consumer_id)
	--local consumer , err = singletons.cache:get (cache_key_for_consumer,nil,nil, consumer_id)
	
	--if err then
	 --  return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
	--end
	--set_consumer(consumer,nil)
	
end

return _D
