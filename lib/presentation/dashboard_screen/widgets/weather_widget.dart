import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherData = {
      "temperature": "24°C",
      "condition": "Partly Cloudy",
      "humidity": "68%",
      "windSpeed": "12 km/h",
      "icon": "partly_cloudy_day",
      "forecast": [
        {
          "day": "Today",
          "high": "26°",
          "low": "18°",
          "icon": "partly_cloudy_day"
        },
        {"day": "Tomorrow", "high": "28°", "low": "20°", "icon": "sunny"},
        {"day": "Thu", "high": "25°", "low": "17°", "icon": "cloud"},
      ]
    };

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
                iconName: 'wb_sunny',
                color: AppTheme.accentColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Current Weather',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData["temperature"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    Text(
                      weatherData["condition"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildWeatherDetail('Humidity',
                        weatherData["humidity"] as String, 'water_drop'),
                    SizedBox(height: 1.h),
                    _buildWeatherDetail(
                        'Wind', weatherData["windSpeed"] as String, 'air'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(color: AppTheme.lightTheme.dividerColor),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: (weatherData["forecast"] as List).map((forecast) {
              final forecastMap = forecast as Map<String, dynamic>;
              return _buildForecastItem(
                forecastMap["day"] as String,
                forecastMap["high"] as String,
                forecastMap["low"] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildForecastItem(String day, String high, String low) {
    return Column(
      children: [
        Text(
          day,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        CustomIconWidget(
          iconName: 'wb_sunny',
          color: AppTheme.accentColor,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          high,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          low,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
