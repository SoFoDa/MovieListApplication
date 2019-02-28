/* jslint node: true */
"use strict";

const Sequelize = require('sequelize');
var config = require('./credentials')
const sequelize = new Sequelize(config.database, config.user, config.password, {
  host: config.host,
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

// ====== MODEL DEFINITIONS ======

const User = sequelize.define('user', {
    user_id: {
        type: Sequelize.INTEGER
    },
    password_hash: {
        type: Sequelize.STRING
    },
    username: {
        type: Sequelize.STRING
    }
});

const User_info = sequelize.define('user_info', {
    user_id: {
        type: Sequelize.INTEGER,
     
        references: {
          // This is a reference to another model
          model: User,
     
          // This is the column name of the referenced model
          key: 'user_id',
        }
    },
    name: {
        type: Sequelize.STRING
    },
    created: {
        type: Sequelize.DATE
    }
});

const Movie = sequalize.define('movie', {
    movie_id: {
        type: sequalize.INTEGER,
    }
})