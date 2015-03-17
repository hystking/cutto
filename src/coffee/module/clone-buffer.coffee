copyBuffer = require "./copy-buffer"

module.exports = (ctx, buffer) ->
  channels = (new Float32Array buffer.getChannelData i for i in [0...buffer.numberOfChannels])
  ret = ctx.createBuffer buffer.numberOfChannels, buffer.length, buffer.sampleRate
  copyBuffer buffer, ret
  return ret
