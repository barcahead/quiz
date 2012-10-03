mongoose = require 'mongoose'
robot = require './robot'
validator = require './validator'
require './db'


Person = mongoose.model 'Person'

exports.checkAnswer = (req, res) ->

  fnList = 
    'logo': (q) ->
      ans = [1,3,4,0]
      for v, id in q
        unless id>=0 and id<4 and ans[id] is v
          return false
      true
    'lock': (q) ->
      ans = [389488, 10000]
      unless q[0] is ans[0] and q[1] is ans[1]
        return false
      true
    'robot': (q) ->
      robot.checkMoves q
    'cipher': (q) ->
      if q.toLowerCase() is 'mobilewave' then true else false

  pg = req.params.pg

  token = req.body.token
  ans = req.body.ans

  if pg is 'logo' or validator.validate token, pg
    res.json
      token: if pg of fnList and fnList[pg] ans then validator.cipher pg else 0
  else 
    res.json
      token: -1

exports.mstrApply = (req, res) ->
  token = req.body.token
  if not token or not validator.validate token, 'apply'
    res.json
      token: -1
  else 
    person = new Person
      id: req.params.id
      date: (new Date()).getTime()

    person.save (err) ->
      res.json 
        token: if err then -1 else 1

exports.cloudAnswer = (req, res) ->
  ans = req.body.ans
  applyID = req.body.applyID
  roundID = req.params.id

  Person.findOne {id: applyID}, (err, doc) ->
    if err or not doc then res.json {msg:'Invalid Apply ID!'}
    else if doc.rounds&(1<<roundID) then res.json {msg:'You have already submitted answers!'}
    else if not ans or ans.length isnt 4 then res.json {msg:'Server internal error!'}
    else 
      doc.rounds = doc.rounds | (1<<roundID)
      point = 0
      correct = 0
      if ans[0].toLowerCase() is 'mexico' 
        point |= (1<<1)
        correct++
      if ans[1].toLowerCase() is 'norway' 
        point |= (1<<2)
        correct++

      if doc.points.length is 0 
        doc.points = (0 for v in [0..4]) #for simplicity
        doc.correct = (0 for v in [0..4]) #for simplicity
      doc.points[roundID] = point
      doc.correct[roundID] = correct
      doc.markModified 'points'

      doc.save (err) ->
        res.json {msg: if err then 'Server internal error!' else 'Your answers has been saved!'}


exports.persons = (req, res) ->
  Person.find({})
  .sort('correct', -1, 'date', 1)
  .exec (err, persons, count) ->
    res.json 
      persons: persons