const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'El titulo es obligatorio'],
      trim: true,
      minlength: 1,
      maxlength: 120
    },
    description: {
      type: String,
      trim: true,
      maxlength: 1000,
      default: ''
    },
    dueDate: {
      type: Date,
      default: null
    },
    status: {
      type: String,
      enum: ['pending', 'completed'],
      default: 'pending'
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model('Task', taskSchema);