import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceGuidanceWidget extends StatelessWidget {
  final bool isListening;
  final bool isVoiceEnabled;
  final VoidCallback onToggleVoice;
  final String currentInstruction;

  const VoiceGuidanceWidget({
    Key? key,
    required this.isListening,
    required this.isVoiceEnabled,
    required this.onToggleVoice,
    required this.currentInstruction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6.h,
      right: 4.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Voice toggle button
          GestureDetector(
            onTap: onToggleVoice,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isVoiceEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: isVoiceEnabled ? 'volume_up' : 'volume_off',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  if (isListening)
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Voice instruction indicator
          if (isVoiceEnabled && currentInstruction.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              constraints: BoxConstraints(maxWidth: 60.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'record_voice_over',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      currentInstruction,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
