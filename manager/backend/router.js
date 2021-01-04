const express = require('express')
const router = express.Router()
const middlewares = require('./middlewares')
var passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy
passport.use(new LocalStrategy(middlewares.passportStrategy))

router.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'build', 'index.html'))
})

router.post('/login', passport.authenticate('local', {session: false}), middlewares.login)

router.post('/', middlewares.sendAndReceiveAlert)

module.exports = router
