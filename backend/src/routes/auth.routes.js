const express = require('express');
const {
  register,
  login,
  forgotPassword,
  resetPassword,
  logout,
  getProfile
} = require('../controllers/auth.controller');
const requireAuth = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/forgot-password', forgotPassword);
router.post('/reset-password', resetPassword);
router.post('/logout', requireAuth, logout);
router.get('/profile', requireAuth, getProfile);

module.exports = router;
