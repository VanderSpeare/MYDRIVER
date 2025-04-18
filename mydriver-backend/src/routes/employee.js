const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employeeController');

router.get('/tasks', employeeController.getTasks);
router.post('/complete-task', employeeController.completeTask);

module.exports = router;