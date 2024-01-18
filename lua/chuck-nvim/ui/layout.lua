local Layout = require("nui.layout")
local NuiLine = require("nui.line")
local NuiSplit = require("nui.split")
local NuiText = require("nui.text")
local NuiTree = require("nui.tree")

local M = {}

M.event = require("nui.utils.autocmd").event

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

local function mknodes()
    local nodes = {}
    local shreds = require("chuck-nvim.core.shreds").table
    for _, shred in ipairs(shreds) do
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
