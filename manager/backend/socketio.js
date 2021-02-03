if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config()
  }
const jwt = require('jsonwebtoken')
let io
let currentSocket

function socketAuthenticate(socket, next) {
    if (socket.handshake.query && socket.handshake.query.accessToken) {
        jwt.verify(socket.handshake.query.accessToken, process.env.ACCESS_TOKEN, function (err, decoded) {
            if (err) {
                return next(new Error('Authentication error'))
            }
            socket.decoded = decoded
            next()
        })
    }
    else {
        next(new Error('Authentication error'))
    }
}


module.exports = {
    init: (server) => {
        io = require('socket.io')(server, { cors: true })
        return io;
    },

    getIo: () => {
        if (!io) {
            throw new Error("socket is not initialized");
        }
        return io;
    },

    startListen: () => {
        if (!io) {
            console.log("in error")
            throw new Error("socket is not initialized")
        }
        io.use(socketAuthenticate).on('connection', (socket) => {
                console.log('connected')
                currentSocket = socket
            })
    },

    getSocket: () => {
        if (!currentSocket) {
            throw new Error("current socket is not initialized")
        }
        return currentSocket
    }


};