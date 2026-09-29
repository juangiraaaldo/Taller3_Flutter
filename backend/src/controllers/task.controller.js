const mongoose = require('mongoose');
const Task = require('../models/Task');

function isValidDate(value) {
  return value == null || value === '' ||
    (typeof value === 'string' && !Number.isNaN(new Date(value).getTime()));
}

async function listTasks(req, res) {
  try {
    const tasks = await Task.find({ user: req.user._id }).sort({
      dueDate: 1,
      createdAt: -1
    });
    return res.json({ tasks });
  } catch (error) {
    console.error('Error al listar tareas:', error);
    return res.status(500).json({ message: 'Error al cargar las tareas' });
  }
}

async function createTask(req, res) {
  try {
    const { title, description = '', dueDate = null, status = 'pending' } = req.body;
    if (typeof title !== 'string' || !title.trim()) {
      return res.status(400).json({ message: 'El titulo es obligatorio' });
    }
    if (
      typeof description !== 'string' ||
      !isValidDate(dueDate) ||
      !['pending', 'completed'].includes(status)
    ) {
      return res.status(400).json({ message: 'Los datos de la tarea no son validos' });
    }

    const task = await Task.create({
      title: title.trim(),
      description: description.trim(),
      dueDate: dueDate || null,
      status,
      user: req.user._id
    });
    return res.status(201).json({ task });
  } catch (error) {
    console.error('Error al crear tarea:', error);
    if (error.name === 'ValidationError') {
      return res.status(400).json({ message: 'Los datos de la tarea no son validos' });
    }
    return res.status(500).json({ message: 'Error al crear la tarea' });
  }
}

async function updateTask(req, res) {
  try {
    if (!mongoose.isValidObjectId(req.params.id)) {
      return res.status(404).json({ message: 'Tarea no encontrada' });
    }

    const updates = {};
    const { title, description, dueDate, status } = req.body;

    if (title !== undefined) {
      if (typeof title !== 'string' || !title.trim()) {
        return res.status(400).json({ message: 'El titulo no puede estar vacio' });
      }
      updates.title = title.trim();
    }
    if (description !== undefined) {
      if (typeof description !== 'string') {
        return res.status(400).json({ message: 'La descripcion no es valida' });
      }
      updates.description = description.trim();
    }
    if (dueDate !== undefined) {
      if (!isValidDate(dueDate)) {
        return res.status(400).json({ message: 'La fecha no es valida' });
      }
      updates.dueDate = dueDate || null;
    }
    if (status !== undefined) {
      if (!['pending', 'completed'].includes(status)) {
        return res.status(400).json({ message: 'El estado no es valido' });
      }
      updates.status = status;
    }
    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ message: 'No hay cambios para guardar' });
    }

    const task = await Task.findOneAndUpdate(
      { _id: req.params.id, user: req.user._id },
      { $set: updates },
      { new: true, runValidators: true }
    );
    if (!task) return res.status(404).json({ message: 'Tarea no encontrada' });
    return res.json({ task });
  } catch (error) {
    console.error('Error al actualizar tarea:', error);
    if (error.name === 'ValidationError') {
      return res.status(400).json({ message: 'Los datos de la tarea no son validos' });
    }
    return res.status(500).json({ message: 'Error al actualizar la tarea' });
  }
}

async function deleteTask(req, res) {
  try {
    if (!mongoose.isValidObjectId(req.params.id)) {
      return res.status(404).json({ message: 'Tarea no encontrada' });
    }

    const task = await Task.findOneAndDelete({
      _id: req.params.id,
      user: req.user._id
    });
    if (!task) return res.status(404).json({ message: 'Tarea no encontrada' });
    return res.json({ message: 'Tarea eliminada correctamente' });
  } catch (error) {
    console.error('Error al eliminar tarea:', error);
    return res.status(500).json({ message: 'Error al eliminar la tarea' });
  }
}

module.exports = { listTasks, createTask, updateTask, deleteTask };