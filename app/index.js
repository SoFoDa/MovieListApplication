require('dotenv').load();

const setupBoilerplate = require('./boilerplate/setup');

const { app, listen } =  setupBoilerplate();

const port = process.env.PORT;

// Bind REST controller to /api/*
const router = require('./controllers/rest.controller.js');
app.use('/api', router);

// Registers socket.io controller
const socketController = require('./controllers/socket.controller.js');

app.ws('/', function(ws, req) {
  console.log("A user connected");
  socketController(ws, app);
});

const model = require('./model.js');

listen(port, () => {
  console.log("server listening on port", port);
});
