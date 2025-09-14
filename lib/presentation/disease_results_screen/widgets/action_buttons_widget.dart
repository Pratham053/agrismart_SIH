import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onSaveToHistory;
  final VoidCallback? onShareResults;
  final VoidCallback? onVoicePlayback;
  final VoidCallback? onRetakePhoto;
  final VoidCallback? onExpertConsultation;
  final VoidCallback? onFindTreatments;

  const ActionButtonsWidget({
    Key? key,
    this.onSaveToHistory,
    this.onShareResults,
    this.onVoicePlayback,
    this.onRetakePhoto,
    this.onExpertConsultation,
    this.onFindTreatments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          // Top action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Save to History',
                  icon: 'bookmark',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: () {
                    onSaveToHistory?.call();
                    _showToast('Saved to history successfully');
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  label: 'Share Results',
                  icon: 'share',
                  color: AppTheme.accentColor,
                  onTap: () {
                    onShareResults?.call();
                    _showToast('Sharing results...');
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Voice playback button
          _buildActionButton(
            label: 'Voice Playback',
            icon: 'volume_up',
            color: AppTheme.lightTheme.colorScheme.secondary,
            onTap: () {
              onVoicePlayback?.call();
              _showToast('Playing treatment instructions...');
            },
            isFullWidth: true,
          ),

          SizedBox(height: 3.h),

          // Bottom action buttons
          Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  label: 'Retake Photo',
                  icon: 'camera_alt',
                  onTap: () {
                    onRetakePhoto?.call();
                  },
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildSecondaryButton(
                  label: 'Expert Help',
                  icon: 'support_agent',
                  onTap: () {
                    onExpertConsultation?.call();
                  },
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildSecondaryButton(
                  label: 'Find Nearby',
                  icon: 'location_on',
                  onTap: () {
                    onFindTreatments?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 5.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      textColor: AppTheme.lightTheme.colorScheme.surface,
      fontSize: 14.0,
    );
  }
}
