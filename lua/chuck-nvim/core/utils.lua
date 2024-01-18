local layout = require("chuck-nvim.ui.layout")
local shreds = require("chuck-nvim.core.shreds")
local events = require("nui.utils.autocmd").event

local M = {}

local function shred_lines(logfile)
    -- local pipe = vim.system({ "tail", "-f", logfile }, { text = true }):wait()
    local cmd = string.format("tail -f %s", logfile)
    local pipe = assert(io.popen(cmd))
    repeat
        local line = pipe:read(1)
        if line then
            shreds.set_table(line)
            layout.shreds_tree:render()
        end
    until not line
    pipe:close()
end

local function start_chuck(cmd, logfile)
    local chuck_cmd = string.format("terminal %s 3>&1 2>&1 | tee %s", cmd, logfile)
    vim.cmd(chuck_cmd)
end

function M.chuck_ui(cmd, logfile)
    layout.chuck_layout:mount()
    layout.chuck_pane:on(events.BufEnter, function()
        start_chuck(cmd, logfile)
    end, { once = true })
    layout.shred_pane:on(events.BufEnter, function()
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
