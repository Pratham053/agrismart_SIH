import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_info_widget.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_image_picker_widget.dart';
import './widgets/settings_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4; // Profile tab active
  bool _isOnline = true;

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'John Martinez',
    'farmLocation': 'Fresno County, California',
    'profileImage':
        'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400',
    'email': 'john.martinez@email.com',
    'phone': '+1 (559) 123-4567',
    'farmName': 'Martinez Family Farm',
    'farmSize': '150 acres',
    'primaryCrops': 'Almonds, Grapes, Tomatoes',
    'farmingMethod': 'Organic',
    'soilType': 'Sandy Loam',
  };

  Map<String, dynamic> _preferences = {
    'language': 'English',
    'weatherAlerts': true,
    'priceChanges': true,
    'diseaseWarnings': true,
    'appUpdates': false,
    'voiceEnabled': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderWidget(
              farmerName: _userData['name'] ?? 'Unknown Farmer',
              farmLocation: _userData['farmLocation'] ?? 'Unknown Location',
              profileImageUrl: _userData['profileImage'] ?? '',
              onProfileImageTap: _showImagePicker,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    AccountInfoWidget(
                      accountData: _userData,
                      onEditTap: _showEditAccountDialog,
                    ),
                    AppPreferencesWidget(
                      preferences: _preferences,
                      onPreferenceChanged: _updatePreference,
                    ),
                    DataManagementWidget(
                      userData: _userData,
                      isOnline: _isOnline,
                    ),
                    SettingsMenuWidget(
                      onHelpTap: _showHelpDialog,
                      onPrivacyTap: _showPrivacyDialog,
                      onLogoutTap: _showLogoutDialog,
                    ),
                    SizedBox(height: 10.h), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryLight,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'agriculture',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/crop-recommendation-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/disease-detection-screen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/market-prices-screen');
        break;
      case 4:
        // Already on profile screen
        break;
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileImagePickerWidget(
        onImageSelected: (imagePath) {
          setState(() {
            _userData['profileImage'] = imagePath;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile photo updated successfully'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        },
      ),
    );
  }

  void _updatePreference(String key, dynamic value) {
    setState(() {
      _preferences[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preference updated'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showEditAccountDialog() {
    final nameController = TextEditingController(text: _userData['name']);
    final emailController = TextEditingController(text: _userData['email']);
    final phoneController = TextEditingController(text: _userData['phone']);
    final farmNameController =
        TextEditingController(text: _userData['farmName']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Account Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: farmNameController,
                decoration: InputDecoration(
                  labelText: 'Farm Name',
                  prefixIcon: CustomIconWidget(
                    iconName: 'agriculture',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['name'] = nameController.text;
                _userData['email'] = emailController.text;
                _userData['phone'] = phoneController.text;
                _userData['farmName'] = farmNameController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account information updated'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Frequently Asked Questions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem(
                'How accurate is disease detection?',
                'Our AI model has 92% accuracy rate, trained on thousands of plant images.',
              ),
              _buildFAQItem(
                'Can I use the app offline?',
                'Yes, basic features work offline. Data syncs when you\'re back online.',
              ),
              _buildFAQItem(
                'How often are market prices updated?',
                'Market prices are updated every 4 hours during trading hours.',
              ),
              _buildFAQItem(
                'Is my farm data secure?',
                'Yes, all data is encrypted and stored securely. We never share personal information.',
              ),
            ],
          ),
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

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            answer,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Share Anonymous Usage Data'),
              subtitle: Text('Help improve our AI models'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Location-Based Recommendations'),
              subtitle: Text('Get localized crop suggestions'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Marketing Communications'),
              subtitle: Text('Receive farming tips and updates'),
              value: false,
              onChanged: (value) {},
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? Any unsaved data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen or clear user session
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
