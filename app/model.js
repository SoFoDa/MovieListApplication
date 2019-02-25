/* jslint node: true */
"use strict";

const Assistant = require('./models/assistant.model');
const TimeSlot = require('./models/timeslot.model');
const assistantList = [];

// ==== DB INIT
const Sequelize = require('sequelize');
const sequelize = new Sequelize('korvar', 'root', 'korvar123', {
  host: 'localhost',
  dialect: 'mysql',
  operatorsAliases: false,

  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
});

const Assistants = sequelize.define('assistants', {
  id: {
    type: Sequelize.INTEGER, primaryKey: true
  },
  name: {
    type: Sequelize.STRING
  }}, {
  timestamps: false,
});

const TimeSlots = sequelize.define('time_slots', {
  timestamps: false,
  id: {
    type: Sequelize.INTEGER, primaryKey: true
  },  
  assistant_id: {
    type: Sequelize.INTEGER,
 
    references: {
      // This is a reference to another model
      model: Assistants,
 
      // This is the column name of the referenced model
      key: 'id',
    }
  },
  time: {
    type: Sequelize.STRING
  },
  status: {
    type: Sequelize.STRING    
  },
  booked_by: {
    type: Sequelize.STRING    
  }}, {
    timestamps: false,
});


module.exports.getAssistants = () => {
  return Assistants.findAll({
    attributes: ['id', 'name'],    
  })
}

module.exports.getAssistantTimeSlot = (id) => {
  return TimeSlots.findAll({
    attributes: ['time', 'status', 'booked_by'],
    where: {
      assistant_id: id,
    } 
  })
}

module.exports.getTimeSlots = () => {
  return TimeSlots.findAll({
    attributes: ['assistant_id', 'time', 'status', 'booked_by']
  })
}

module.exports.getTimeSlot = (id, time) => {
  return TimeSlots.findAll({
    attributes: ['assistant_id', 'time', 'status', 'booked_by'],
    where: {
      assistant_id: id,
      time: time
    }
  })  
}

module.exports.getAssistantID = (name) => {
  return Assistants.findOne({
    attributes: ['id'],
    where: {
      name: name
    }
  })
}

// == TIME SLOT MANIPULATION ==
module.exports.insertTimeSlot = (id, time) => {
  TimeSlots
    .build({
      assistant_id: id,
      time: time,
      status: 'free',
      booked_by: ''
    })
    .save()
}

module.exports.deleteTimeSlot = (id, time) => {
  TimeSlots.destroy({
    where: {
      assistant_id: id,
      time: time,
    }
  })
}

module.exports.updateTimeSlotStatus = (id, time, status, bookedBy) => {
  console.log(bookedBy);
  return TimeSlots.update({
    status: status,
    booked_by: bookedBy,
  }, {
    where: {
      assistant_id: id,
      time: time
    }
  });
}
