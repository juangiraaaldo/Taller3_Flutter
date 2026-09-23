const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

function createToken(user) {
  return jwt.sign(
    {
      id: user._id.toString(),
      email: user.email
    },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );
}

function publicUser(user) {
  return {
    id: user._id,
    name: user.name,
    email: user.email
  };
}

async function register(req, res) {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        message: 'Nombre, correo y contrasena son obligatorios'
      });
    }

    if (name.trim().length < 2 || password.length < 6) {
      return res.status(400).json({
        message: 'El nombre debe tener al menos 2 caracteres y la contrasena 6'
      });
    }

    const normalizedEmail = email.trim().toLowerCase();
    if (!/^\S+@\S+\.\S+$/.test(normalizedEmail)) {
      return res.status(400).json({ message: 'El correo no es valido' });
    }

    const existingUser = await User.findOne({ email: normalizedEmail });

    if (existingUser) {
      return res.status(409).json({ message: 'El correo ya esta registrado' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      name,
      email: normalizedEmail,
      password: hashedPassword
    });

    return res.status(201).json({
      message: 'Usuario registrado correctamente',
      token: createToken(user),
      user: publicUser(user)
    });
  } catch (error) {
    console.error('Error al registrar el usuario:', error);
    return res.status(500).json({ message: 'Error al registrar el usuario' });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: 'Correo y contrasena son obligatorios'
      });
    }

    const user = await User.findOne({ email: email.trim().toLowerCase() })
      .select('+password');

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: 'Credenciales invalidas' });
    }

    return res.json({
      message: 'Inicio de sesion exitoso',
      token: createToken(user),
      user: publicUser(user)
    });
  } catch (error) {
    console.error('Error al iniciar sesion:', error);
    return res.status(500).json({ message: 'Error al iniciar sesion' });
  }
}

async function forgotPassword(req, res) {
  try {
    const normalizedEmail = req.body.email?.trim().toLowerCase();
    const genericResponse = {
      message: 'Si el correo existe, recibiras instrucciones para recuperar la contrasena'
    };

    if (!normalizedEmail || !/^\S+@\S+\.\S+$/.test(normalizedEmail)) {
      return res.json(genericResponse);
    }

    const user = await User.findOne({ email: normalizedEmail }).select(
      '+passwordResetToken +passwordResetExpires'
    );

    if (!user) return res.json(genericResponse);

    const resetToken = crypto.randomBytes(32).toString('hex');
    user.passwordResetToken = crypto
      .createHash('sha256')
      .update(resetToken)
      .digest('hex');
    user.passwordResetExpires = Date.now() + 15 * 60 * 1000;
    await user.save();

    console.log(
      `Enlace de recuperacion para ${normalizedEmail}: /reset-password?token=${resetToken}`
    );
    return res.json(genericResponse);
  } catch (error) {
    console.error('Error al solicitar recuperacion:', error);
    return res.status(500).json({ message: 'Error al solicitar recuperacion' });
  }
}

async function resetPassword(req, res) {
  try {
    const { token, password } = req.body;

    if (!token || !password || password.length < 6) {
      return res.status(400).json({
        message: 'El token es obligatorio y la contrasena debe tener al menos 6 caracteres'
      });
    }

    const hashedToken = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');
    const user = await User.findOne({
      passwordResetToken: hashedToken,
      passwordResetExpires: { $gt: new Date() }
    }).select('+passwordResetToken +passwordResetExpires');

    if (!user) {
      return res.status(400).json({ message: 'El token no es valido o ya expiro' });
    }

    user.password = await bcrypt.hash(password, 10);
    user.passwordResetToken = undefined;
    user.passwordResetExpires = undefined;
    await user.save();

    return res.json({ message: 'Contrasena actualizada correctamente' });
  } catch (error) {
    console.error('Error al restablecer la contrasena:', error);
    return res.status(500).json({ message: 'Error al restablecer la contrasena' });
  }
}

async function getProfile(req, res) {
  return res.json({ user: publicUser(req.user) });
}

function logout(req, res) {
  return res.json({ message: 'Sesion cerrada correctamente' });
}

module.exports = {
  register,
  login,
  forgotPassword,
  resetPassword,
  logout,
  getProfile
};
