import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../logic/task_cubit/task_cubit.dart';
import 'package:uuid/uuid.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isHighPriority = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'e.g. Finish UI design',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Task Description', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Description here...',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('High Priority', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                value: _isHighPriority,
                onChanged: (val) => setState(() => _isHighPriority = val),
                activeThumbColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                final task = TaskModel(
                  id: const Uuid().v4(),
                  title: _titleController.text,
                  description: _descController.text,
                  isHighPriority: _isHighPriority,
                  createdAt: DateTime.now(),
                );
                context.read<TaskCubit>().addTask(task);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('+ Add Task'),
          )
        ],
      ),
    );
  }
}
