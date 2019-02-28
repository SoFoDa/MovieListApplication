const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

router.get('/hello', function (req, res) {  
  model.getUsers().then(function(data) {
    res.json({
      response: data
    });
  })
}); 

module.exports = router;
