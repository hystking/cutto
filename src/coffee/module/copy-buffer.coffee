module.exports = (src, dest, from, to) ->
  unless from? or to?
    for c in [0...src.numberOfChannels]
      (dest.getChannelData c).set src.getChannelData c
    return
  from ?= 0
  to ?= src.length
  for c in [0...src.numberOfChannels]
    srcChannelData = src.getChannelData c
    destChannelData = dest.getChannelData c
    for i in [from...to]
      destChannelData[i] = srcChannelData[i]
