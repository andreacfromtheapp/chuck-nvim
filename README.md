# chuck-nvim

A Neovim plugin for [ChucK](http://chuck.stanford.edu/), a programming language
for real-time sound synthesis and music creation.

## Features

- Set `.ck` filetype
- Syntax highlighting
- Granular control of ChucK via [user commands](#usage).

## Installation

To use `chuck-nvim`, you need to have ChucK
[installed](https://chuck.cs.princeton.edu/release/) on your system.

### Installing ChucK

To download and install ChucK, visit the **[official ChucK release
page](https://chuck.stanford.edu/release/)**. For more information, including
documentation, examples, research publications, and community resources, visit
the **[ChucK homepage](https://chuck.stanford.edu/)**.

#### Homebrew

```bash
brew install chuck
```

### Installing chuck-nvim

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "gacallea/chuck-nvim",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      opts = {
        override_by_extension = {
          ["ck"] = {
            icon = "󰧚",
            color = "#80ff00",
            name = "ChucK",
          },
        },
      },
    },
  },
  ft = { "chuck" },
  cmd = {
    "ChuckLoop",
    "ChuckStatus",
    "ChuckTime",
    "ChuckAddShred",
    "ChuckRemoveShreds",
    "ChuckReplaceShred",
    "ChuckClearShreds",
    "ChuckClearVM",
    "ChuckExit",
  },
  config = function() require "chuck-nvim" end,
}
```

## Usage

`chuck-nvim` provides the following functions to interact with the ChucK VM.

### ChuckLoop

Starts ChucK in loop mode with chuck --loop`.

> [!NOTE]
> configuration will be possible in a future update of this plugin.

### ChuckStatus

Prints the ChucK VM's current status. Namely: `time` and `active shreds`).

> [!NOTE]
> The status is printed in the ChucK VM itself.

> [!TIP]
> To get the number of a shred to replace or remove, use `ChuckStatus`.

### ChuckTime

Prints the ChucK VM's full time information.

> [!NOTE]
> The time information is printed in the ChucK VM itself.

### ChuckAddShred

Adds the active buffer to the ChucK VM, as an active shred.

> [!WARNING]
> Unsaved changes won't be sent to ChucK.

> [!WARNING]
> Unnamed buffers won't be sent to ChucK.

### ChuckRemoveShreds

Prompts the user for a shred number, then removes that shred from the ChucK VM.

> [!TIP]
> To remove multiple shreds, enter all the numbers separated by spaces.

### ChuckReplaceShred

Prompts the user for a shred number, then replaces that shred with the
active buffer.

> [!NOTE]
> This assumes you know the number of the shred you want to replace with the
> current and saved buffer.

### ChuckClearShreds

Removes **all** active shreds, and keeps the ChucK VM running.

### ChuckClearVM

Removes **all** active shreds and resets the type system.

### ChuckExit

Exits the VM and quits ChucK.

## Key mappings

`chuck-nvim` doesn't set any key mappings by default. Below, an example
configuration for [LazyVim](https://www.lazyvim.org).

> [!WARNING]
> Make sure these don't conflict with existing mappings.

```lua
return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>C"] = { name = "+chuck" },
      },
    },
  },
  {
    "gacallea/chuck-nvim",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = {
          override_by_extension = {
            ["ck"] = {
              icon = "󰧚",
              color = "#80ff00",
              name = "ChucK",
            },
          },
        },
      },
    },
    ft = { "chuck" },
    cmd = {
      "ChuckLoop",
      "ChuckStatus",
      "ChuckTime",
      "ChuckAddShred",
      "ChuckRemoveShreds",
      "ChuckReplaceShred",
      "ChuckClearShreds",
      "ChuckClearVM",
      "ChuckExit",
    },
    keys = {
      { "<leader>Cl", "<cmd>ChuckLoop<cr>", desc = "Chuck Loop", mode = "n" },
      { "<leader>Cs", "<cmd>ChuckStatus<cr>", desc = "Chuck Status", mode = "n" },
      { "<leader>Ct", "<cmd>ChuckTime<cr>", desc = "Chuck Time", mode = "n" },
      { "<leader>Ca", "<cmd>ChuckAddShred<cr>", desc = "Add Shred", mode = "n" },
      { "<leader>Cd", "<cmd>ChuckRemoveShreds<cr>", desc = "Remove Shred(s)", mode = "n" },
      { "<leader>Cr", "<cmd>ChuckReplaceShred<cr>", desc = "Replace Shred", mode = "n" },
      { "<leader>Cc", "<cmd>ChuckClearShreds<cr>", desc = "Clear Shreds", mode = "n" },
      { "<leader>Cv", "<cmd>ChuckClearVM<cr>", desc = "Clear VM", mode = "n" },
      { "<leader>Ce", "<cmd>ChuckExit<cr>", desc = "Exit ChucK", mode = "n" },
    },
    config = function() require "chuck-nvim" end,
  },
}
```

## Acknowledgements and licenses

- The [syntax file](./syntax/chuck.vim) is from
[chuck.nvim](https://github.com/NicholasDunham/chuck.nvim). Under the 2-Clause
BSD license and Copyright (c) 2014 Andy Wilson
- The [utils](./lua/chuck-nvim/core/utils.lua) are borrowed from [gist.nvim](https://github.com/rawnly/gist.nvim/blob/main/lua/gist/core/utils.lua)
Under the MIT License and Copyright (c) 2023 Federico Vitale
- This repository is under the [GPLv2](./LICENSE) for compatibility with [ChucK
licensing](https://github.com/ccrma/chuck/blob/main/LICENSE).
