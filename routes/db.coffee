mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/quiz_database'

Schema = mongoose.Schema

Person = new Schema {
  id: 
    type: String
    required: true
    unique: true
  date: 
    type: Date
    required: true
  rounds: 
    type: Number
    default: 0
  points: [Number]
  correct: [Number]
}

mongoose.model 'Person', Person

