local layout = require("chuck-nvim.ui.layout")
local shreds = require("chuck-nvim.core.shreds")

local M = {}

local function shred_lines(logfile)
    local pipe = assert(io.open(logfile))
    repeat
        local line = pipe:read(1)
        if line then
            shreds.set_shreds_tbl(line)
            io.write(line)
            io.flush()
        end
    until line
    pipe:close()
end

local function start_chuck(cmd, logfile)
    local chuck_cmd = string.format("terminal %s 3>&1 2>&1 | tee %s", cmd, logfile)
    vim.cmd(chuck_cmd)
end

function M.chuck_ui(cmd, logfile)
    layout.chuck_layout:mount()
    layout.chuck_pane:on(layout.event.BufEnter, function()
        start_chuck(cmd, logfile)
    end, { once = true })
    layout.shred_pane:on(layout.event.BufEnter, function()
        shred_lines(logfile)
    end, { once = true })
    vim.cmd("wincmd w")

    layout.chuck_layout:update(layout.update_layout)
end

local function read_file(path)
    local file = assert(io.open(path, "rb"))
    local content = file:read("*all")
    file:close()
    return content
end

function M.exec(cmd, stdin)
    local tmp = os.tmpname()
    local pipe = assert(io.popen(cmd .. " > " .. tmp, "w"))

    if stdin then
        pipe:write(stdin)
    end

    pipe:close()

    local output = read_file(tmp)
    os.remove(tmp)

    return output
end

return M
