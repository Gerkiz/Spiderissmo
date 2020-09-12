local Event = require 'utils.event_core'
local Token = require 'utils.token'

local Global = {}

local names = {}
Global.names = names

function Global.register(tbl, callback)
    if _LIFECYCLE ~= _STAGE.control then
        error('can only be called during the control stage', 2)
    end

    local token = Token.register_global(tbl)

    Event.on_load(
        function()
            callback(Token.get_global(token))
        end
    )

    return token
end

function Global.register_init(tbl, init_handler, callback)
    if _LIFECYCLE ~= _STAGE.control then
        error('can only be called during the control stage', 2)
    end
    local token = Token.register_global(tbl)

    Event.on_init(
        function()
            init_handler(tbl)
            callback(tbl)
        end
    )

    Event.on_load(
        function()
            callback(Token.get_global(token))
        end
    )

    return token
end

return Global
