const express = require('express');
const {
  listTasks,
  createTask,
  updateTask,
  deleteTask
} = require('../controllers/task.controller');
const requireAuth = require('../middleware/auth.middleware');

const router = express.Router();

router.use(requireAuth);
router.get('/', listTasks);
router.post('/', createTask);
router.put('/:id', updateTask);
router.delete('/:id', deleteTask);

module.exports = router;