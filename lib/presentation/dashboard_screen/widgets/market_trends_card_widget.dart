import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MarketTrendsCardWidget extends StatelessWidget {
  const MarketTrendsCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketData = [
      {
        "crop": "Tomatoes",
        "currentPrice": "\$2.45",
        "change": "+12%",
        "trend": "up",
        "unit": "per kg",
      },
      {
        "crop": "Corn",
        "currentPrice": "\$1.85",
        "change": "-5%",
        "trend": "down",
        "unit": "per kg",
      },
      {
        "crop": "Wheat",
        "currentPrice": "\$0.95",
        "change": "+3%",
        "trend": "up",
        "unit": "per kg",
      },
    ];

    final chartData = [
      FlSpot(0, 2.1),
      FlSpot(1, 2.3),
      FlSpot(2, 2.0),
      FlSpot(3, 2.4),
      FlSpot(4, 2.45),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.successColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Market Trends',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/market-prices-screen');
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 20.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    color: AppTheme.lightTheme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.lightTheme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppTheme.lightTheme.cardColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 4,
                minY: 1.8,
                maxY: 2.6,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ...marketData.map((market) {
            final marketMap = market as Map<String, dynamic>;
            return _buildMarketItem(
              marketMap["crop"] as String,
              marketMap["currentPrice"] as String,
              marketMap["change"] as String,
              marketMap["trend"] as String,
              marketMap["unit"] as String,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMarketItem(
    String crop,
    String currentPrice,
    String change,
    String trend,
    String unit,
  ) {
    final isPositive = trend == 'up';
    final trendColor = isPositive
        ? AppTheme.successColor
        : AppTheme.lightTheme.colorScheme.error;
    final trendIcon = isPositive ? 'trending_up' : 'trending_down';

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'agriculture',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  unit,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentPrice,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: trendIcon,
                    color: trendColor,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    change,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
