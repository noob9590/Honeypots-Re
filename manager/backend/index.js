if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config()
}

const fs = require('fs')
const bodyParser = require('body-parser')
const helmet = require('helmet')
const cors = require('cors')
const express = require('express')
var passport = require('passport')
const key = fs.readFileSync('./security2/privatekey.pem')
const cert = fs.readFileSync('./security2/publiccert.pem')
const app = express()
const path = require('path')
var server = require('https').createServer({ key: key, cert: cert }, app)
var io = require('./socketio')
io.init(server)

const routers = require('./router')

const port = process.env.PORT || 3002

app.use(express.static(path.join(__dirname, 'build')))
app.use(helmet())
app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(passport.initialize())
app.use(routers)

server.listen(port, () => {
  console.log("Running on port: ", port)
})
