const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.post('/authorize', function (req, res) { 
  let username = req.body.username.toLowerCase();
  model.getUser(username).then(function(user) {
    let hash = user.password_hash;
    bcrypt.compare(req.body.password, hash).then(function(correctHash) {
      if(correctHash) {
        res.json({
          auth: user.auth,
          username: user.username,
          user_id: user.user_id
        });
      } else {
        res.json({
          user_id: 0,
          status: 'error'
        });
      }
    });
  });
}); 

router.put('/register', function (req, res) {
  console.log('here');
  bcrypt.hash(req.body.password, 10, function(err, hash) {
    // save user
    model.registerUser(req.body.username, hash).then(function(response) {
      // created user
      if (response) {
        // TODO: Create api token for this user.
        res.json({
          auth: 'authkey',
          user_id: 0,
          username: req.body.username,
          status: 'success'
        })
      } else {
        res.json({
          status: 'taken'
        })
      }
    });
  });
});

// todo write check token method

module.exports = router;
