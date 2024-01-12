local M = {}

function M.create_split_terminal(command, size, direction)
  local shreds = string.format("1ToggleTerm size=%d direction=%s name=shreds", tonumber(size), direction)
  local chuckVM = string.format("2ToggleTerm size=%d direction=%s name=chuckVM", tonumber(size), direction)
  local cmd = string.format('2TermExec cmd="%s"', command)

  vim.cmd(shreds)
  vim.cmd(chuckVM)
  vim.cmd(cmd)
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
