const model = require("../model.js");
const express = require('express');
const router = express.Router();

router.get('/hello', function (req, res) {  
  res.json({
    response: 'OK'
  });
});

module.exports = router;
