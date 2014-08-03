-- This module will capture an assertion if:
-- * Method is a POST
-- * X-LT-API-Key is present in the HTTP header and length is of Ruby UUID length (36 characters)
-- * Key is present in Redis

-- Note:  Lua string match is not exactly regex, but similar.  This is not a perfect 8-4-4-4-12 match,
--        but close enough for fast GUID flash test (must be hex with four dashes + below string len 
--        of 36 chars)
GUID_MATCH = "%x+%-%x+%-%x+%-%x+%-%x+"
LUA_FILE_NAME = "api_key_validate.lua"

if ngx.req.get_method() ~= "POST" or 
   ngx.req.get_headers()["X-LT-API-Key"] == nil or
   string.match(ngx.req.get_headers()["X-LT-API-Key"], GUID_MATCH) == nil or
   string.len(string.match(ngx.req.get_headers()["X-LT-API-Key"], GUID_MATCH)) ~= 36 then
	return ngx.exit(400)
else
	api_key = ngx.req.get_headers()["X-LT-API-Key"]
	local redis = require "resty.redis"
	local red = redis:new()
	red:set_timeout(1000)

	-- Connect to Redis at localhost
	local ok, err = red:connect("127.0.0.1", 6379)
        if not ok then
        	ngx.log(ngx.ERR, LUA_FILE_NAME .. ": failed to connect to Redis: ", err)
        	return ngx.exit(500)
        end

	-- Retrieve API key
	local queue, err = red:hget(api_key, "queue")
        if not queue or queue == ngx.null then
        	-- ngx.log(ngx.ERR, "API key does not exist: " .. api_key, err) 
        	return ngx.exit(401)
	else
		ngx.req.read_body() -- necessary to access get_body_data()
		local result, err = red:lpush(queue, ngx.req.get_body_data())
		if not result then
			ngx.log(ngx.ERR, LUA_FILE_NAME .. ": Redis LPUSH failed to: " .. queue, errr)
			return ngx.exit(400)
		else
			return ngx.exit(200)
		end
        end
end
