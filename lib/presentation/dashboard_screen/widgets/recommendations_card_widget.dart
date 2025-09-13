import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecommendationsCardWidget extends StatelessWidget {
  const RecommendationsCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendations = [
      {
        "id": 1,
        "title": "Water your tomato plants",
        "description":
            "Based on current weather conditions, your tomato plants need watering today.",
        "priority": "High",
        "time": "Morning (6-8 AM)",
        "icon": "water_drop",
        "completed": false,
      },
      {
        "id": 2,
        "title": "Apply fertilizer to corn field",
        "description":
            "Optimal time for nitrogen application based on growth stage.",
        "priority": "Medium",
        "time": "This week",
        "icon": "grass",
        "completed": false,
      },
      {
        "id": 3,
        "title": "Check for pest activity",
        "description":
            "Weather conditions favor pest activity. Inspect your crops.",
        "priority": "High",
        "time": "Today",
        "icon": "bug_report",
        "completed": true,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Today\'s Recommendations',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
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
          ...recommendations.map((recommendation) {
            final recommendationMap = recommendation as Map<String, dynamic>;
            return _buildRecommendationItem(
              recommendationMap["title"] as String,
              recommendationMap["description"] as String,
              recommendationMap["priority"] as String,
              recommendationMap["time"] as String,
              recommendationMap["icon"] as String,
              recommendationMap["completed"] as bool,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String description,
    String priority,
    String time,
    String iconName,
    bool completed,
  ) {
    Color priorityColor = AppTheme.lightTheme.primaryColor;
    if (priority == 'High') {
      priorityColor = AppTheme.lightTheme.colorScheme.error;
    } else if (priority == 'Medium') {
      priorityColor = AppTheme.warningColor;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: completed
            ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: completed
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: completed
                  ? AppTheme.successColor.withValues(alpha: 0.1)
                  : priorityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: completed ? 'check_circle' : iconName,
              color: completed ? AppTheme.successColor : priorityColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                          color: completed
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priority,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: priorityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: completed
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      time,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
