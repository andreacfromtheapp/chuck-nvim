local Layout = require "nui.layout"
local Split = require "nui.split"
local NuiTable = require "nui.table"

local M = {}

M.event = require("nui.utils.autocmd").event

M.shred_ui = Split {
  ns_id = "shred_ui",
  border = {
    text = "Shreds",
    style = "rounded",
  },
  enter = true,
}

M.chuck_ui = Split {
  ns_id = "chuck_ui",
  border = {
    text = "ChucK VM",
    style = "rounded",
  },
  enter = true,
}

-- FIX: nui table idea
-- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/table
M.shreds_table = NuiTable {
  bufnr = M.shred_ui.bufnr,
  columns = {
    {
      align = "center",
      header = "Shreds",
      columns = {
        { accessor_key = "shred_id", header = "ID" },
        {
          id = "shred_name",
          accessor_fn = function(row) return row.shred_name end,
          header = "Name",
        },
      },
    },
  },
  data = {
    { shred_id = "1", shred_name = "dada.ck" },
    { shred_id = "2", shred_name = "popo.ck" },
  },
}

M.chuck_layout = Layout(
  {
    position = "right",
    relative = "editor",
    size = "30%",
  },
  Layout.Box({
    Layout.Box(M.chuck_ui, { size = "55%" }),
    Layout.Box(M.shred_ui, { size = "45%" }),
  }, {
    dir = "col",
  })
)

M.update_layout = (
  Layout.Box({
    Layout.Box(M.shred_ui, { size = "45%" }),
    Layout.Box(M.chuck_ui, { size = "55%" }),
  }, {
    dir = "col",
  })
)

return M
