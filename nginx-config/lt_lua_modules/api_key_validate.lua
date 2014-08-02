-- This module will capture an assertion if:
-- * Method is a POST
-- * X-LT-API-Key is present in the HTTP header and length is of Ruby UUID length (36 characters)
-- * Key is present in Redis

-- Note:  Lua string match is not exactly regex, but similar.  This is not a perfect 8-4-4-4-12 match,
--        but close enough for fast GUID flash test (must be hex with four dashes + below string len 
--        of 36 chars)
GUID_MATCH = "%x+%-%x+%-%x+%-%x+%-%x+"

if ngx.req.get_method() ~= "POST" or 
   ngx.req.get_headers()["X-LT-API-Key"] == nil or
   string.match(ngx.req.get_headers()["X-LT-API-Key"], GUID_MATCH) == nil or
   string.len(string.match(ngx.req.get_headers()["X-LT-API-Key"], GUID_MATCH)) ~= 36 then
	ngx.exit(400);
else
	api_key = ngx.req.get_headers()["X-LT-API-Key"];
	ngx.say(api_key);
end
