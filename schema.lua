local utils = require "kong.tools.utils"

local function dummy_keys(k)
	if not k.key_names then
		return { "apikey" }
	end
end

local function verify_keys(keys)
	for _, key in ipairs(keys) do
		local res , err = utils.validate_header_name(key, false)
		if not res then
			return false, "'" .. key .. "'" is invalid " .. err
		end
	end
	return true

end

local function get_user(anonymous)
	if anonymouse == "" or utils.is_valid_uuid(anonymous) then
		return true
	end
end

return {
 no_consumer = true,
 fields = {
	key_names = {
			required = true,
			type = "array",
			default = dummy_keys,
			func = verify_keys,
		},
	anonymous = {
			type = "string",
			default = "",
			func = get_user,
		},
	hide_credentials = {
			type = "boolean",
			default = false,
		},
	key_in_body = {
			type = "boolean",
			default = false,
		},
	run_on_preflight = {
			type = "boolean",
			default = true,
		}, 
 }
}
