import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/user_repository.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/theme_cubit/theme_cubit.dart';
import 'onboarding_screen.dart';
import 'root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    // Load persisted theme FIRST so the MaterialApp rebuilds with correct theme
    // before we navigate away
    await context.read<ThemeCubit>().loadTheme();

    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    context.read<TaskCubit>().loadTasks();

    final userRepo = sl<UserRepository>();
    final isOnboarded = await userRepo.isOnboarded();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            isOnboarded ? const RootScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Read actual persisted theme from ThemeCubit instead of
    // hardcoding dark. On first launch this defaults to light.
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Image.asset(
                      'assets/images/tasky_logo.png',
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Tasky',
                  style: TextStyle(
                    // Color adapts to the actual theme
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
