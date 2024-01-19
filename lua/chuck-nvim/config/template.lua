---@class chuck-nvim.Config
local M = {
    ---@type number
    log_level = 1,

    ---@type number
    srate = 44100,

    ---@type number
    bufsize = 512,

    ---@type number
    dac = 0,

    ---@type number
    adc = 0,

    ---@type number
    channels = 2,

    ---@type number
    input = 2,

    ---@type number
    output = 2,

    ---@type string
    remote = "127.0.0.1",

    ---@type number
    port = 8888,
}

return M
