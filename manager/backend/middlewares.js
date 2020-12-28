if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config()
}

const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')

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


}
