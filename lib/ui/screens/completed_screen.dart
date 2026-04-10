import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import '../widgets/task_tile.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Completed Tasks',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            final completed = state.completedTasks;

            if (completed.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hourglass_empty_rounded,
                        size: 60.sp, color: AppColors.textGrey),
                    SizedBox(height: 14.h),
                    Text(
                      'No completed tasks yet.\nKeep going! 💪',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.sp, color: AppColors.textGrey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: completed.length,
              itemBuilder: (context, index) {
                final t = completed[index];
                return TaskTile(
                  task: t,
                  onToggle: () => context
                      .read<TaskCubit>()
                      .updateTask(t.copyWith(isCompleted: false)),
                  onDelete: () =>
                      context.read<TaskCubit>().deleteTask(t.id),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
