assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, bytes: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 20, bytes: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 17, bytes: 19
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count camel cased with 2 words', (done) ->
    input = 'camelCased'
    expected = words: 2, lines: 1, bytes: 10, characters: 10
    helper input, expected, done

  it 'should count camel cased with 4 words', (done) ->
    input = 'camelCasedCamelCased'
    expected = words: 4, lines: 1, bytes: 20, characters: 20
    helper input, expected, done

  it 'should count words from file 1,9,44.txt', (done) ->
    fs.readFile "./test/fixtures/1,9,44.txt", 'utf8', (err, chunk) ->
      input = chunk
      expected = words: 9, lines: 1, bytes: 45, characters: 44
      helper input, expected, done

  it 'should count words from file 3,7,46.txt', (done) ->
    fs.readFile "./test/fixtures/3,7,46.txt", 'utf8', (err, chunk) ->
      input = chunk
      expected = words: 7, lines: 3, bytes: 49, characters: 44
      helper input, expected, done

  it 'should count words from file 5,9,40.txt', (done) ->
    fs.readFile "./test/fixtures/5,9,40.txt", 'utf8', (err, chunk) ->
      input = chunk
      expected = words: 9, lines: 5, bytes: 45, characters: 40
      helper input, expected, done

  it 'should count camel cased word with quote as one word', (done) ->
    input = '"camelCased" "CamelCased words" word'
    expected = words: 3, lines: 1, bytes: 36, characters: 32
    helper input, expected, done

  it 'should count two 2 quoted sting without space as 2 words', (done) ->
    input = '"camelCased""not Camel Cased"'
    expected = words: 2, lines: 1, bytes: 29, characters: 25
    helper input, expected, done