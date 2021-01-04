if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config()
}

const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const io = require('./socketio')

module.exports = {
  passportStrategy: async (username, password, done) => {
    if (!await bcrypt.compare(username, process.env.USER_NAME)) {
        console.log('incorrect username')
        return done(null, false, { message: "Incorrect username" })
    }
    try {
        if (!await bcrypt.compare(password, process.env.PASSWORD)) {
            console.log('incorrect password')
            return done(null, false, { message: 'Incorrect password' })
        }

    } catch (e) {
        console.log('error')
        return done(e)
    }
    console.log('correct cradentials')
    return done(null, username)
},

login: (req, res) => {
    const username = req.body.username
    const user = { name: username, pass: req.body.pass }
    const accessToken = jwt.sign(user, process.env.ACCESS_TOKEN)
    io.startListen()
    res.json({ accessToken: accessToken }).status(200)
},

sendAndReceiveAlert: (req, res) => {
       const dataObj = JSON.parse(req.body.data)
       if (dataObj.Event.System.Channel !== 'Setup' && dataObj.Event.EventData !== null && dataObj.Event.System.Channel !== 'Application' && dataObj.Event.EventData !== undefined) {
           let evtData = JSON.parse(req.body.data)
           let dataInEventData = {}
           evtData.Event.EventData.Data.forEach(element => {
               let values = Object.values(element)
               dataInEventData[values[0]] = values[1]
           });
           evtData.Event.EventData = dataInEventData
           req.body.data = JSON.stringify(evtData)
       }
       if (io.getSocket() !== undefined) {
           io.getSocket().emit('alert', req.body)
       }
       res.sendStatus(200)
   },

}
