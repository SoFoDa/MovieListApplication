const model = require('../model.js');

module.exports = (socket, users) => {

  socket.on('message', req => {
    req = JSON.parse(req);
    switch(req.action) {
      case 'handshake':
        console.log("handshake user: " + req.user);
        users[req.user] = socket;
        break;
      case 'update':
        console.log('updating user followers: ' + req.user);
        // TODO get model people follow
        // send singal
        model.getFollowers(req.user).then((followers) => {
          for (let key in followers) {
            let followerId = followers[key].friend_id;
            console.log("Follower: " + followerId);
            let followerSocket = users[followerId];
            if (followerSocket !== undefined) {
              followerSocket.send(JSON.stringify({action:'update'}));
            }
          }
        });
        break;
    }
  });
};
