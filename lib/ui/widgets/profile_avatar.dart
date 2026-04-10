import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../data/repositories/user_repository.dart';

/// A circular profile image that optionally allows tapping to change it.
class ProfileAvatar extends StatefulWidget {
  final double radius;
  final bool editable;
  final VoidCallback? onChanged;

  const ProfileAvatar({
    super.key,
    this.radius = 22,
    this.editable = false,
    this.onChanged,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final path = await sl<UserRepository>().getProfileImagePath();
    if (mounted) setState(() => _imagePath = path);
  }

  Future<void> _pickImage() async {
    if (!widget.editable) return;
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      await sl<UserRepository>().saveProfileImagePath(picked.path);
      if (mounted) setState(() => _imagePath = picked.path);
      widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatar = CircleAvatar(
      radius: widget.radius.r,
      backgroundColor:
          isDark ? AppColors.cardDark : const Color(0xFFE0E0E0),
      backgroundImage:
          _imagePath != null ? FileImage(File(_imagePath!)) : null,
      child: _imagePath == null
          ? Icon(Icons.person_rounded,
              size: widget.radius.r * 0.9, color: AppColors.textGrey)
          : null,
    );

    if (!widget.editable) return avatar;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: (widget.radius * 0.7).r,
              height: (widget.radius * 0.7).r,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt_rounded,
                  size: (widget.radius * 0.38).sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
