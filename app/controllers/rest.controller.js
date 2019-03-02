const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.post('/authorize', function (req, res) { 
  let username = req.body.username;
  console.log(username);
  if (username != undefined) {
    username = username.toLowerCase();
    model.getUser(username).then(function(user) {
      let hash = user.password_hash;
      bcrypt.compare(req.body.password, hash).then(function(correctHash) {
        if(correctHash) {
          // Auth token
          // Create a token
          const payload = { username: user.username, user_id: user.user_id };
          const options = { expiresIn: '2d' };
          const secret = process.env.JWT_SECRET;
          const token = jwt.sign(payload, secret, options);

          res.json({
            token: token,
            username: user.username,
            user_id: user.user_id,
            status: '200'
          });
        } else {
          res.json({
            user_id: 0,
            error: 'Authentication error, invalid username or password.',
            status: '403'
          });
        }
      });
    }).catch(err => {
      res.json({
        error: 'Bad authentication request.',
        status: '400'
      });
    });
  }
}); 

router.put('/register', function (req, res) {
  console.log('here');
  bcrypt.hash(req.body.password, 10, function(err, hash) {
    // save user
    model.registerUser(req.body.username, hash).then(function(response) {
      // created user
      if (response) {
        // Auth token
        // Create a token
        const payload = { username: user.username, user_id: user.user_id };
        const options = { expiresIn: '24h' };
        const secret = process.env.JWT_SECRET;
        const token = jwt.sign(payload, secret, options);
        res.json({
          token: token,
          user_id: 0,
          username: req.body.username,
          status: '200'
        })
      } else {
        res.json({
          error: 'taken',
          status: '200'
        })
      }
    });
  });
});

// todo write check token method

module.exports = router;
