const mongoose = require('mongoose')

const HoneySchema = mongoose.Schema({
    honeypotEvent: {
        type: Object,
        required: true
    },
    date: {
        type: Date,
        default: Date.now()
    }
})

module.exports = mongoose.model('HoneypotEvent', HoneySchema)