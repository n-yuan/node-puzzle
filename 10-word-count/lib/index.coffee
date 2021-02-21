through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  characters = 0
  bytes = 0

  transform = (chunk, encoding, cb) ->

    lines = chunk.split(/[\r\n|\r|\n](?=.)/g).length

    #  Get an array of words, including camel cased words and quoted strings
    tokens = chunk.match(/".*?"|[\w][a-z]+|\b\w+\b/g)

    words = tokens.length

    # Total characters, not including quote and newline character
    characters = chunk.replace(/\n|"/g, '').length

    # Total bytes
    bytes = Buffer.byteLength(chunk)

    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, bytes}
    this.push null
    return cb()

  return through2.obj transform, flush
