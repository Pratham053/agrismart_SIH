import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseScansCardWidget extends StatelessWidget {
  const DiseaseScansCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentScans = [
      {
        "id": 1,
        "cropName": "Tomato Plant",
        "result": "Healthy",
        "confidence": "95%",
        "date": "2 hours ago",
        "imageUrl":
            "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=400",
        "status": "healthy",
      },
      {
        "id": 2,
        "cropName": "Corn Leaf",
        "result": "Leaf Blight Detected",
        "confidence": "87%",
        "date": "1 day ago",
        "imageUrl":
            "https://images.pexels.com/photos/2589457/pexels-photo-2589457.jpeg?auto=compress&cs=tinysrgb&w=400",
        "status": "disease",
      },
      {
        "id": 3,
        "cropName": "Wheat Plant",
        "result": "Nutrient Deficiency",
        "confidence": "78%",
        "date": "3 days ago",
        "imageUrl":
            "https://images.pexels.com/photos/326082/pexels-photo-326082.jpeg?auto=compress&cs=tinysrgb&w=400",
        "status": "warning",
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
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recent Disease Scans',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/disease-detection-screen');
                },
                child: Text(
                  'Scan Now',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          recentScans.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: recentScans.map((scan) {
                    final scanMap = scan as Map<String, dynamic>;
                    return _buildScanItem(
                      scanMap["cropName"] as String,
                      scanMap["result"] as String,
                      scanMap["confidence"] as String,
                      scanMap["date"] as String,
                      scanMap["imageUrl"] as String,
                      scanMap["status"] as String,
                      context,
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'photo_camera',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No scans yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Take a photo of your crops to detect diseases',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScanItem(
    String cropName,
    String result,
    String confidence,
    String date,
    String imageUrl,
    String status,
    BuildContext context,
  ) {
    Color statusColor = AppTheme.successColor;
    IconData statusIcon = Icons.check_circle;

    if (status == 'disease') {
      statusColor = AppTheme.lightTheme.colorScheme.error;
      statusIcon = Icons.error;
    } else if (status == 'warning') {
      statusColor = AppTheme.warningColor;
      statusIcon = Icons.warning;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/disease-results-screen');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.lightTheme.dividerColor),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
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
                          cropName,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: statusIcon.codePoint.toString(),
                        color: statusColor,
                        size: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    result,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        'Confidence: $confidence',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '• $date',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
