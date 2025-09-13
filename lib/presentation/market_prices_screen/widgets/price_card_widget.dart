import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriceCardWidget extends StatelessWidget {
  final Map<String, dynamic> priceData;
  final VoidCallback? onTap;
  final VoidCallback? onSetAlert;
  final VoidCallback? onAddToWatchlist;
  final VoidCallback? onShare;

  const PriceCardWidget({
    Key? key,
    required this.priceData,
    this.onTap,
    this.onSetAlert,
    this.onAddToWatchlist,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String cropName = priceData['name'] as String? ?? 'Unknown Crop';
    final double currentPrice =
        (priceData['currentPrice'] as num?)?.toDouble() ?? 0.0;
    final double change = (priceData['change'] as num?)?.toDouble() ?? 0.0;
    final double changePercent =
        (priceData['changePercent'] as num?)?.toDouble() ?? 0.0;
    final List<double> trendData =
        (priceData['trendData'] as List?)?.cast<double>() ?? [];
    final String unit = priceData['unit'] as String? ?? 'per kg';
    final bool isPositive = change >= 0;

    return Slidable(
      key: ValueKey(cropName),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onSetAlert?.call(),
            backgroundColor: AppTheme.warningColor,
            foregroundColor: Colors.white,
            icon: Icons.notifications,
            label: 'Alert',
          ),
          SlidableAction(
            onPressed: (_) => onAddToWatchlist?.call(),
            backgroundColor: AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: Icons.bookmark,
            label: 'Watch',
          ),
          SlidableAction(
            onPressed: (_) => onShare?.call(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cropName,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            unit,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${currentPrice.toStringAsFixed(2)}',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: isPositive
                                ? AppTheme.successColor.withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: isPositive
                                    ? 'trending_up'
                                    : 'trending_down',
                                color: isPositive
                                    ? AppTheme.successColor
                                    : AppTheme.lightTheme.colorScheme.error,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${isPositive ? '+' : ''}\$${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(1)}%)',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isPositive
                                      ? AppTheme.successColor
                                      : AppTheme.lightTheme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (trendData.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Container(
                    height: 6.h,
                    child: CustomPaint(
                      painter: MiniTrendPainter(
                        data: trendData,
                        color: isPositive
                            ? AppTheme.successColor
                            : AppTheme.lightTheme.colorScheme.error,
                      ),
                      size: Size(double.infinity, 6.h),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiniTrendPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  MiniTrendPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double range = maxValue - minValue;

    if (range == 0) return;

    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double y =
          size.height - ((data[i] - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
