# chuck-nvim

A Neovim plugin for [ChucK](http://chuck.stanford.edu/), a programming language
for real-time sound synthesis and music creation.

## Features

- Set `.ck` filetype
- Set icon for `.ck` filetype (until [nerd-font native
support](https://github.com/gacallea/chuck-nvim/issues/3))
- Syntax highlighting (I wish we had Treesitter support)
- Granular control of ChucK via [user commands](#usage)
- [WebChucK-like](https://chuck.cs.princeton.edu/ide/) layout (requires using ChuckLoop)

## Installation

To use `chuck-nvim`, you need to have ChucK installed on your system.

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
    { -- until https://github.com/gacallea/chuck-nvim/issues/3
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
  -- not yet complete: https://github.com/gacallea/chuck-nvim/issues/2
  opts = {}, -- see configuration
  keys = {}, -- see key mappings
}
```

## Configuration

`chuck-nvim` comes with these default values to configure ChucK VM's
[options](https://ccrma.stanford.edu/software/chuck/doc/program/options.html)
used with `ChuckLoop`.

```lua
opts = {
  vertical_split_size = 70,
  chuck = {
    log_level = 1,
    srate = 44100,
    bufsize = 512,
    dac = 0,
    adc = 0,
    channels = 2,
    input = 2,
    output = 2,
    remote = "127.0.0.1",
    port = 8888,
  },
},
```

## Usage

`chuck-nvim` provides the following functions to interact with the ChucK VM.

### ChuckLoop

Starts ChucK in loop mode with `chuck --loop` using the configuration values.

> [!NOTE]
> You can still start ChucK yourself. Although, you'd lose `chuck-nvim` UI features.

### ChuckStatus

Prints current `time` and active `shreds` status in the ChucK VM.

### ChuckTime

Prints the ChucK VM's full `time` information in the ChucK VM.

### ChuckAddShred

Adds the current buffer to the ChucK VM, as an active shred.

> [!WARNING]
> Unnamed buffers and unsaved changes won't be sent to ChucK.

### ChuckRemoveShreds

Prompts the user for shred(s) number(s), then removes them from ChucK.

> [!TIP]
> To remove multiple shreds, enter all the numbers separated by spaces.

### ChuckReplaceShred

Prompts the user for a shred number, then replaces it with the active buffer.

### ChuckClearShreds

Removes **all** active shreds.

### ChuckClearVM

Removes **all** active shreds and resets the type system.

### ChuckExit

Cleanly exits the VM, cleans out logs, and quits ChucK.

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
      { -- until https://github.com/gacallea/chuck-nvim/issues/3
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
    -- not yet complete: https://github.com/gacallea/chuck-nvim/issues/2
    opts = {},
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
