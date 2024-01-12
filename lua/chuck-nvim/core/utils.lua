local M = {}

function M.create_split_terminal(command, size, direction)
  if direction == "vertical" then
    local vchuck = string.format("vsplit | vertical resize %d | terminal %s", tonumber(size), command)
    vim.cmd(vchuck)
  end

  if direction == "horizontal" then
    local hchuck = string.format("split | resize %d | terminal %s", tonumber(size), command)
    vim.cmd(hchuck)
    -- vim.cmd.vsplit()
    -- vim.cmd "terminal r !chuck"
    -- vim.cmd "wincmd w"
  end
end

local function read_file(path)
  local file = io.open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

function M.exec(cmd, stdin)
  local tmp = os.tmpname()
  local pipe = io.popen(cmd .. "> " .. tmp, "w")

  if not pipe then return nil end
  if stdin then pipe:write(stdin) end

  pipe:close()

  local output = read_file(tmp)
  os.remove(tmp)

  return output
end

return M
