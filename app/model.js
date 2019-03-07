/* jslint node: true */
"use strict";

const Sequelize = require('sequelize');
const Op = Sequelize.Op
// TODO FIX!!!!!!!!!!!!!!
//var config = require('./credentials');
//console.log(config.db);

const sequelize = new Sequelize(process.env.DB_DB, process.env.DB_USER, process.env.DB_PASSWORD, {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    operatorsAliases: false,

    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
});

sequelize
    .authenticate()
    .then(() => {
        console.log('Connection to database has been established successfully.');
    })
    .catch(err => {
        console.error('Unable to connect to the database:', err);
    });

// ====== MODEL DEFINITIONS START ======

const User = sequelize.define('User', {
    user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    password: {
        type: Sequelize.STRING
    },
    username: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const User_friend = sequelize.define('User_friend', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'User',
     
          key: 'user_id',
        }
    },
    friend_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'User',
     
          key: 'user_id',
        }
    },
}, {timestamps: false, freezeTableName: true})

const User_info = sequelize.define('User_info', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'User',
     
          key: 'user_id',
        }
    },
    name: {
        type: Sequelize.STRING
    },
    created: {
        type: Sequelize.DATE
    }
}, {timestamps: false, freezeTableName: true});

const Movie = sequelize.define('Movie', {
    movie_id: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    title: {
        type: Sequelize.STRING
    },
    runtime: {
        type: Sequelize.INTEGER
    }, 
    release_year: {
        type: Sequelize.INTEGER
    }, 
    poster_path: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Genre = sequelize.define('Genre', {
    genre_id: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    genre_type: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Director = sequelize.define('Director', {
    director_id: {
        type: Sequelize.INTEGER,
        primaryKey: true
    },
    name: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Movie_director = sequelize.define('Movie_director', {
    movie_id: {
        type: Sequelize.INTEGER,
        
        references: {
            model: 'movie',
       
            key: 'movie_id',
        }
    },
    director_id: {
        type: Sequelize.INTEGER,

        references: {
            model: 'Director',
       
            key: 'director_id',
        }
    }
}, {timestamps: false, freezeTableName: true});

const Movie_genre = sequelize.define('Movie_genre', {
    movie_id: {
        type: Sequelize.INTEGER,
        
        references: {
            model: 'movie',
       
            key: 'movie_id',
        }
    },
    genre_id: {
        type: Sequelize.INTEGER,

        references: {
            model: 'Genre',
       
            key: 'genre_id',
        }
    }
}, {timestamps: false, freezeTableName: true});


const Seen = sequelize.define('Seen', {
    user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
     
        references: {
          model: User,
     
          key: 'user_id',
        }
    },
    movie_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'Movie',
     
          key: 'movie_id',
        }
    },
    favourite: {
        type: Sequelize.BOOLEAN
    },
    rating: {
        type: Sequelize.INTEGER
    },
    date: {
        type: Sequelize.DATE
    }
}, {timestamps: false, freezeTableName: true})

const Activity = sequelize.define('Movie', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: User,
     
          key: 'user_id',
        }
    },
    activity_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'Activity_friend',
     
          key: 'activity_id',
        }
    },
    date: {
        type: Sequelize.INTEGER
    }
}, {timestamps: false, freezeTableName: true});

const Activity_friend = sequelize.define('Activity_friend', {
    activity_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'Activity',
     
          key: 'activity_id',
        }
    },
    friend_id: {
        type: Sequelize.INTEGER,

        references: {
            model: 'User',
       
            key: 'user_id',
          }
    }
}, {timestamps: false, freezeTableName: true})

const Activity_movie = sequelize.define('Activity_movie', {
    activity_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'Activity',
     
          key: 'activity_id',
        }
    },
    movie_id: {
        type: Sequelize.INTEGER,

        references: {
            model: 'movie',
       
            key: 'movie_id',
          }
    },
    type: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true})

// ====== MODEL DEFINITIONS END ======

module.exports.getUser = (username) => {
    console.log('Getting user: ' +  username);
    return User.findOne({
        attributes: ['user_id', 'username', 'password'],  
        where: {
            username: username
        }
    }).catch(err => {
        console.log(err);
        return undefined;
    })
}

module.exports.registerUser = (regUsername, regPassword) => {
    return User.create({username: regUsername, password: regPassword}).then(result => {
        console.log('Db registration success!');
        return true;
    }).catch(err => {
        console.log(err);
        return false;
    });
}

module.exports.getUserActivity = (user_id) => {
    return sequelize.query("CALL getUserActivity(?);", { replacements: [user_id], type: sequelize.QueryTypes.SELECT });
}

module.exports.getMovieFromId = (id) => {
    return Movie.findOne({
        where: {
            movie_id: id
        }  
    })
}

module.exports.getMoviesFromTitle = (mTitle) => {
    return Movie.findAll({
        where: {
            title: {[Op.like]: '%'  + mTitle + '%'}
        },
        limit: 10,
        order: [
            ['title', 'DESC']
        ]
    })
}

module.exports.getSeenMovies = (user_id) => {
    return sequelize.query("CALL getSeenMovies(?);", { replacements: [user_id], type: sequelize.QueryTypes.SELECT });
}

module.exports.setSeenMovie = (muser_id, mmovie_id, mseen) => {
    let type = (mseen == 'true');
    Seen.findOne({
        where: {
            movie_id: mmovie_id,
            user_id: muser_id
        }
    }).then((entry) => {
        if (entry != undefined && !type) {
            Seen.destroy({
                where: {
                    movie_id: mmovie_id,
                    user_id: muser_id
                }
            })
        } else if (entry == undefined && type) {
            const newEntry = Seen.build({
                user_id: muser_id,
                movie_id: mmovie_id,
                date: Date.now()
            });
            newEntry.save();
        }
    })
}

module.exports.addMovie = async (movie) => {
    let dbEntry = {
        title: movie.Title, 
        runtime: parseInt(movie.Runtime.split(" ")[0]),
        release_year: parseInt(movie.Year), 
        poster_path: '',
    };

    // try to add genres and directors
    /*
    movie.Genre.split(",").map(genre => {
        if(genre.startsWith(" ")) {
            await Genre.create({'genre_type': genre.slice(1)}).catch(err);
        }
        await Genre.create({'genre_type': genre}).catch(err);
    });
    movie.Director.split(",").map(director => {
        if(director.startsWith(" ")) {
            await Genre.create({'genre_type': director.slice(1)}).catch(err);
        }
        await Director.create({'genre_type': director}).catch(err);
    });

    // many to many relation
    await Movie_director.create({});
    await Movie_genre.create({});
    */

    Movie.create(dbEntry).then(result => {
        console.log('Movie added!');
        return true;
    }).catch(err => {
        console.log(err);
        return false;
    });
}

module.exports.getMovieGenres = async (movie_id) => {
    return sequelize.query("CALL getGenres(?);", { replacements: [movie_id], type: sequelize.QueryTypes.SELECT });
}

module.exports.getMovieDirectors = async (movie_id) => {
    return sequelize.query("CALL getDirectors(?);", { replacements: [movie_id], type: sequelize.QueryTypes.SELECT });
}
