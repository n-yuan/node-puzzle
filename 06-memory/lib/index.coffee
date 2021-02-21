fs = require 'fs'
readline = require 'readline'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  
  counter = 0

  # Create readable stream of the test file
  inputStream = fs.createReadStream "#{__dirname}/../data/geo.txt"

  # Create interface line by line
  rl = readline.createInterface {input: inputStream}

  rl.on('line', (line) -> 
    lineElements = line.split '\t'
    if lineElements[3] == countryCode 
      counter += lineElements[1] - lineElements[0]
  )

  # Return the counter after read all lines
  rl.on('close', () ->
    cb null, counter
  )