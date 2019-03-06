const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const omdb = require("../util/omdb.js");

/* Body params: 
* @username: The username
* @password: The password
*/
router.post('/authorize', function (req, res) { 
  let username = req.body.username;
  let device_id = req.headers.device_id;
  console.log('Auth user: ' + username);
  console.log('Device id: ' + device_id);
  if (username != undefined) {
    username = username.toLowerCase();
    model.getUser(username).then(function(user) {
      console.log(user);
      console.log('Pword: ' + user.password);
      let hash = user.password;
      bcrypt.compare(req.body.password, hash).then(function(correctHash) {
        if(correctHash) {
          // Auth token
          // Create a token
          const payload = { user_id: user.user_id, device_id: device_id };
          const options = { expiresIn: '2d' };
          const secret = process.env.JWT_SECRET;
          const token = jwt.sign(payload, secret, options);
          console.log("Successful login for user: " + user.user_id);
          res.json({
            token: token,
            user_id: user.user_id,
            status: '200'
          });
        } else {
          console.log("Invaluid username or password");
          res.json({
            user_id: -1,
            error: 'Authentication error, invalid username or password',
            status: '403'
          });
        }
      });
    }).catch(err => {
      console.log("User not found")
      res.json({
        error: 'Bad authentication request',
        status: '400'
      });
    });
  }
}); 

/* Body params: 
* @username: The username
* @password: The password
*/
router.put('/register', function (req, res) {
  bcrypt.hash(req.body.password, 10, function(err, hash) {
    // save user
    model.registerUser(req.body.username, hash).then(function(response) {
      console.log(response);
      // created user
      if (response) {
        res.json({
          status: '200'
        })
      } else {
        res.json({
          error: 'taken',
          status: '503'
        })
      }
    });
  });
});

/* URL params: 
* @movie_id: ID of the movie.
*/
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

/* URL params: 
* @title: Title of the movie
*/
router.get('/searchMovie', function(req, res) {
  model.getMoviesFromTitle(req.query.title).then(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data.body
      });
    }
  });
});

/* URL params: 
* @title: Title of the movie
*/
router.get('/omdb/movie', function(req, res) {
  let title = encodeURIComponent(req.query.title.replace(" ", "+"));
  let url = `http://www.omdbapi.com/?apikey=${process.env.OMDB_KEY}&t=${title}`;
  console.log(url);
  fetch(url, {
    json: true,
  }).then(res => res.json()
  ).then(data => { 
    res.json({
      data: data
    })
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
        console.log('Invalid token');
        res.json({
          status: '403',
          message: 'Token not valid'
        });
      } else {
        req.decoded = decoded;
        if (req.headers.device_id == decoded.device_id && req.body.user_id == decoded.user_id) {
          console.log('Verified token user');
          next();
        } else {
          console.log('Token not match user');
          res.json({
            status: '403',
            message: 'Token does not match user'
          });
        }
      }
    });
  } else {
    console.log('Token not supplied');
    res.json({
      status: '400',
      message: 'Token not supplied'
    });
  }
}

router.post('/handshake', verifyToken, function (req, res) {
  res.json({
    status: '200'
  })
});

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
