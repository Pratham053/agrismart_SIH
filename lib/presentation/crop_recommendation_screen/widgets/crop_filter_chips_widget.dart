import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CropFilterChipsWidget extends StatefulWidget {
  final Function(String) onFilterChanged;
  final String selectedFilter;

  const CropFilterChipsWidget({
    Key? key,
    required this.onFilterChanged,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  State<CropFilterChipsWidget> createState() => _CropFilterChipsWidgetState();
}

class _CropFilterChipsWidgetState extends State<CropFilterChipsWidget> {
  final List<Map<String, String>> filters = [
    {'key': 'all', 'label': 'All Crops'},
    {'key': 'season', 'label': 'Season'},
    {'key': 'profit', 'label': 'High Profit'},
    {'key': 'difficulty', 'label': 'Easy Care'},
    {'key': 'water', 'label': 'Low Water'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = widget.selectedFilter == filter['key'];

          return FilterChip(
            label: Text(
              filter['label']!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                widget.onFilterChanged(filter['key']!);
              }
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
            checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
            side: BorderSide(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          );
        },
      ),
    );
  }
}
