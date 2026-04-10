import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../data/repositories/user_repository.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _nameController = TextEditingController();
  final _quoteController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = sl<UserRepository>();
    final name = await repo.getUserName();
    final quote = await repo.getMotivationQuote();
    if (mounted) {
      _nameController.text = name;
      _quoteController.text = quote;
    }
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Name cannot be empty'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = sl<UserRepository>();
    await repo.saveUserName(name);
    await repo.saveMotivationQuote(_quoteController.text.trim());
    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Changes saved successfully ✓'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context, true); // return true so profile can reload
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quoteController.dispose();
    super.dispose();
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
          'User Details',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Name
            Text(
              'User Name',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 14.sp, color: textColor),
              decoration: const InputDecoration(
                hintText: 'e.g. Sarah Khalid',
              ),
            ),
            SizedBox(height: 24.h),

            // Motivation Quote
            Text(
              'Motivation Quote',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _quoteController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 14.sp, color: textColor),
              decoration: const InputDecoration(
                hintText: 'One task at a time. One step closer.',
                alignLabelWithHint: true,
              ),
            ),

            SizedBox(height: 56.h),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
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
