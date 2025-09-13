import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final bool isFlashOn;
  final bool isFrontCamera;
  final VoidCallback onFlashToggle;
  final VoidCallback onCameraFlip;
  final VoidCallback onGalleryTap;
  final VoidCallback onCapture;
  final bool isProcessing;

  const CameraControlsWidget({
    Key? key,
    required this.isFlashOn,
    required this.isFrontCamera,
    required this.onFlashToggle,
    required this.onCameraFlip,
    required this.onGalleryTap,
    required this.onCapture,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Top controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: isProcessing ? null : onGalleryTap,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'photo_library',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),

                // Flash toggle button
                GestureDetector(
                  onTap: isProcessing ? null : onFlashToggle,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isFlashOn
                          ? AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: isFlashOn ? 'flash_on' : 'flash_off',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Bottom controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Camera flip button
                GestureDetector(
                  onTap: isProcessing ? null : onCameraFlip,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'flip_camera_ios',
                      color: Colors.white,
                      size: 7.w,
                    ),
                  ),
                ),

                // Capture button
                GestureDetector(
                  onTap: isProcessing ? null : onCapture,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: isProcessing
                          ? Colors.grey.withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isProcessing
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : CustomIconWidget(
                            iconName: 'camera_alt',
                            color: Colors.white,
                            size: 8.w,
                          ),
                  ),
                ),

                // Spacer for symmetry
                SizedBox(width: 14.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
