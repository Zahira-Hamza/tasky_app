import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import '../../core/theme/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../data/repositories/user_repository.dart';
import '../../logic/theme_cubit/theme_cubit.dart';
import '../widgets/profile_avatar.dart';
import 'onboarding_screen.dart';
import 'user_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _quote = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final repo = sl<UserRepository>();
    final name = await repo.getUserName();
    final quote = await repo.getMotivationQuote();
    if (mounted) setState(() {
      _userName = name;
      _quote = quote;
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Log Out',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to log out?',
            style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Log Out',
                style:
                    TextStyle(color: Colors.redAccent, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = sl<UserRepository>();
      await repo.clearAll();
      // Reset hive settings box
      final box = await Hive.openBox('settingsBox');
      await box.clear();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final dividerColor =
        isDark ? AppColors.dividerDark : AppColors.dividerLight;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── App Bar row ──────────────────────────────────────
              Padding(
                padding:
                    EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // ─── Avatar + name ─────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    ProfileAvatar(
                      radius: 50,
                      editable: true,
                      onChanged: _loadUser,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      _userName.isNotEmpty ? _userName : 'Your Name',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _quote.isNotEmpty
                          ? _quote
                          : 'One task at a time. One step closer.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // ─── Profile Info section ──────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Profile Info',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // User Details
              _ProfileItem(
                icon: Icons.person_outline_rounded,
                label: 'User Details',
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.sp, color: AppColors.textGrey),
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserDetailsScreen()),
                  );
                  if (changed == true) _loadUser();
                },
                dividerColor: dividerColor,
              ),

              // Dark Mode toggle
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (ctx, themeMode) {
                  final dark = themeMode == ThemeMode.dark;
                  return _ProfileItem(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    trailing: Switch(
                      value: dark,
                      onChanged: (_) =>
                          ctx.read<ThemeCubit>().toggleTheme(),
                    ),
                    dividerColor: dividerColor,
                  );
                },
              ),

              // Log Out
              _ProfileItem(
                icon: Icons.logout_rounded,
                label: 'Log Out',
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.sp, color: AppColors.textGrey),
                onTap: _logout,
                dividerColor: dividerColor,
                labelColor: Colors.redAccent,
                iconColor: Colors.redAccent,
                showDivider: false,
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color dividerColor;
  final Color? labelColor;
  final Color? iconColor;
  final bool showDivider;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    required this.dividerColor,
    this.labelColor,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(icon,
                    size: 22.sp,
                    color: iconColor ??
                        (isDark ? AppColors.textGrey : AppColors.textLight)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: labelColor ?? textColor,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: dividerColor,
            indent: 20.w,
            endIndent: 20.w,
          ),
      ],
    );
  }
}
