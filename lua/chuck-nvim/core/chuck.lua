local config = require("chuck-nvim").config
local utils = require("chuck-nvim.core.utils")

local M = {}

local function chuck_logfile()
    local tmp = os.tmpname()
    local file = assert(io.open(tmp, "w"))
    file:close()
    return tmp
end

-- this is used by both chuck_loop and chuck_exit and needs to be here
local log_file = chuck_logfile()

-- split window and start chuck --loop in a terminal
function M.chuck_loop()
    local log_level = config.log_level
    local srate = config.srate
    local bufsize = config.bufsize
    local dac = config.dac
    local adc = config.adc
    local channels = config.channels
    local input = config.input
    local output = config.output
    local remote = config.remote
    local port = config.port

    local cmd = string.format(
        "chuck --loop --log%s --srate%d --bufsize%d --dac%d --adc%d --channels%d --in%d --out%d --remote%s --port%d",
        log_level,
        srate,
        bufsize,
        dac,
        adc,
        channels,
        input,
        output,
        remote,
        port
    )

    utils.chuck_ui(cmd, log_file)
end

-- check chuck status
function M.check_status()
    local cmd = "chuck --status"

    utils.exec(cmd)
end

-- print chuck detailed time information
function M.chuck_time()
    local cmd = "chuck --time"

    utils.exec(cmd)
end

-- check add current file to shreds
function M.add_shred()
    local cmd
    cmd = "chuck --add " .. vim.fn.expand("%")

    utils.exec(cmd)
end

-- check remove a shred with id from shreds
function M.remove_shred()
    local cmd
    local input = vim.fn.input("Shred(s) to remove: ")

    if input ~= nil then
        cmd = "chuck --remove " .. input
        utils.exec(cmd)
    end
end

-- check replace a shred with the current buffer
function M.replace_shred()
    local cmd
    local input = vim.fn.input("Shred to replace: ")

    if input ~= nil then
        cmd = "chuck --replace " .. input .. " " .. vim.fn.expand("%")
        utils.exec(cmd)
    end
end

-- remove all shreds and reset the type system
function M.clear_vm()
    local cmd = "chuck --clear.vm"

    utils.exec(cmd)
end

-- remove all shreds
function M.clear_shreds()
    local cmd = "chuck --remove.all"

    utils.exec(cmd)
end

-- quit chuck and remove temprary logfile
function M.chuck_exit()
    local cmd = "chuck --exit"

    utils.exec(cmd)

    if not log_file then
        return nil
    end
    os.remove(log_file)
end

return M
