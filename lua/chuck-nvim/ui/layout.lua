local Layout = require("nui.layout")
local NuiLine = require("nui.line")
local NuiSplit = require("nui.split")
local NuiText = require("nui.text")
local NuiTree = require("nui.tree")

local M = {}

M.shred_pane = NuiSplit({
    ns_id = "shred_pane",
    enter = true,
    win_options = {
        number = false,
        relativenumber = false,
    },
    buf_options = {
        modifiable = false,
        readonly = true,
    },
})

M.chuck_pane = NuiSplit({
    ns_id = "chuck_pane",
    enter = true,
    win_options = {
        number = false,
        relativenumber = false,
    },
    buf_options = {
        modifiable = false,
        readonly = true,
    },
})

-- extrapolate the nodes to display in NuiTree
local function mknodes()
    local shreds = require("chuck-nvim.core.shreds").shreds_table
    local nodes_tbl = {}
    local nodes = {}

    -- convert to a valid shreds table to use with NuiTable
    for id, name in pairs(shreds) do
        table.insert(nodes_tbl, { id = id, name = name })
    end

    -- build actual nodes to use with NuiTable UI layout
    for _, shred in ipairs(nodes_tbl) do
        table.insert(nodes, NuiTree.Node(shred))
    end
    return nodes
end

-- https://neovim.io/doc/user/diagnostic.html#diagnostic-highlights
M.shreds_tree = NuiTree({
    bufnr = M.shred_pane.bufnr,
    nodes = mknodes(),
    prepare_node = function(node)
        return NuiLine({
            NuiText("id: "),
            NuiText(node.id, "DiagnosticOk"),
            NuiText("  "),
            NuiText("name: "),
            NuiText(node.name, "DiagnosticOk"),
        })
    end,
})

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
