---@class chuck-nvim.Config
local M = {
  ---by default, ChucK runs at 44100Hz on macOS and Windows, and 48000Hz on linux/ALSA.
  ---
  ---@type number
  srate = 44100,

  ---larger buffer size often reduce audio artifacts due to system/program timing.
  ---smaller buffers reduce audio latency. The default is 512.
  ---
  ---@type number
  bufsize = 512,

  ---opens audio output device #(N) for real-time audio. by default, (N) is 0.
  ---
  ---@type number
  dac = 0,

  ---opens audio input device #(N) for real-time audio input. by default, (N) is 0.
  ---
  ---@type number
  adc = 0,

  ---opens (N) number of input and output channels on the audio device. by default, (N) is 2.
  ---
  ---@type number
  channels = 2,

  ---opens (N) number of input channels on the audio device. by default (N) is 2.
  ---
  ---@type number
  input = 2,

  ---opens (N) number of output channels on the audio device. by default (N) is 2.
  ---
  ---@type number
  output = 2,

  ---sets the hostname to connect to if accompanied by the on-the-fly programming commands.
  ---(host) can be name or ip of the host. default is 127.0.0.1 (localhost).
  ---
  ---@type string
  remote = "127.0.0.1",

  ---sets the port to listen on if not used with on-the-fly programming commands.
  ---sets the port to connect to if used with on-the-fly programming commands.
  ---
  ---@type number
  port = 8888,
}

return M
