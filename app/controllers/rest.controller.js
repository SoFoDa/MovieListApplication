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
      console.log("User not found");
      console.log(err);
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
* @full_name: User's full name
*/
router.put('/register', function (req, res) {
  bcrypt.hash(req.body.password, 10, function(err, hash) {
    // save user
    model.registerUser(req.body.full_name, req.body.username, hash).then(function(response) {
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
* @user_id: ID of the user.
*/
router.get('/getUserInfo', function(req, res) {  
  model.getUserInfo(req.query.user_id).spread(function(data, metadata) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data[0]
      });
    }
  });
});


/* URL params: 
* @user_id: ID of the user.
* TODO make protected
*/
router.get('/seenMovies', function(req, res) {
  model.getSeenMovies(req.query.user_id).spread(function(data, metadata) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data
      });
    }
  });
});

/* URL params: 
* @movie_id: ID of the movie.
*/
router.get('/getMovieDirectors', function(req, res) {
  model.getMovieDirectors(req.query.movie_id).then(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data
      });
    }
  });
});

/* URL params: 
* @movie_id: ID of the movie.
*/
router.get('/getMovieGenres', function(req, res) {
  model.getMovieGenres(req.query.movie_id).then(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data
      });
    }
  });
});

/* URL params: 
* @user_id: ID of the user.
*/
router.get('/getFollowerAmount', function(req, res) {  
  model.getFollowerAmount(req.query.user_id).spread(function(data, metadata) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data[0]
      });
    }
  });
});

/* URL params: 
* @user_id: ID of the user.
* @movie_id: ID of the movie
*/
router.get('/isSeen', function(req, res) {  
  model.isSeen(req.query.user_id, req.query.movie_id).spread(function(data) {
    if(data != undefined) {
      res.json({
        status: '200',
        data: data[0]
      });
    }
  });
});

/* URL params: 
* @user_id: ID of the user.
* @movie_id: ID of the movie
*/
router.get('/getSeenFollowed', function(req, res) {  
  model.getSeenFollowed(req.query.user_id, req.query.movie_id).spread(function(data) {
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
router.get('/searchMovie', async function(req, res) {
  // in db, fetch movies its genres and directors and send it!
  let title = req.query.title;

  // separate year and title if exists
  let match = title.match("(19[0-9][0-9]|20[0-2][0-9])");
  let omdbEntry = await omdb.getMovieByTitle(req.query.title);
  if (match !== null) {
    title = title.replace(match[0], "");
    omdbEntry = await omdb.getMovieByTitle(title, parseInt(match[0]));
  }
  if (title.endsWith(" ")) {
    title = title.substring(0, title.length - 1);
  }
  model.getMoviesFromTitle(title).then(async (result) => {
    // build json object from db results
    let inDb = false;
    let jsonObject = [];
    if(result !== undefined) {
      console.log("Similar movie found in db! len: " + result.length);
      for (let i = 0; i < result.length; i++) {
        const movie = result[i];
        // don't want to show the same movie twice.
        if (omdbEntry !== null && (omdbEntry.title === movie.title) && (omdbEntry.release_year === movie.release_year)) {
          console.log('In db!');
          inDb = true;
        }

        let jsonMovie = {
          'movie_id': movie.movie_id,
          'title': movie.title,
          'runtime': movie.runtime,
          'release_year': movie.release_year,
          'genres': [],
          'directors': [],
          'poster_path': movie.poster_path,
        };
        let genres = await model.getMovieGenres(movie.movie_id);
        let directors = await model.getMovieDirectors(movie.movie_id);
        for (let key in genres[0]) {
          jsonMovie['genres'].push(genres[0][key].genre_type);
        }
        for (let key in directors[0]) {
          jsonMovie['directors'].push(directors[0][key].name);
        }
        jsonObject.push(jsonMovie);
      }
    }
    if (!inDb) {
      console.log('Movie not in db, trying to add...');
      if(omdbEntry !== null) {
        let mov = await model.addMovie(omdbEntry);
        if (mov !== undefined) {
          omdbEntry['movie_id'] = mov.movie_id;
          jsonObject.unshift(omdbEntry);
        }
      }
    }
    res.json({
      status: '200',
      data: jsonObject,
    });
  });
});

/* URL params: 
* @title: Title of the movie
*/
router.get('/omdb/movie', function(req, res) {
  omdb.getMovieByTitle(req.query.title).then(function(data) {
    res.json({
      data: data,
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
        //console.log(req.headers.device_id);
        //console.log(decoded.device_id);
        //console.log(req.headers.user_id);
        //console.log(decoded.user_id);
        if (req.headers.device_id === decoded.device_id && parseInt(req.headers.user_id) === decoded.user_id) {
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

/* 
* Get the users followers activity
*/
router.get('/friendsActivity', verifyToken, function(req, res) {
  model.getUserActivity(req.headers.user_id).spread(function(result, metadata) {
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

/* 
* Set a movie to seen for user
*/
router.post('/setSeen', verifyToken, function(req, res) {
  model.setSeenMovie(req.headers.user_id, req.body.movie_id, req.body.seen_status);
  res.json({
    status: '200'
  })
});

/* 
* Get user stats
*/
router.get('/userStats', verifyToken, function(req, res) {
  model.getUserStats(req.headers.user_id).then(function(result) {
    if(result != undefined) {
      console.log(result.runtime);
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

module.exports = router;
