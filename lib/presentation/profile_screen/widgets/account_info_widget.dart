import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountInfoWidget extends StatelessWidget {
  final Map<String, dynamic> accountData;
  final VoidCallback onEditTap;

  const AccountInfoWidget({
    Key? key,
    required this.accountData,
    required this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account Information',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 4.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildInfoRow('Email', accountData['email'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow('Phone', accountData['phone'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow(
                'Farm Name', accountData['farmName'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow(
                'Farm Size', accountData['farmSize'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow(
                'Primary Crops', accountData['primaryCrops'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow('Farming Method',
                accountData['farmingMethod'] ?? 'Not provided'),
            SizedBox(height: 2.h),
            _buildInfoRow(
                'Soil Type', accountData['soilType'] ?? 'Not provided'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
