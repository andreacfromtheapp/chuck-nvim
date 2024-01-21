local Layout = require("nui.layout")
local NuiLine = require("nui.line")
local NuiSplit = require("nui.split")
local NuiText = require("nui.text")
local NuiTree = require("nui.tree")

local M = {}

local panes_win_opts = {
  number = false,
  relativenumber = false,
}

local panes_buf_opts = {
  modifiable = false,
  readonly = true,
  bufhidden = "hide",
  buflisted = false,
  buftype = "nofile",
  swapfile = false,
}

M.shred_pane = NuiSplit({
  ns_id = "shred_pane",
  enter = true,
  win_options = panes_win_opts,
  buf_options = panes_buf_opts,
})

M.chuck_pane = NuiSplit({
  ns_id = "chuck_pane",
  enter = true,
  win_options = panes_win_opts,
  buf_options = panes_buf_opts,
})

-- https://neovim.io/doc/user/diagnostic.html#diagnostic-highlights
M.shreds_tree = NuiTree({
  bufnr = M.shred_pane.bufnr,
  nodes = {},
  get_node_id = function(node)
    if node.id then
      return node.id
    end
  end,
  prepare_node = function(node)
    return NuiLine({
      NuiText("id: "),
      NuiText(tostring(node.id), "DiagnosticOk"),
      NuiText("  "),
      NuiText("name: "),
      NuiText(node.name, "DiagnosticOk"),
    })
  end,
})

function M.set_node(line, action)
  if action ~= nil then
    local pattern = ".*(%d+)%s+%((.-)%)"
    local shred_id, shred_name = line:match(pattern)

    if action == "clear" then
      M.shreds_tree:set_nodes({})
    end

    if shred_id ~= nil and shred_name ~= nil and shred_name:match(".ck") then
      if action == "add" then
        M.shreds_tree:add_node(NuiTree.Node({ id = shred_id, name = shred_name }))
      end
      if action == "replace" then
        M.shreds_tree:remove_node(shred_id)
        M.shreds_tree:add_node(NuiTree.Node({ id = shred_id, name = shred_name }))
      end
      if action == "remove" then
        M.shreds_tree:remove_node(shred_id)
      end
    end
  end
end

M.chuck_layout = Layout(
  {
    position = "right",
    relative = "editor",
    size = "30%",
  },
  Layout.Box({
    Layout.Box(M.chuck_pane, { size = "55%" }),
    Layout.Box(M.shred_pane, { size = "45%" }),
  }, {
    dir = "col",
  })
)

M.update_layout = (
  Layout.Box({
    Layout.Box(M.shred_pane, { size = "45%" }),
    Layout.Box(M.chuck_pane, { size = "55%" }),
  }, {
    dir = "col",
  })
)

return M
