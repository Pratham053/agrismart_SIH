import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> preferences;
  final Function(String, dynamic) onPreferenceChanged;

  const AppPreferencesWidget({
    Key? key,
    required this.preferences,
    required this.onPreferenceChanged,
  }) : super(key: key);

  @override
  State<AppPreferencesWidget> createState() => _AppPreferencesWidgetState();
}

class _AppPreferencesWidgetState extends State<AppPreferencesWidget> {
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
              'App Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 3.h),
            _buildLanguageSelector(),
            SizedBox(height: 2.h),
            _buildNotificationSettings(),
            SizedBox(height: 2.h),
            _buildVoiceSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return GestureDetector(
      onTap: () => _showLanguageDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.preferences['language'] ?? 'English',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ],
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.textSecondaryLight,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 1.h),
        _buildSwitchTile('Weather Alerts', 'weatherAlerts'),
        _buildSwitchTile('Price Changes', 'priceChanges'),
        _buildSwitchTile('Disease Warnings', 'diseaseWarnings'),
        _buildSwitchTile('App Updates', 'appUpdates'),
      ],
    );
  }

  Widget _buildVoiceSettings() {
    return GestureDetector(
      onTap: () => _showVoiceSettingsDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Commands',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.preferences['voiceEnabled'] == true
                      ? 'Enabled'
                      : 'Disabled',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ],
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.textSecondaryLight,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String key) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
            ),
          ),
          Switch(
            value: widget.preferences[key] ?? false,
            onChanged: (value) {
              widget.onPreferenceChanged(key, value);
            },
            activeColor: AppTheme.lightTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'Hindi', 'Portuguese'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages
              .map((language) => ListTile(
                    title: Text(language),
                    onTap: () {
                      widget.onPreferenceChanged('language', language);
                      Navigator.pop(context);
                    },
                    trailing: widget.preferences['language'] == language
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 5.w,
                          )
                        : null,
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showVoiceSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Voice Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Enable Voice Commands'),
              value: widget.preferences['voiceEnabled'] ?? false,
              onChanged: (value) {
                widget.onPreferenceChanged('voiceEnabled', value);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Calibrate Voice'),
              subtitle: Text('Improve accent recognition'),
              trailing: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              onTap: () {
                Navigator.pop(context);
                // Voice calibration would be implemented here
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
