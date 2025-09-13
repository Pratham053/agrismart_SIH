import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraOverlayWidget extends StatelessWidget {
  final bool isPlantDetected;
  final String guidanceText;
  final double confidenceLevel;

  const CameraOverlayWidget({
    Key? key,
    required this.isPlantDetected,
    required this.guidanceText,
    required this.confidenceLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Viewfinder overlay
        Center(
          child: Container(
            width: 80.w,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: isPlantDetected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Corner guides
                ...List.generate(4, (index) => _buildCornerGuide(index)),

                // Center crosshair
                Center(
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: isPlantDetected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Plant detection indicator
                if (isPlantDetected)
                  Positioned(
                    top: 2.h,
                    right: 2.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'eco',
                            color: Colors.white,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${(confidenceLevel * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Top guidance text
        Positioned(
          top: 8.h,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              guidanceText,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Bottom instruction text
        Positioned(
          bottom: 25.h,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Position leaf within frame',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Ensure good lighting and focus',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerGuide(int index) {
    final positions = [
      {'top': 0.0, 'left': 0.0}, // Top-left
      {'top': 0.0, 'right': 0.0}, // Top-right
      {'bottom': 0.0, 'left': 0.0}, // Bottom-left
      {'bottom': 0.0, 'right': 0.0}, // Bottom-right
    ];

    final position = positions[index];

    return Positioned(
      top: position['top'],
      left: position['left'],
      right: position['right'],
      bottom: position['bottom'],
      child: Container(
        width: 6.w,
        height: 6.w,
        child: CustomPaint(
          painter: CornerGuidePainter(
            cornerIndex: index,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

class CornerGuidePainter extends CustomPainter {
  final int cornerIndex;
  final Color color;

  CornerGuidePainter({required this.cornerIndex, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    const lineLength = 20.0;

    switch (cornerIndex) {
      case 0: // Top-left
        path.moveTo(0, lineLength);
        path.lineTo(0, 0);
        path.lineTo(lineLength, 0);
        break;
      case 1: // Top-right
        path.moveTo(size.width - lineLength, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, lineLength);
        break;
      case 2: // Bottom-left
        path.moveTo(0, size.height - lineLength);
        path.lineTo(0, size.height);
        path.lineTo(lineLength, size.height);
        break;
      case 3: // Bottom-right
        path.moveTo(size.width - lineLength, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, size.height - lineLength);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
