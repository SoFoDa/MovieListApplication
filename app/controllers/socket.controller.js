const model = require('../model.js');

module.exports = (socket, io) => {

  // user joins room
  socket.on('join', req => {
    console.log(JSON.stringify(req));
    
    const name = req.name;    
    const user = req.user;
    const room = model.findRoom(name);

    // room.addUser(user);
    socket.join(name);
    console.log('A user joined ' + name);
    io.to(name).emit('join', req);
    room.addMessage(req.username + " joined the channel");
  });

  // user gets updated
  socket.on('updateStatus', req => {
    const time = req.time;
    const assistant = req.assistant;
    const status = req.status;
    if (status !== "update") {
      model.getAssistantID(assistant).then(function(id) {
        model.updateTimeSlotStatus(id.id, time, status);
      })
    }

    io.emit('updateStatus');
  });

  socket.on('startTimer', req => {
    const time = req.time;
    const assistant = req.assistant;
    setTimeout(function(){ 
      model.getAssistantID(assistant).then(function(id) {
        model.getTimeSlot(id.id, time).then(function(timeSlot) {
          if (timeSlot.length > 0 && timeSlot[0].status === 'reserved') {
            model.updateTimeSlotStatus(id.id, time, 'free').then(() => {
              io.emit('updateStatus');
            });
          }
        });
      })
    }, 22000);
  })
};
