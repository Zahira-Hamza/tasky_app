import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../logic/task_cubit/task_cubit.dart';

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
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a task name'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: _descController.text.trim(),
      isHighPriority: _isHighPriority,
      createdAt: DateTime.now(),
    );
    context.read<TaskCubit>().addTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Task',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name
            Text(
              'Task Name',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 14.sp, color: textColor),
              decoration: const InputDecoration(
                hintText: 'Finish UI design for login screen',
              ),
            ),
            SizedBox(height: 22.h),

            // Task Description
            Text(
              'Task Description',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _descController,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 14.sp, color: textColor),
              decoration: const InputDecoration(
                hintText:
                    'Finish onboarding UI and hand off to devs by Thursday.',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 22.h),

            // High Priority toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'High Priority',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Switch(
                  value: _isHighPriority,
                  onChanged: (val) => setState(() => _isHighPriority = val),
                ),
              ],
            ),

            SizedBox(height: 48.h),

            // Add Task button
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: _addTask,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Add Task',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
