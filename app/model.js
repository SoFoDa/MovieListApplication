/* jslint node: true */
"use strict";

const Sequelize = require('sequelize');
const Op = Sequelize.Op
const download = require('image-downloader')

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
        primaryKey: true,
        autoIncrement: true,
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
        primaryKey: true,
        autoIncrement: true,
    },
    genre_type: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Director = sequelize.define('Director', {
    director_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    name: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Movie_director = sequelize.define('Movie_director', {
    movie_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        
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
        primaryKey: true,
        
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

module.exports.getMoviesFromTitle = async (mTitle) => {
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

module.exports.addMovie = async (dbEntry) => {
    // last check if it already is in db
    let dbCheck = await module.exports.getMoviesFromTitle(dbEntry.title);
    if(dbCheck.length > 0 && dbCheck[0].title == dbEntry.title && dbCheck[0].release_year ==  dbEntry.release_year) {
        return;
    }
    // download  image
    let posterName = dbEntry.title.replace(/\s+/g, "-").toLowerCase() + dbEntry.release_year + '.jpg';
    const options = {
        url: dbEntry.poster_path,
        dest: 'app/resources/posters/' + posterName                  
    }
    try {
        const { filename, image } = await download.image(options);
        dbEntry.poster_path = posterName;
    } catch (e) {
        dbEntry.poster_path = '';
        console.error(e)
    }

    return Movie.create(dbEntry).then(async () => {
        // movie table
        return sequelize.transaction(async function (t) {
            console.log('Began transaction');
            // chain all your queries here. make sure you return them.
            let movie = await Movie.findOne({
                where: {
                    title: dbEntry.title,
                    release_year: dbEntry.release_year,
                }
            });
            console.log('Found movie id');
            let promises = [];
            for (let i = 0; i < dbEntry.genres.length; i++) {
                promises.push(await Genre.findOrCreate({
                    where: {
                        genre_type: dbEntry.genres[i]
                    },
                    transaction: t
                }).spread(async (genreEntry, created) => {
                    await Movie_genre.create({'movie_id': movie.movie_id, 'genre_id': genreEntry.genre_id}, {transaction: t}).catch(err => cosnsole.log(err));
                }));
            }
            console.log('Added genres');
            for (let i = 0; i < dbEntry.directors.length; i++) {
                promises.push(await Director.findOrCreate({
                    where: {
                        name: dbEntry.directors[i]
                    },
                    transaction: t
                }).spread(async (directorEntry, created) => {
                    await Movie_director.create({'movie_id': movie.movie_id, 'director_id': directorEntry.director_id}, {transaction: t}).catch(err => cosnsole.log(err));
                }));
            }
            console.log('Added directors');
            return Promise.all(promises);
            }).then(function (result) {
                console.log('Movie added!');
                return true;
            }).catch(function (err) {
                console.log(err);
                // Transaction has been rolled back
                // err is whatever rejected the promise chain returned to the transaction callback
        });
    }).catch(err => console.log('Error: movie might already be in db: ' + err));
}

module.exports.getMovieGenres = async (movie_id) => {
    return sequelize.query("CALL getGenres(?);", { replacements: [movie_id], type: sequelize.QueryTypes.SELECT });
}

module.exports.getMovieDirectors = async (movie_id) => {
    return sequelize.query("CALL getDirectors(?);", { replacements: [movie_id], type: sequelize.QueryTypes.SELECT });
}
