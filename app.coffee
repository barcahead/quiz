express = require 'express'
require './routes/db'
routes = require './routes'
api = require './routes/api'
connect = require 'connect'

app = module.exports = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set 'view options', {
    layout: false
  }
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use connect.compress()
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', routes.index

app.get '/partials/:id', routes.partials
app.post '/api/checkAnswer/:pg', api.checkAnswer
app.post '/api/cloudAnswer/:id', api.cloudAnswer
app.post '/api/apply/:id', api.mstrApply
app.get '/api/persons/', api.persons

app.get '*', routes.index

server = app.listen 3000, ->
  console.log 'Express Server listening on port %d', 3000

