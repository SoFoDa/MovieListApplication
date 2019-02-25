const model = require('../model.js');

module.exports = (socket, io) => {

  // user joins room
  socket.on('hello', req => {
    io.emit('hello', req);
  });
};
