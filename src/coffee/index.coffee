param = (require "site-param")()
co = require "co"
wait = require "co-wait"
loader = require "webaudio-buffer-loader"
first = require "lodash.first"
throttle = require "lodash.throttle"
cloneBuffer = require "./module/clone-buffer"
Cutto = require "./module/cutto"
PulseInput = require "./module/microphone-pulse-input"

pulseInput = new PulseInput threshold: 50000
co ->
  window.AudioContext ?= window.webkitAudioContext
  ctx = new AudioContext
  buffer = first yield new Promise (resolve, reject) ->
    loader ["audio/test.wav"], ctx, (err, buffers) ->
      reject err if err
      resolve buffers
  
  cutto = new Cutto
    ctx: ctx
    buffer: buffer
    originalBuffer: cloneBuffer ctx, buffer
  
  source = ctx.createBufferSource()
  source.buffer = buffer

  source.connect ctx.destination
  source.loop = true

  #buttonCutto.addEventListener "click", ->
  pulseInput.on "input", throttle ->
    console.log "input"
    t = ctx.currentTime % buffer.duration / buffer.duration
    cutto.toggle t
  , 100, trailing: false
  source.start 0
