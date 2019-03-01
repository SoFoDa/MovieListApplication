const model = require("../model.js");
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

router.post('/authenticate', function (req, res) { 
  // TODO load db hash 
  let hash = '123';
  bcrypt.compare(req.body.password, hash).then(function(correctHash) {
    if(correctHash) {
      res.json({
        auth: 'authkey',
        username: 'username',
        user_id: 'user_id',
        name: 'Johan',
      });
    } else {
      res.json({
        auth: '',
        username: '',
        user_id: '0',
        name: '',
      });
    }
  });
}); 

module.exports = router;
