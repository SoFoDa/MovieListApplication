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
      let hash = user.password;
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
            error: 'Authentication error, invalid username or password',
            status: '403'
          });
        }
      });
    }).catch(err => {
      res.json({
        error: 'Bad authentication request',
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

router.get('/getMovieFromId', function(req, res) {
  model.getMovieFromId(req.query.movie_id).then(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data
      });
    }
  });
});

router.get('/searchMovie', function(req, res) {
  model.getMoviesFromTitle(req.query.title).then(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data
      });
    }
  });
});

// === VERIFY
const verifyToken = (req, res, next) => {
  let token = req.headers['authorization'];
  // check for undefined
  if (token) {
    if (token.startsWith('Bearer ')) {
      token = token.slice(7, token.length);
    }
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        res.json({
          status: '403',
          message: 'Token not valid'
        });
      } else {
        req.decoded = decoded;
        if (req.body.username == decoded.username && req.body.user_id == decoded.user_id) {
          next();
        } else {
          res.json({
            status: '403',
            message: 'Token does not match user'
          });
        }
      }
    });
  } else {
    res.json({
      status: '400',
      message: 'Token not supplied'
    });
  }
}

// === PROTECTED ROUTES

router.get('/userActivity', verifyToken, function(req, res) {
  model.getUserActivity(req.body.username).then(function(data) {
    if(data[0] != undefined) {
      res.json({
        status: '200',
        data: data[0].username
      });
    }
  });
});

module.exports = router;
