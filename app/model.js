/* jslint node: true */
"use strict";

const Sequelize = require('sequelize');
const Op = Sequelize.Op
// TODO FIX!!!!!!!!!!!!!!
var config = require('./credentials');
console.log(config.db);

const sequelize = new Sequelize('mydb', 'root', 'korvar123', {
    host: 'localhost',
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

const User = sequelize.define('user', {
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

const User_friend = sequelize.define('user_friend', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'user',
     
          key: 'user_id',
        }
    },
    friend_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'user',
     
          key: 'user_id',
        }
    },
}, {timestamps: false, freezeTableName: true})

const User_info = sequelize.define('user_info', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'user',
     
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

const Movie = sequelize.define('movie', {
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
    genre: {
        type: Sequelize.STRING
    }, 
    release_year: {
        type: Sequelize.INTEGER
    }, 
    director: {
        type: Sequelize.STRING
    }
}, {timestamps: false, freezeTableName: true});

const Seen = sequelize.define('seen', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: User,
     
          key: 'user_id',
        }
    },
    movie_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'movie',
     
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

const Activity = sequelize.define('movie', {
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
          model: 'activity_friend',
     
          key: 'activity_id',
        }
    },
    date: {
        type: Sequelize.INTEGER
    }
}, {timestamps: false, freezeTableName: true});

const Activity_friend = sequelize.define('activity_friend', {
    activity_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'activity',
     
          key: 'activity_id',
        }
    },
    friend_id: {
        type: Sequelize.INTEGER,

        references: {
            model: 'user',
       
            key: 'user_id',
          }
    }
}, {timestamps: false, freezeTableName: true})

const Activity_movie = sequelize.define('activity_movie', {
    activity_id: {
        type: Sequelize.INTEGER,
     
        references: {
          model: 'activity',
     
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
    return User.findOne({
        attributes: ['user_id', 'username', 'password'],  
        where: {
            username: username
        }  
    })
}

module.exports.registerUser = (regUsername, regPassword) => {
    return User.create({username: regUsername, password: regPassword}).then(result => {
        console.log('success');
    }).catch(err => {
        return false;
    });
}

module.exports.getUserActivity = (username) => {
    // TODO sql injection risk?
    return sequelize.query("CALL getUserActivity('" + username + "');");
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
        }  
    })
}
