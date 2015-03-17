reduce = require "lodash.reduce"
EventEmitter = (require "eventemitter2").EventEmitter2

module.exports = class A extends EventEmitter
  constructor: ({@threshold}={}) ->
    @threshold ?= 5000

    MediaStreamTrack.getSources (infos) =>
      console.log infos
      console.log infos[2].id
      navigator.webkitGetUserMedia {
        audio:
          optional: [
            sourceId: infos[2].id
          ]
      }, (stream) =>
        ctx = new webkitAudioContext()

        analyser = ctx.createAnalyser()
        microphone = ctx.createMediaStreamSource stream

        microphone.connect analyser
        analyser.connect ctx.destination
        
        console.log analyser
        freqData = new Uint8Array analyser.frequencyBinCount
        setInterval =>
          analyser.getByteFrequencyData freqData
          level = reduce freqData, ((a, b) -> a + b), 0
          console.log @threshold
          @emit "input", level: level if level > @threshold
        , 10
      , ->
        console.log "error on getUserMedia"
