import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomRecommendationFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomRecommendationFabWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
      elevation: 4,
      icon: CustomIconWidget(
        iconName: 'add_circle_outline',
        color: AppTheme.lightTheme.colorScheme.onTertiary,
        size: 20,
      ),
      label: Text(
        'Custom Request',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              fontWeight: FontWeight.w500,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
