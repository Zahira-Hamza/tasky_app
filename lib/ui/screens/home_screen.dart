import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/user_repository.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import '../../logic/theme_cubit/theme_cubit.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/task_tile.dart';
import 'new_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  String _quote = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<TaskCubit>().loadTasks();
  }

  Future<void> _loadUser() async {
    final repo = sl<UserRepository>();
    final name = await repo.getUserName();
    final quote = await repo.getMotivationQuote();
    if (mounted)
      setState(() {
        _userName = name;
        _quote = quote;
      });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            final tasks = state is TaskLoaded ? state.tasks : <dynamic>[];
            final achieved =
                state is TaskLoaded ? state.achievedTasks.length : 0;
            final total = state is TaskLoaded ? tasks.length : 0;
            final percent = total > 0 ? achieved / total : 0.0;
            final highPriority =
                state is TaskLoaded ? state.highPriorityTasks : [];
            final myTasks = state is TaskLoaded ? state.myTasks : [];

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // ─── Header ───────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                        child: Row(
                          children: [
                            ProfileAvatar(radius: 22, onChanged: _loadUser),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$_greeting, $_userName',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _quote.isNotEmpty
                                        ? _quote
                                        : 'One task at a time. One step closer.',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.textGrey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Theme toggle button
                            BlocBuilder<ThemeCubit, ThemeMode>(
                              builder: (ctx, themeMode) {
                                final dark = themeMode == ThemeMode.dark;
                                return GestureDetector(
                                  onTap: () =>
                                      ctx.read<ThemeCubit>().toggleTheme(),
                                  child: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.cardDark
                                          : const Color(0xFFEEEEEE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      dark
                                          ? Icons.wb_sunny_rounded
                                          : Icons.dark_mode_rounded,
                                      size: 20.sp,
                                      color: dark
                                          ? Colors.amber
                                          : AppColors.textLight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Headline ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                        child: Text(
                          total == 0
                              ? "Let's add your first task! 🚀"
                              : percent >= 1.0
                                  ? "All done! Great work! 🎉"
                                  : percent >= 0.5
                                      ? "Yuhuu, Your work Is\nalmost done! 👋"
                                      : "Keep going, you\ncan do it! 💪",
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),

                    // ─── Progress Card ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.2 : 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Achieved Tasks',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '$achieved Out of $total Done',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 56.w,
                                height: 56.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: percent,
                                      strokeWidth: 5,
                                      backgroundColor: isDark
                                          ? const Color(0xFF3A3A3A)
                                          : const Color(0xFFE0E0E0),
                                      valueColor: const AlwaysStoppedAnimation(
                                          AppColors.primary),
                                      strokeCap: StrokeCap.round,
                                    ),
                                    Text(
                                      '${(percent * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ─── High Priority Tasks ───────────────────────────
                    if (highPriority.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDark ? 0.2 : 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'High Priority Tasks',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    // Expand arrow
                                    Container(
                                      width: 34.w,
                                      height: 34.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.dividerDark
                                              : AppColors.dividerLight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Icon(
                                        Icons.north_east_rounded,
                                        size: 16.sp,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                ...highPriority.take(4).map((t) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => context
                                              .read<TaskCubit>()
                                              .updateTask(t.copyWith(
                                                  isCompleted: !t.isCompleted)),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 20.w,
                                            height: 20.w,
                                            decoration: BoxDecoration(
                                              color: t.isCompleted
                                                  ? AppColors.primary
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                              border: t.isCompleted
                                                  ? null
                                                  : Border.all(
                                                      color: isDark
                                                          ? const Color(
                                                              0xFF555555)
                                                          : const Color(
                                                              0xFFCCCCCC),
                                                      width: 1.5,
                                                    ),
                                            ),
                                            child: t.isCompleted
                                                ? Icon(Icons.check_rounded,
                                                    size: 12.sp,
                                                    color: Colors.white)
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            t.title,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: t.isCompleted
                                                  ? AppColors.textGrey
                                                  : textColor,
                                              decoration: t.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              decorationColor:
                                                  AppColors.textGrey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    // ─── My Tasks ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                        child: Text(
                          'My Tasks',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),

                    if (myTasks.isEmpty && highPriority.isEmpty && total == 0)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 24.h),
                          child: Column(
                            children: [
                              Icon(Icons.task_alt_rounded,
                                  size: 56.sp, color: AppColors.textGrey),
                              SizedBox(height: 12.h),
                              Text(
                                'No tasks yet.\nTap "+ Add New Task" to get started.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.sp, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final t = myTasks[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TaskTile(
                                task: t,
                                onToggle: () => context
                                    .read<TaskCubit>()
                                    .updateTask(t.copyWith(
                                        isCompleted: !t.isCompleted)),
                                onDelete: () =>
                                    context.read<TaskCubit>().deleteTask(t.id),
                              ),
                            );
                          },
                          childCount: myTasks.length,
                        ),
                      ),

                    // Bottom padding for FAB
                    SliverToBoxAdapter(child: SizedBox(height: 90.h)),
                  ],
                ),

                // ─── FAB ──────────────────────────────────────────────
                Positioned(
                  bottom: 16.h,
                  right: 20.w,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NewTaskScreen()),
                      );
                      if (context.mounted) {
                        context.read<TaskCubit>().loadTasks();
                      }
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r)),
                    icon: Icon(Icons.add_rounded, size: 22.sp),
                    label: Text(
                      'Add New Task',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
