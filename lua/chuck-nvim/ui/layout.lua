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
function M.mknodes(action)
  local timers = require("chuck-nvim.ui.timers")
  local shreds_table = require("chuck-nvim.core.shreds").shreds_table
  local nodes = {}

  -- build actual nodes to use with NuiTable UI layout
  for _, shred in pairs(shreds_table) do
    -- add a timer field to each shred
    timers.set_timer(shred.id, action)
    local timer = timers.get_time(shred.id)
    shred = { id = shred.id, name = shred.name, time = timer }
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
      NuiText("  "),
      NuiText("time: "),
      NuiText(node.time, "DiagnosticOk"),
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

M.chuck_on_top = (
  Layout.Box({
    Layout.Box(M.chuck_pane, { size = "55%" }),
    Layout.Box(M.shred_pane, { size = "45%" }),
  }, {
    dir = "col",
  })
)

-- these doesn't make much sense, leaving it here for future ideas
-- M.only_the_shreds = (Layout.Box({
--   Layout.Box(M.shred_pane, { size = "100%" }),
-- }, {
--   dir = "col",
-- }))
--
-- M.only_the_chuckvm = (Layout.Box({
--   Layout.Box(M.chuck_pane, { size = "100%" }),
-- }, {
--   dir = "col",
-- }))

return M
