import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSelectorWidget extends StatelessWidget {
  final String selectedLocation;
  final List<String> availableLocations;
  final Function(String) onLocationChanged;
  final VoidCallback? onUseCurrentLocation;

  const LocationSelectorWidget({
    Key? key,
    required this.selectedLocation,
    required this.availableLocations,
    required this.onLocationChanged,
    this.onUseCurrentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLocation,
                isExpanded: true,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 20,
                ),
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                items: availableLocations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onLocationChanged(newValue);
                  }
                },
              ),
            ),
          ),
          if (onUseCurrentLocation != null) ...[
            SizedBox(width: 2.w),
            IconButton(
              onPressed: onUseCurrentLocation,
              icon: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              tooltip: 'Use current location',
              constraints: BoxConstraints(
                minWidth: 8.w,
                minHeight: 8.w,
              ),
              padding: EdgeInsets.all(1.w),
            ),
          ],
        ],
      ),
    );
  }
}
