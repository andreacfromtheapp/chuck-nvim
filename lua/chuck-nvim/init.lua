local M = {}

M.config = {
    log_level = 1,
    srate = 44100,
    bufsize = 512,
    dac = 0,
    adc = 0,
    channels = 2,
    input = 2,
    output = 2,
    remote = "127.0.0.1",
    port = 8888,
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    return M.config
end

return M
