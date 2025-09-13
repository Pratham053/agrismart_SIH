import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/crop_filter_chips_widget.dart';
import './widgets/crop_recommendation_card_widget.dart';
import './widgets/crop_search_bar_widget.dart';
import './widgets/custom_recommendation_fab_widget.dart';
import './widgets/location_header_widget.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isOffline = false;

  // Mock data for crop recommendations
  final List<Map<String, dynamic>> _allCrops = [
    {
      "id": 1,
      "name": "Tomato",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 92,
      "expectedYield": "25 tons/ha",
      "marketPrice": "\$2.50/kg",
      "priceChange": "+12%",
      "plantingTimeline": "March 15",
      "season": "spring",
      "profitLevel": "high",
      "difficulty": "medium",
      "waterRequirement": "medium"
    },
    {
      "id": 2,
      "name": "Wheat",
      "image":
          "https://images.pexels.com/photos/326082/pexels-photo-326082.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 88,
      "expectedYield": "4.2 tons/ha",
      "marketPrice": "\$0.85/kg",
      "priceChange": "+8%",
      "plantingTimeline": "October 20",
      "season": "winter",
      "profitLevel": "medium",
      "difficulty": "easy",
      "waterRequirement": "low"
    },
    {
      "id": 3,
      "name": "Corn",
      "image":
          "https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 85,
      "expectedYield": "8.5 tons/ha",
      "marketPrice": "\$1.20/kg",
      "priceChange": "+5%",
      "plantingTimeline": "April 10",
      "season": "spring",
      "profitLevel": "high",
      "difficulty": "easy",
      "waterRequirement": "medium"
    },
    {
      "id": 4,
      "name": "Rice",
      "image":
          "https://images.pexels.com/photos/1393382/pexels-photo-1393382.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 78,
      "expectedYield": "6.8 tons/ha",
      "marketPrice": "\$1.80/kg",
      "priceChange": "-3%",
      "plantingTimeline": "June 5",
      "season": "monsoon",
      "profitLevel": "medium",
      "difficulty": "medium",
      "waterRequirement": "high"
    },
    {
      "id": 5,
      "name": "Potato",
      "image":
          "https://images.pexels.com/photos/144248/potatoes-vegetables-erdfrucht-bio-144248.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 90,
      "expectedYield": "22 tons/ha",
      "marketPrice": "\$0.95/kg",
      "priceChange": "+15%",
      "plantingTimeline": "February 28",
      "season": "spring",
      "profitLevel": "high",
      "difficulty": "easy",
      "waterRequirement": "low"
    },
    {
      "id": 6,
      "name": "Soybean",
      "image":
          "https://images.pexels.com/photos/6129507/pexels-photo-6129507.jpeg?auto=compress&cs=tinysrgb&w=800",
      "suitabilityScore": 82,
      "expectedYield": "3.2 tons/ha",
      "marketPrice": "\$1.45/kg",
      "priceChange": "+7%",
      "plantingTimeline": "May 15",
      "season": "summer",
      "profitLevel": "medium",
      "difficulty": "easy",
      "waterRequirement": "medium"
    }
  ];

  List<Map<String, dynamic>> get _filteredCrops {
    List<Map<String, dynamic>> filtered = _allCrops;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((crop) => (crop['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedFilter != 'all') {
      switch (_selectedFilter) {
        case 'season':
          filtered =
              filtered.where((crop) => crop['season'] == 'spring').toList();
          break;
        case 'profit':
          filtered =
              filtered.where((crop) => crop['profitLevel'] == 'high').toList();
          break;
        case 'difficulty':
          filtered =
              filtered.where((crop) => crop['difficulty'] == 'easy').toList();
          break;
        case 'water':
          filtered = filtered
              .where((crop) => crop['waterRequirement'] == 'low')
              .toList();
          break;
      }
    }

    // Sort by suitability score
    filtered.sort((a, b) =>
        (b['suitabilityScore'] as int).compareTo(a['suitabilityScore'] as int));

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshRecommendations() async {
    HapticFeedback.lightImpact();
    await _loadRecommendations();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
    HapticFeedback.selectionClick();
  }

  void _onVoiceSearch() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search completed'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCropTap(Map<String, dynamic> crop) {
    HapticFeedback.lightImpact();
    _showCropDetailsBottomSheet(crop);
  }

  void _onFavorite(Map<String, dynamic> crop) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${crop['name']} added to favorites'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onShare(Map<String, dynamic> crop) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${crop['name']} recommendation'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onReminder(Map<String, dynamic> crop) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planting reminder set for ${crop['name']}'),
        backgroundColor: AppTheme.warningColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onLocationEdit() {
    HapticFeedback.lightImpact();
    _showLocationEditDialog();
  }

  void _onCustomRecommendation() {
    HapticFeedback.mediumImpact();
    _showCustomRecommendationBottomSheet();
  }

  void _showLocationEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Location'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your location',
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Location updated successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCropDetailsBottomSheet(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageWidget(
                            imageUrl: crop['image'] as String,
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crop['name'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${crop['suitabilityScore']}% Match',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    _buildDetailSection('Soil Requirements',
                        'Well-drained loamy soil with pH 6.0-7.0. Rich in organic matter with good nitrogen content.'),
                    SizedBox(height: 3.h),
                    _buildDetailSection('Care Instructions',
                        'Regular watering, weekly fertilization, pest monitoring, and proper spacing for optimal growth.'),
                    SizedBox(height: 3.h),
                    _buildDetailSection('Profit Projections',
                        'Expected profit: \$3,200 per hectare. Break-even in 4 months with 65% profit margin.'),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _onFavorite(crop);
                            },
                            icon: CustomIconWidget(
                              iconName: 'favorite',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                            label: Text('Add to Favorites'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _onShare(crop);
                            },
                            icon: CustomIconWidget(
                              iconName: 'share',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 18,
                            ),
                            label: Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  void _showCustomRecommendationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Custom Recommendation',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    SizedBox(height: 3.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Farm Size (hectares)',
                        hintText: 'Enter your farm size',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Budget Range',
                        hintText: 'Enter your budget',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Soil Type',
                        hintText: 'e.g., Clay, Sandy, Loamy',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Water Availability',
                        hintText: 'e.g., Abundant, Limited, Moderate',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Experience Level',
                        hintText: 'e.g., Beginner, Intermediate, Expert',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Additional Requirements',
                        hintText: 'Any specific needs or preferences',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Custom recommendation request submitted'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                        },
                        child: Text('Submit Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 2.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 1.5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: List.generate(
                  3,
                  (index) => Expanded(
                        child: Container(
                          height: 6.h,
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Crop Recommendations'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/dashboard-screen'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          if (_isOffline)
            Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'wifi_off',
                    color: AppTheme.warningColor,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Offline',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.warningColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRecommendations,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            LocationHeaderWidget(
              location: 'Maharashtra, India',
              lastUpdated: '2 hours ago',
              onLocationEdit: _onLocationEdit,
            ),
            CropSearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onVoiceSearch: _onVoiceSearch,
            ),
            CropFilterChipsWidget(
              selectedFilter: _selectedFilter,
              onFilterChanged: _onFilterChanged,
            ),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) => _buildSkeletonCard(),
                    )
                  : _filteredCrops.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No crops found',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredCrops.length,
                          itemBuilder: (context, index) {
                            final crop = _filteredCrops[index];
                            return CropRecommendationCardWidget(
                              cropData: crop,
                              onTap: () => _onCropTap(crop),
                              onFavorite: () => _onFavorite(crop),
                              onShare: () => _onShare(crop),
                              onReminder: () => _onReminder(crop),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomRecommendationFabWidget(
        onPressed: _onCustomRecommendation,
      ),
    );
  }
}
