import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import '../../core/app_export.dart';
import './widgets/disease_scans_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/market_trends_card_widget.dart';
import './widgets/recommendations_card_widget.dart';
import './widgets/weather_forecast_card_widget.dart';
import './widgets/weather_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRecording = false;
  bool _isRefreshing = false;
  final AudioRecorder _audioRecorder = AudioRecorder();
  late TabController _tabController;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  final List<Map<String, dynamic>> _tabItems = [
    {"icon": "dashboard", "label": "Dashboard", "route": "/dashboard-screen"},
    {
      "icon": "agriculture",
      "label": "Crops",
      "route": "/crop-recommendation-screen"
    },
    {
      "icon": "local_hospital",
      "label": "Diseases",
      "route": "/disease-detection-screen"
    },
    {
      "icon": "trending_up",
      "label": "Market",
      "route": "/market-prices-screen"
    },
    {"icon": "person", "label": "Profile", "route": "/profile-screen"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabItems.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _startVoiceCommand() async {
    if (!_isMobile) {
      _showErrorSnackBar('Voice commands unavailable on desktop/web.');
      return;
    }
    try {
      if (await _audioRecorder.hasPermission()) {
        if (!_isRecording) {
          await _audioRecorder.start(const RecordConfig(),
              path: 'voice_command.m4a');
          setState(() {
            _isRecording = true;
          });

          // Auto-stop after 5 seconds
          Future.delayed(Duration(seconds: 5), () {
            if (_isRecording) {
              _stopVoiceCommand();
            }
          });
        } else {
          await _stopVoiceCommand();
        }
      } else {
        _showPermissionDialog();
      }
    } catch (e) {
      _showErrorSnackBar('Voice command failed. Please try again.');
    }
  }

  Future<void> _stopVoiceCommand() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        _processVoiceCommand();
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _processVoiceCommand() {
    // Simulate voice command processing
    _showSuccessSnackBar('Voice command processed successfully!');
  }

  void _showPermissionDialog() {
    if (!_isMobile) {
      _showErrorSnackBar('Microphone not available on this platform.');
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Microphone Permission'),
        content:
            Text('Please grant microphone permission to use voice commands.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _tabController.animateTo(index);

      if (index != 0) {
        Navigator.pushNamed(context, _tabItems[index]["route"] as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'AgriSmart',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _startVoiceCommand,
            icon: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _isRecording
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _isRecording ? 'stop' : 'mic',
                color: _isRecording
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                GreetingHeaderWidget(
                  farmerName: 'John Smith',
                  location: 'Green Valley Farm, California',
                ),
                SizedBox(height: 3.h),
                WeatherWidget(),
                SizedBox(height: 3.h),
                RecommendationsCardWidget(),
                SizedBox(height: 3.h),
                DiseaseScansCardWidget(),
                SizedBox(height: 3.h),
                MarketTrendsCardWidget(),
                SizedBox(height: 3.h),
                WeatherForecastCardWidget(),
                SizedBox(height: 10.h), // Extra space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/disease-detection-screen');
        },
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Scan Disease',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 8.h,
            child: TabBar(
              controller: _tabController,
              onTap: _onTabTapped,
              tabs: _tabItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _selectedIndex;

                return Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: item["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item["label"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              indicatorColor: Colors.transparent,
              labelColor: AppTheme.lightTheme.primaryColor,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              dividerColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
