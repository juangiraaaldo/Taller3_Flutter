const mongoose = require('mongoose');

async function connectDatabase() {
  if (!process.env.MONGO_URI) {
    throw new Error('La variable MONGO_URI no esta configurada');
  }

  await mongoose.connect(process.env.MONGO_URI);
  console.log('MongoDB conectado');
}

module.exports = connectDatabase;
