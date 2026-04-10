import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool showStrikethrough;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
    this.onEdit,
    this.showStrikethrough = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: task.isCompleted ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(5.r),
                  border: task.isCompleted
                      ? null
                      : Border.all(
                          color: isDark
                              ? const Color(0xFF555555)
                              : const Color(0xFFCCCCCC),
                          width: 1.5,
                        ),
                ),
                child: task.isCompleted
                    ? Icon(Icons.check_rounded,
                        size: 14.sp, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(width: 12.w),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? AppColors.textGrey
                          : textColor,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: AppColors.textGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (task.description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
            // Options menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  size: 20.sp, color: AppColors.textGrey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              itemBuilder: (_) => [
                if (!task.isCompleted)
                  PopupMenuItem(
                    value: 'complete',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 18.sp, color: AppColors.primary),
                        SizedBox(width: 8.w),
                        Text('Mark Complete',
                            style: TextStyle(fontSize: 13.sp)),
                      ],
                    ),
                  ),
                if (task.isCompleted)
                  PopupMenuItem(
                    value: 'undo',
                    child: Row(
                      children: [
                        Icon(Icons.undo_rounded,
                            size: 18.sp, color: AppColors.textGrey),
                        SizedBox(width: 8.w),
                        Text('Mark Incomplete',
                            style: TextStyle(fontSize: 13.sp)),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 18.sp, color: Colors.redAccent),
                      SizedBox(width: 8.w),
                      Text('Delete',
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
              onSelected: (val) {
                if (val == 'complete' || val == 'undo') {
                  onToggle();
                } else if (val == 'delete') {
                  onDelete?.call();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
