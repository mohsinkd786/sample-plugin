local BasePlugin = require ("kong.plugins.base_plugin")
local SampleHandler = BasePlugin:extend()

-- constructor
function SampleHandler:new()
 SampleHandler.super.new(self,"Sample-Handler")
end

--

function SampleHandler:init_worker()
 SampleHandler.super.init_worker(self)
end

function SampleHandler:certificate(config)
 SampleHandler.super.certificate(self)
end

function SampleHandler:rewrite(config)
 SampleHandler.super.rewrite(self)
end

function SampleHandler:header_filter(config)
 SampleHandler.super.header_filter(self)
end

function SampleHandler:body_filter(config)
 SampleHandler.super.body_filter(self)
end

function SampleHandler:access(config)
 SampleHandler.super.access(self)
end

function SampleHandler:log(config)
 SampleHandler.super.log(self)
end

return SampleHandler

