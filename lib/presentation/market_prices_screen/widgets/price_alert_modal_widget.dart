import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriceAlertModalWidget extends StatefulWidget {
  final Map<String, dynamic> cropData;
  final Function(double, String) onSetAlert;

  const PriceAlertModalWidget({
    Key? key,
    required this.cropData,
    required this.onSetAlert,
  }) : super(key: key);

  @override
  State<PriceAlertModalWidget> createState() => _PriceAlertModalWidgetState();
}

class _PriceAlertModalWidgetState extends State<PriceAlertModalWidget> {
  final TextEditingController _priceController = TextEditingController();
  String _alertType = 'above';
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  void initState() {
    super.initState();
    final currentPrice =
        (widget.cropData['currentPrice'] as num?)?.toDouble() ?? 0.0;
    _priceController.text = currentPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String cropName =
        widget.cropData['name'] as String? ?? 'Unknown Crop';
    final double currentPrice =
        (widget.cropData['currentPrice'] as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Set Price Alert',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'agriculture',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cropName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Current: \$${currentPrice.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Alert Type',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Above',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  value: 'above',
                  groupValue: _alertType,
                  onChanged: (value) => setState(() => _alertType = value!),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Below',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  value: 'below',
                  groupValue: _alertType,
                  onChanged: (value) => setState(() => _alertType = value!),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Target Price',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter target price',
              prefixIcon: Icon(
                Icons.attach_money,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Notification Preferences',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          SwitchListTile(
            title: Text(
              'Push Notifications',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Get instant alerts on your device',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text(
              'Email Notifications',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Receive alerts via email',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            contentPadding: EdgeInsets.zero,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final targetPrice = double.tryParse(_priceController.text);
                    if (targetPrice != null) {
                      widget.onSetAlert(targetPrice, _alertType);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Set Alert'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
