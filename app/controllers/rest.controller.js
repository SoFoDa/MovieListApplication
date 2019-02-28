const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

router.get('/hello', function (req, res) {  
  res.json({
    response: 'OK'
  });
});

module.exports = router;
