crypto = require 'crypto'

KEY = ('Long live Michael Saylor').toString 'ascii'

PAGES = ['logo', 'lock', 'robot', 'cipher', 'apply']

INTERVAL = 1000*60*60
exports.cipher = (pg) ->
  cipher = crypto.createCipher 'blowfish', KEY

  encripted = cipher.update pg+'|', 'utf8', 'hex'
  encripted += cipher.update (new Date()).getTime().toString(), 'utf8', 'hex'

  encripted += cipher.final 'hex'

exports.validate = (token, curP) ->
  if not token or not curP 
    return false
  decipher = crypto.createDecipher 'blowfish', KEY
  decrypted = decipher.update token, 'hex', 'utf8'
  decrypted += decipher.final 'utf8'
  text = decrypted.split '|'
  if text.length == 2
    prevP = text[0]
    prevTime = Number text[1]
    curTime = Number (new Date()).getTime().toString()
    for pg, i in PAGES
      if pg is prevP and i+1<PAGES.length and PAGES[i+1] is curP and curTime-prevTime < INTERVAL
        return true
    false
  else false

