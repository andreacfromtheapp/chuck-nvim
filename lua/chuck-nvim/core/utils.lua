local M = {}

local function parse_chuck_vm(file) return true end

function M.create_split_terminal(cmd, size, logfile)
  local shreds = string.format("vsplit | vertical resize %d | terminal tail -f %s", tonumber(size), logfile)
  local chuck_cmd = string.format("split | terminal %s 3>&1 2>&1 | tee %s", cmd, logfile)

  vim.cmd(shreds)
  vim.cmd(chuck_cmd)
  vim.cmd "wincmd w"
  -- parse_chuck_vm(log)
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
