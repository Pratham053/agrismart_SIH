import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import '../../../core/app_export.dart';

class CropSearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;

  const CropSearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onVoiceSearch,
  }) : super(key: key);

  @override
  State<CropSearchBarWidget> createState() => _CropSearchBarWidgetState();
}

class _CropSearchBarWidgetState extends State<CropSearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startVoiceSearch() async {
    if (!_isMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice search unavailable on desktop/web.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);

        await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: 'temp_audio.aac');

        // Stop recording after 3 seconds for demo
        await Future.delayed(Duration(seconds: 3));

        final path = await _audioRecorder.stop();
        setState(() => _isRecording = false);

        if (path != null) {
          // Simulate voice recognition result
          _searchController.text = "tomato";
          widget.onVoiceSearch();
        }
      } else {
        await Permission.microphone.request();
      }
    } catch (e) {
      setState(() => _isRecording = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice search unavailable'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search crops...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: InkWell(
                  onTap: _isRecording ? null : _startVoiceSearch,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: _isRecording ? 'stop' : 'mic',
                      color: _isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
