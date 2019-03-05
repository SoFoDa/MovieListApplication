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
          const payload = { username: user.username.toLowerCase(), user_id: user.user_id };
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
        if (req.body.username.toLowerCase() == decoded.username && req.body.user_id == decoded.user_id) {
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

// === PROTECTED ROUTES ===
//
// ALL REQUESTS BELOW THIS NEEDS A HEADER WITH THE FOLLOWING FORMAT:
// authentication: Bearer $token
// IMPORTANT: lower case a in authentication.
//
// You also NEED to have username and user_id in body.
// username: $username
// user_id: $user id

/* Body params: 
* @user_id: The user
* @username: The username
*/
router.get('/userActivity', verifyToken, function(req, res) {
  model.getUserActivity(req.body.user_id).spread(function(result, metadata) {
    if(result != undefined) {
      res.json({
        status: '200',
        data: result
      });
    } else {
      res.json({
        status: '500',
      })
    }
  });
});

/* Body params: 
* @user_id: The user id
* @username: The username
*/
router.get('/seenMovies', verifyToken, function(req, res) {
  model.getSeenMovies(req.body.user_id).spread(function(result, metadata) {
    if(result != undefined) {
      res.json({
        status: '200',
        data: result
      });
    }
  });
});

/* Body params: 
* @user_id: The user id
* @username: The username
* @movie_id: The movie
* @seen_status: true -> seen, false -> not seen
*/
router.post('/setSeen', verifyToken, function(req, res) {
  model.setSeenMovie(req.body.user_id, req.body.movie_id, req.body.seen_status);
  res.json({
    status: '200'
  })
});

module.exports = router;
