# chuck-nvim

A Neovim plugin for [ChucK](http://chuck.stanford.edu/) offering [granular
control](#usage) and a [WebChucK](https://chuck.cs.princeton.edu/ide/)-like
layout built with [NUI](https://github.com/MunifTanjim/nui.nvim).

An example session recorded with asciinema. For some reason colors were not recorded. The UI looks [like this](https://github.com/gacallea/chuck-nvim/assets/3269984/6bc8d328-817f-477c-95cb-764cef7d05f2)

![chuck-nvim](https://github.com/gacallea/chuck-nvim/assets/3269984/48deca64-375a-4ee4-a4b2-10eceb8ad142)

## Temporary features

- Set `.ck` filetype and syntax highlighting (until [Neovim/Vim native
support](https://github.com/gacallea/chuck-nvim/issues/7))
- Set icon for `.ck` filetype (until [nerd-font native
support](https://github.com/gacallea/chuck-nvim/issues/3))

## Installation

To use `chuck-nvim`, you need to have:

- Neovim 0.9.5 or up.
- The `tail` command in your path.
- ChucK installed on your system.

### Installing ChucK

To download and install ChucK, visit the [official ChucK release
page](https://chuck.stanford.edu/release/). For more information, including
documentation, examples, research publications, and community resources, visit
the [ChucK homepage](https://chuck.stanford.edu/).

#### Homebrew

```bash
brew install chuck
```

### Installing chuck-nvim

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "gacallea/chuck-nvim",
  version = "*",
  dependencies = {
    { "MunifTanjim/nui.nvim" },
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
  opts = {}, -- see configuration
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
  keys = {}, -- see key mappings
}
```

## Configuration

`chuck-nvim` options to configure this plugin, and a subset of ChucK VM's
[command-line
options](https://ccrma.stanford.edu/software/chuck/doc/program/options.html).

```lua
-- default values:
opts = {
  autorun = false,
  layout = "webchuck", -- or "chuck_on_top"
  chuck_vm = {
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

> [!TIP]
> You can enable `autorun` to launch ChucK and the UI automatically.

### ChuckStatus

Prints current `time` and active `shreds` status in the ChucK VM.

### ChuckTime

Prints the ChucK VM's full `time` information in the ChucK VM.

### ChuckAddShred

Adds the current saved buffer to the ChucK VM, as an active shred.

> [!NOTE]
> You must save file changes beforehand.

### ChuckRemoveShreds

Prompts the user for shred(s) number(s), then removes them from ChucK.

> [!TIP]
> To remove more than one shred, enter the numbers separated by spaces.

### ChuckReplaceShred

Prompts the user for a shred number, then replaces it with the current buffer.

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

> [!TIP]
> You could map the commands to function keys to speed up operations.

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
    version = "*",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
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
    opts = {},
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
      { mode = "n", "<leader>Cl", "<cmd>ChuckLoop<cr>", desc = "Chuck Loop" },
      { mode = "n", "<leader>Cs", "<cmd>ChuckStatus<cr>", desc = "Chuck Status" },
      { mode = "n", "<leader>Ct", "<cmd>ChuckTime<cr>", desc = "Chuck Time" },
      { mode = "n", "<leader>Ca", "<cmd>ChuckAddShred<cr>", desc = "Add Shred" },
      { mode = "n", "<leader>Cd", "<cmd>ChuckRemoveShreds<cr>", desc = "Remove Shred(s)" },
      { mode = "n", "<leader>Cr", "<cmd>ChuckReplaceShred<cr>", desc = "Replace Shred" },
      { mode = "n", "<leader>Cc", "<cmd>ChuckClearShreds<cr>", desc = "Clear Shreds" },
      { mode = "n", "<leader>Cv", "<cmd>ChuckClearVM<cr>", desc = "Clear VM" },
      { mode = "n", "<leader>Ce", "<cmd>ChuckExit<cr>", desc = "Exit ChucK" },
    },
  },
}
```

## License

The code of this repository is licensed under the [GPLv2](./LICENSE) for
compatibility with [ChucK
licensing](https://github.com/ccrma/chuck/blob/main/LICENSE).
