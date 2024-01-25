local Layout = require("nui.layout")
local NuiLine = require("nui.line")
local NuiSplit = require("nui.split")
local NuiText = require("nui.text")
local NuiTree = require("nui.tree")

local M = {}

-- panes options
local pane_win_opts = {
  number = false,
  relativenumber = false,
  scrolloff = 0,
}

local pane_buf_opts = {
  modifiable = false,
  readonly = true,
  bufhidden = "hide",
  buflisted = false,
  buftype = "nofile",
  swapfile = false,
}

-- panes
M.shred_pane = NuiSplit({
  ns_id = "shred_pane",
  enter = true,
  win_options = pane_win_opts,
  buf_options = pane_buf_opts,
})

M.chuck_pane = NuiSplit({
  ns_id = "chuck_pane",
  enter = true,
  win_options = pane_win_opts,
  buf_options = pane_buf_opts,
})

-- trees
-- extrapolate the nodes to display in NuiTree
function M.mknodes()
  local shreds = require("chuck-nvim.core.shreds").shreds_table
  local nodes = {}

  -- build actual nodes to use with NuiTable UI layout
  for _, shred in pairs(shreds) do
    table.insert(nodes, NuiTree.Node(shred))
  end

  return nodes
end

-- the NuiTree where to show a list of active shreds
M.shred_list = NuiTree({
  bufnr = M.shred_pane.bufnr,
  nodes = M.mknodes(),
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

-- the NuiTree where to show raw chuck vm log as lines
M.chuck_log = NuiTree({
  bufnr = M.chuck_pane.bufnr,
  nodes = {},
  prepare_node = function(node)
    return NuiLine({
      NuiText(node.log),
    })
  end,
})

-- final layout
M.chuck_layout = Layout(
  {
    position = "right",
    relative = "editor",
    size = "30%",
  },
  Layout.Box({
    Layout.Box(M.shred_pane, { size = "45%" }),
    Layout.Box(M.chuck_pane, { size = "55%" }),
  }, {
    dir = "col",
  })
)

return M
