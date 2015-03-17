cloneBuffer = require "./clone-buffer"
copyBuffer = require "./copy-buffer"

module.exports = class A
  constructor: ({@ctx, @buffer, @originalBuffer, @quantization}) ->
    @quantization ?= 32
  
  _createRetriveBuffer: ->
    @retriveBuffer = cloneBuffer @ctx, @buffer
  
  _createCuttoInBuffer: (shiftT) ->
    @cuttoInBuffer = cloneBuffer @ctx, @originalBuffer
    shiftIndex = @_tToIndex shiftT
    # shift
    for c in [0...@cuttoInBuffer.numberOfChannels]
      originalChannelData = @originalBuffer.getChannelData c
      channelData = @cuttoInBuffer.getChannelData c
      j = shiftIndex
      for i of channelData
        channelData[i] = originalChannelData[j++]
        j = 0 if j > @originalBuffer.length

  _tToIndex: (t) ->
    return @buffer.length * (t * @quantization | 0) / @quantization | 0

  toggle: (t, shiftT) ->
    if @retriveBuffer?
      @retrive t
    else
      @cuttoIn t, shiftT

  cuttoIn: (t, shiftT) ->
    t ?= Math.random()
    shiftT ?= Math.random()
    do @_createRetriveBuffer
    @_createCuttoInBuffer shiftT
    @cuttonInT = t
    copyBuffer @cuttoInBuffer, @buffer
  
  retrive: (t) ->
    return unless @retriveBuffer?
    start = @_tToIndex @cuttonInT
    end = @_tToIndex t
    copyBuffer @retriveBuffer, @buffer
    if start < end
      copyBuffer @cuttoInBuffer, @buffer, start, end
    else
      copyBuffer @cuttoInBuffer, @buffer, 0, end
      copyBuffer @cuttoInBuffer, @buffer, start
    @retriveBuffer = null
