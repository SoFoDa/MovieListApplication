const model = require('../model.js');

module.exports = (socket, io) => {

  // user joins room
  socket.on('message', req => {
    console.log('received hello');
    console.log(req);
    //io.send('hello', req);
  });
};
