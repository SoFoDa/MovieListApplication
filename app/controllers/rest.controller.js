const model = require("../model.js");
const Assistant = require('../models/assistant.model');
const TimeSlot = require('../models/timeslot.model');
const express = require('express');
const router = express.Router();

router.get('/assistantList', function (req, res) {  
  model.getAssistants().then(function(dbResult) {
    let assistant_dick = {};      
    for (let j = 0; j < dbResult.length; j++) {      
      const assistant = dbResult[j];
      assistant_dick[assistant.id] = {name: assistant.name, time_slots: []};
    } 
    model.getTimeSlots().then(function(time_slots) {
      for (let i = 0; i < time_slots.length; i++) {
        assistant_dick[time_slots[i].assistant_id]['time_slots'].push(time_slots[i]);
      }

      res.json({        
        list: assistant_dick
      })      
    })
  })
});

router.get('/getAssistant', function (req, res) {    
  model.getAssistantID(req.query.name).then(function(dbResult) {
    console.log(dbResult);
    model.getAssistantTimeSlot(dbResult.id).then(function(time_slots) {
      res.json({
        name: req.query.name,
        time_slots: time_slots
      });
    })
  });  
});

router.post('/setTimeSlotStatus', function (req, res) {
  model.getAssistantID(req.body.assistant).then(function(id) {
    console.log("bookedBY: " + req.body.bookedBy);
    console.log("booked_by: " + req.body.booked_by);
    model.updateTimeSlotStatus(id.id, req.body.time, req.body.status, req.body.bookedBy);
    res.json({
      result: 'OK'
    });
  })
});

router.post('/addTimeSlot', function (req, res) {
  model.getAssistantID(req.body.assistant).then(function(id) {
    model.insertTimeSlot(id.id, req.body.time);
    res.json({
      result: 'OK'
    });
  })
});

router.post('/removeTimeSlot', function (req, res) {
  model.getAssistantID(req.body.assistant).then(function(id) {
    model.deleteTimeSlot(id.id, req.body.time);
    res.json({
      result: 'OK'
    });
  })
});

router.get('/timeSlotExists', function(req, res) {
  model.getAssistantID(req.query.name).then(function(id) {    
    model.getTimeSlot(id.id, req.query.newTime).then(function(timeSlot) {
      if(timeSlot.length !== 0){
        res.json({
          result: 'true'
        });     
      } else {
        res.json({
          result: 'false'
        });
      }
    })
  })
});

module.exports = router;
