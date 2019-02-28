const setupBoilerplate = require('./boilerplate/setup');

const { app, io, listen } =  setupBoilerplate();
const port = 8989;

// Bind REST controller to /api/*
const router = require('./controllers/rest.controller.js');
app.use('/api', router);

// Registers socket.io controller
const socketController = require('./controllers/socket.controller.js');
io.on('connection', socket => {
    socketController(socket, io);
});


const model = require('./model.js');

listen(port, () => {
  console.log("server listening on port", port);
});
