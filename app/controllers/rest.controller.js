const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

router.get('/hello', function (req, res) {  
  bcrypt.hash('korvar123', 10, function(err, hash) {
    console.log(hash);
  });
  res.json({
    response: 'OK'
  });
});

module.exports = router;
