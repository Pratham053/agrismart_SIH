import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilters,
    required this.onFilterToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filterOptions = [
      {'label': 'All Crops', 'value': 'all', 'icon': 'agriculture'},
      {'label': 'Grains', 'value': 'grains', 'icon': 'grain'},
      {'label': 'Vegetables', 'value': 'vegetables', 'icon': 'eco'},
      {'label': 'Fruits', 'value': 'fruits', 'icon': 'apple'},
      {'label': 'Price ↑', 'value': 'price_up', 'icon': 'trending_up'},
      {'label': 'Price ↓', 'value': 'price_down', 'icon': 'trending_down'},
      {'label': 'Nearby', 'value': 'nearby', 'icon': 'location_on'},
      {'label': 'Favorites', 'value': 'favorites', 'icon': 'favorite'},
    ];

    return Container(
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilters.contains(filter['value']);

          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filter['icon'],
                    size: 16,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    filter['label'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) => onFilterToggle(filter['value']),
              selectedColor: AppTheme.lightTheme.primaryColor,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
          );
        },
      ),
    );
  }
}
