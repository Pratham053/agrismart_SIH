import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';

class DataManagementWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool isOnline;

  const DataManagementWidget({
    Key? key,
    required this.userData,
    required this.isOnline,
  }) : super(key: key);

  @override
  State<DataManagementWidget> createState() => _DataManagementWidgetState();
}

class _DataManagementWidgetState extends State<DataManagementWidget> {
  bool _isExporting = false;
  bool _isSyncing = false;

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
            Text(
              'Data Management',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 3.h),
            _buildSyncStatus(),
            SizedBox(height: 2.h),
            _buildExportOption(),
            SizedBox(height: 2.h),
            _buildStorageInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatus() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: widget.isOnline
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : AppTheme.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isOnline
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : AppTheme.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: widget.isOnline ? 'cloud_done' : 'cloud_off',
            color:
                widget.isOnline ? AppTheme.successColor : AppTheme.warningColor,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isOnline ? 'Data Synced' : 'Offline Mode',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: widget.isOnline
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                  ),
                ),
                Text(
                  widget.isOnline
                      ? 'Last sync: ${DateTime.now().toString().substring(0, 16)}'
                      : 'Data will sync when online',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isOnline && !_isSyncing)
            GestureDetector(
              onTap: _syncData,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'sync',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          if (_isSyncing)
            SizedBox(
              width: 5.w,
              height: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExportOption() {
    return GestureDetector(
      onTap: _isExporting ? null : _exportData,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerLight),
          borderRadius: BorderRadius.circular(8),
          color: _isExporting
              ? AppTheme.dividerLight.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Data',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _isExporting
                          ? AppTheme.textSecondaryLight
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Download your farming history and recommendations',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (_isExporting)
              SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
              )
            else
              CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageInfo() {
    final storageUsed = 45.6; // MB
    final totalStorage = 100.0; // MB
    final percentage = storageUsed / totalStorage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storage Usage',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${storageUsed.toStringAsFixed(1)} MB used',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            Text(
              '${totalStorage.toStringAsFixed(0)} MB total',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppTheme.dividerLight,
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage > 0.8
                ? AppTheme.warningColor
                : AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _syncData() async {
    setState(() => _isSyncing = true);

    try {
      // Simulate sync operation
      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data synchronized successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);

    try {
      final exportData = {
        'user_profile': widget.userData,
        'export_date': DateTime.now().toIso8601String(),
        'recommendations': [
          {
            'date': '2025-01-08',
            'crop': 'Tomatoes',
            'recommendation': 'Plant in well-drained soil with pH 6.0-6.8',
            'confidence': 0.92,
          },
          {
            'date': '2025-01-05',
            'crop': 'Corn',
            'recommendation': 'Optimal planting time based on weather forecast',
            'confidence': 0.88,
          },
        ],
        'disease_detections': [
          {
            'date': '2025-01-07',
            'crop': 'Wheat',
            'disease': 'Leaf Rust',
            'confidence': 0.85,
            'treatment': 'Apply fungicide spray',
          },
        ],
        'market_data': [
          {
            'date': '2025-01-10',
            'crop': 'Rice',
            'price': '\$2.45/kg',
            'trend': 'increasing',
          },
        ],
      };

      final jsonString = JsonEncoder.withIndent('  ').convert(exportData);
      final fileName =
          'agrismart_export_${DateTime.now().millisecondsSinceEpoch}.json';

      await _downloadFile(jsonString, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }
}
