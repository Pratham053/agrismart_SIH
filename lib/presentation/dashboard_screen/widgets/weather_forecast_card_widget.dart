import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherForecastCardWidget extends StatelessWidget {
  const WeatherForecastCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecastData = [
      {
        "day": "Today",
        "date": "Sep 10",
        "high": "26°",
        "low": "18°",
        "condition": "Partly Cloudy",
        "icon": "partly_cloudy_day",
        "precipitation": "10%",
        "humidity": "68%",
      },
      {
        "day": "Tomorrow",
        "date": "Sep 11",
        "high": "28°",
        "low": "20°",
        "condition": "Sunny",
        "icon": "wb_sunny",
        "precipitation": "5%",
        "humidity": "55%",
      },
      {
        "day": "Thursday",
        "date": "Sep 12",
        "high": "25°",
        "low": "17°",
        "condition": "Cloudy",
        "icon": "cloud",
        "precipitation": "30%",
        "humidity": "75%",
      },
      {
        "day": "Friday",
        "date": "Sep 13",
        "high": "23°",
        "low": "15°",
        "condition": "Light Rain",
        "icon": "grain",
        "precipitation": "80%",
        "humidity": "85%",
      },
      {
        "day": "Saturday",
        "date": "Sep 14",
        "high": "27°",
        "low": "19°",
        "condition": "Sunny",
        "icon": "wb_sunny",
        "precipitation": "0%",
        "humidity": "50%",
      },
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
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                '7-Day Agricultural Forecast',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                final forecast = forecastData[index] as Map<String, dynamic>;
                return _buildForecastCard(
                  forecast["day"] as String,
                  forecast["date"] as String,
                  forecast["high"] as String,
                  forecast["low"] as String,
                  forecast["condition"] as String,
                  forecast["icon"] as String,
                  forecast["precipitation"] as String,
                  forecast["humidity"] as String,
                  index == 0,
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Rain expected Friday - perfect for natural irrigation. Consider postponing fertilizer application.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(
    String day,
    String date,
    String high,
    String low,
    String condition,
    String iconName,
    String precipitation,
    String humidity,
    bool isToday,
  ) {
    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isToday
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isToday ? AppTheme.lightTheme.primaryColor : null,
            ),
          ),
          Text(
            date,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          CustomIconWidget(
            iconName: iconName,
            color: _getWeatherIconColor(iconName),
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            condition,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                high,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' / ',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                low,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildWeatherDetail('water_drop', precipitation),
          SizedBox(height: 0.5.h),
          _buildWeatherDetail('opacity', humidity),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String iconName, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 12,
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getWeatherIconColor(String iconName) {
    switch (iconName) {
      case 'wb_sunny':
        return AppTheme.accentColor;
      case 'partly_cloudy_day':
        return AppTheme.accentColor.withValues(alpha: 0.8);
      case 'cloud':
        return Colors.grey;
      case 'grain':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
