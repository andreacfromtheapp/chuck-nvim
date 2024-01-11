local M = {}

-- TODO: use M.config to manage chuck audio settings and window placement
function M.create_split_terminal(command)
  vim.cmd.vsplit()
  vim.cmd.terminal(command)
  vim.cmd.wincmd "w"
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

-- @param args string
function M.parseArgs(args)
  -- parse args as key=value
  local parsed = {}

  for _, arg in ipairs(vim.split(args, " ", {})) do
    local key, value = unpack(vim.split(arg, "=", { plain = true }))

    if value == "true" then
      value = true
    elseif value == "false" then
      value = false
    end

    parsed[key] = value
  end

  return parsed
end

return M
