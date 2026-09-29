import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/warm_gradient_background.dart';
import '../../data/agenda_api.dart';
import '../../data/task_model.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, this.task});

  final TaskModel? task;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _agendaApi = AgendaApi();
  DateTime? _dueDate;
  String _status = 'pending';
  bool _saving = false;

  bool get _editing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _title.text = widget.task?.title ?? '';
    _description.text = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate;
    _status = widget.task?.status ?? 'pending';
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _dueDate = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    final task = TaskModel(
      id: widget.task?.id ?? '',
      title: _title.text.trim(),
      description: _description.text.trim(),
      dueDate: _dueDate,
      status: _status,
    );

    try {
      if (_editing) {
        await _agendaApi.updateTask(task);
      } else {
        await _agendaApi.createTask(task);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_cleanError(error))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _cleanError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_editing ? 'Editar tarea' : 'Nueva tarea'),
        backgroundColor: AppColors.mutedMagenta,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: WarmGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _title,
                    maxLength: 120,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xEFFFFFFF),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Escribe un título'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _description,
                    maxLength: 1000,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xEFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      prefixIcon: Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xEFFFFFFF),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pendiente'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completada'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _status = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                      _dueDate == null
                          ? 'Agregar fecha límite'
                          : 'Vence: ${_dueDate!.toLocal().toString().split(' ').first}',
                    ),
                  ),
                  if (_dueDate != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _dueDate = null),
                        child: const Text('Quitar fecha'),
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_editing ? 'Guardar cambios' : 'Crear tarea'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
