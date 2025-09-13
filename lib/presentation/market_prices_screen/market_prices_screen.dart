import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_custom_crop_modal_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/location_selector_widget.dart';
import './widgets/price_alert_modal_widget.dart';
import './widgets/price_card_widget.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({Key? key}) : super(key: key);

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _selectedFilters = ['all'];
  String _selectedLocation = 'New York, NY';
  bool _isLoading = false;
  bool _isVoiceSearchActive = false;
  List<Map<String, dynamic>> _filteredPrices = [];
  List<Map<String, dynamic>> _allPrices = [];
  Set<String> _watchlist = {};
  Set<String> _favorites = {};

  final List<String> _availableLocations = [
    'New York, NY',
    'Los Angeles, CA',
    'Chicago, IL',
    'Houston, TX',
    'Phoenix, AZ',
    'Philadelphia, PA',
    'San Antonio, TX',
    'San Diego, CA',
    'Dallas, TX',
    'San Jose, CA',
  ];

  final List<Map<String, dynamic>> _mockPriceData = [
    {
      "id": 1,
      "name": "Wheat",
      "currentPrice": 245.50,
      "change": 12.30,
      "changePercent": 5.3,
      "unit": "per bushel",
      "category": "grains",
      "trendData": [230.0, 235.5, 240.2, 238.8, 242.1, 245.5],
      "lastUpdated": "2025-09-10T14:15:00Z",
      "location": "Chicago Board of Trade"
    },
    {
      "id": 2,
      "name": "Corn",
      "currentPrice": 189.75,
      "change": -8.25,
      "changePercent": -4.2,
      "unit": "per bushel",
      "category": "grains",
      "trendData": [195.0, 198.0, 192.5, 190.2, 187.8, 189.75],
      "lastUpdated": "2025-09-10T14:12:00Z",
      "location": "Chicago Board of Trade"
    },
    {
      "id": 3,
      "name": "Soybeans",
      "currentPrice": 412.80,
      "change": 18.90,
      "changePercent": 4.8,
      "unit": "per bushel",
      "category": "grains",
      "trendData": [390.0, 395.5, 405.2, 408.1, 410.5, 412.8],
      "lastUpdated": "2025-09-10T14:10:00Z",
      "location": "Chicago Board of Trade"
    },
    {
      "id": 4,
      "name": "Tomatoes",
      "currentPrice": 3.45,
      "change": 0.15,
      "changePercent": 4.5,
      "unit": "per lb",
      "category": "vegetables",
      "trendData": [3.20, 3.25, 3.35, 3.40, 3.42, 3.45],
      "lastUpdated": "2025-09-10T14:08:00Z",
      "location": "Local Market"
    },
    {
      "id": 5,
      "name": "Potatoes",
      "currentPrice": 1.89,
      "change": -0.12,
      "changePercent": -6.0,
      "unit": "per lb",
      "category": "vegetables",
      "trendData": [2.10, 2.05, 1.98, 1.95, 1.92, 1.89],
      "lastUpdated": "2025-09-10T14:05:00Z",
      "location": "Local Market"
    },
    {
      "id": 6,
      "name": "Apples",
      "currentPrice": 2.75,
      "change": 0.25,
      "changePercent": 10.0,
      "unit": "per lb",
      "category": "fruits",
      "trendData": [2.40, 2.45, 2.55, 2.65, 2.70, 2.75],
      "lastUpdated": "2025-09-10T14:00:00Z",
      "location": "Local Market"
    },
    {
      "id": 7,
      "name": "Rice",
      "currentPrice": 156.20,
      "change": 5.80,
      "changePercent": 3.9,
      "unit": "per cwt",
      "category": "grains",
      "trendData": [148.0, 150.5, 152.8, 154.2, 155.1, 156.2],
      "lastUpdated": "2025-09-10T13:58:00Z",
      "location": "Chicago Board of Trade"
    },
    {
      "id": 8,
      "name": "Onions",
      "currentPrice": 1.25,
      "change": -0.08,
      "changePercent": -6.0,
      "unit": "per lb",
      "category": "vegetables",
      "trendData": [1.40, 1.35, 1.32, 1.28, 1.26, 1.25],
      "lastUpdated": "2025-09-10T13:55:00Z",
      "location": "Local Market"
    },
  ];

  @override
  void initState() {
    super.initState();
    _allPrices = List.from(_mockPriceData);
    _filteredPrices = List.from(_allPrices);
    _favorites = {'Wheat', 'Corn', 'Tomatoes'};
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterPrices() {
    setState(() {
      _filteredPrices = _allPrices.where((price) {
        final name = (price['name'] as String).toLowerCase();
        final category = price['category'] as String;
        final searchQuery = _searchController.text.toLowerCase();

        // Search filter
        if (searchQuery.isNotEmpty && !name.contains(searchQuery)) {
          return false;
        }

        // Category filters
        if (_selectedFilters.contains('all')) {
          return true;
        }

        if (_selectedFilters.contains('grains') && category == 'grains')
          return true;
        if (_selectedFilters.contains('vegetables') && category == 'vegetables')
          return true;
        if (_selectedFilters.contains('fruits') && category == 'fruits')
          return true;

        // Price change filters
        final change = (price['change'] as num).toDouble();
        if (_selectedFilters.contains('price_up') && change > 0) return true;
        if (_selectedFilters.contains('price_down') && change < 0) return true;

        // Favorites filter
        if (_selectedFilters.contains('favorites') &&
            _favorites.contains(price['name'])) return true;

        // Nearby filter (mock implementation)
        if (_selectedFilters.contains('nearby')) return true;

        return false;
      }).toList();

      // Sort by price change if specific filters are selected
      if (_selectedFilters.contains('price_up')) {
        _filteredPrices
            .sort((a, b) => (b['change'] as num).compareTo(a['change'] as num));
      } else if (_selectedFilters.contains('price_down')) {
        _filteredPrices
            .sort((a, b) => (a['change'] as num).compareTo(b['change'] as num));
      }
    });
  }

  void _onFilterToggle(String filter) {
    setState(() {
      if (filter == 'all') {
        _selectedFilters = ['all'];
      } else {
        _selectedFilters.remove('all');
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
          if (_selectedFilters.isEmpty) {
            _selectedFilters.add('all');
          }
        } else {
          _selectedFilters.add(filter);
        }
      }
    });
    _filterPrices();
  }

  Future<void> _refreshPrices() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Mock price updates
    for (var price in _allPrices) {
      final random = (DateTime.now().millisecondsSinceEpoch % 100) / 100;
      final changeAmount = (random - 0.5) * 10;
      final currentPrice = (price['currentPrice'] as num).toDouble();
      final newPrice = currentPrice + changeAmount;

      price['currentPrice'] = double.parse(newPrice.toStringAsFixed(2));
      price['change'] = double.parse(changeAmount.toStringAsFixed(2));
      price['changePercent'] = double.parse(
          ((changeAmount / currentPrice) * 100).toStringAsFixed(1));
      price['lastUpdated'] = DateTime.now().toIso8601String();
    }

    setState(() => _isLoading = false);
    _filterPrices();

    Fluttertoast.showToast(
      msg: "Prices updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onPriceCardTap(Map<String, dynamic> priceData) {
    // Navigate to detailed price history screen
    Fluttertoast.showToast(
      msg: "Opening detailed view for ${priceData['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onSetAlert(Map<String, dynamic> cropData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PriceAlertModalWidget(
          cropData: cropData,
          onSetAlert: (targetPrice, alertType) {
            Fluttertoast.showToast(
              msg:
                  "Alert set for ${cropData['name']} ${alertType} \$${targetPrice.toStringAsFixed(2)}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  void _onAddToWatchlist(Map<String, dynamic> cropData) {
    setState(() {
      final cropName = cropData['name'] as String;
      if (_watchlist.contains(cropName)) {
        _watchlist.remove(cropName);
        Fluttertoast.showToast(
          msg: "$cropName removed from watchlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        _watchlist.add(cropName);
        Fluttertoast.showToast(
          msg: "$cropName added to watchlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _onSharePrice(Map<String, dynamic> cropData) {
    final cropName = cropData['name'] as String;
    final currentPrice = (cropData['currentPrice'] as num).toDouble();
    final change = (cropData['change'] as num).toDouble();
    final changePercent = (cropData['changePercent'] as num).toDouble();

    final shareText =
        "$cropName: \$${currentPrice.toStringAsFixed(2)} (${change >= 0 ? '+' : ''}\$${change.toStringAsFixed(2)}, ${changePercent.toStringAsFixed(1)}%) - AgriSmart Market Prices";

    Fluttertoast.showToast(
      msg: "Sharing price info for $cropName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleVoiceSearch() {
    setState(() => _isVoiceSearchActive = !_isVoiceSearchActive);

    if (_isVoiceSearchActive) {
      // Mock voice search implementation
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isVoiceSearchActive = false;
            _searchController.text = "wheat";
          });
          _filterPrices();
          Fluttertoast.showToast(
            msg: "Voice search: wheat",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      });
    }
  }

  void _onLocationChanged(String newLocation) {
    setState(() => _selectedLocation = newLocation);
    _refreshPrices();
  }

  void _useCurrentLocation() {
    setState(() => _selectedLocation = "Current Location");
    Fluttertoast.showToast(
      msg: "Using current location for pricing",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    _refreshPrices();
  }

  void _showAddCustomCropModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddCustomCropModalWidget(
          onAddCrop: (cropName, variety, category) {
            final newCrop = {
              "id": _allPrices.length + 1,
              "name": variety.isNotEmpty ? "$cropName ($variety)" : cropName,
              "currentPrice": 0.0,
              "change": 0.0,
              "changePercent": 0.0,
              "unit": "per unit",
              "category": category.toLowerCase(),
              "trendData": [0.0],
              "lastUpdated": DateTime.now().toIso8601String(),
              "location": "Custom Entry"
            };

            setState(() {
              _allPrices.add(newCrop);
            });
            _filterPrices();

            Fluttertoast.showToast(
              msg: "Custom crop added: $cropName",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Market Prices',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        centerTitle: AppTheme.lightTheme.appBarTheme.centerTitle,
        actions: [
          IconButton(
            onPressed: () {
              // Export market report functionality
              Fluttertoast.showToast(
                msg: "Exporting market report...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Selector
          LocationSelectorWidget(
            selectedLocation: _selectedLocation,
            availableLocations: _availableLocations,
            onLocationChanged: _onLocationChanged,
            onUseCurrentLocation: _useCurrentLocation,
          ),

          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterPrices(),
              decoration: InputDecoration(
                hintText: 'Search crops...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _filterPrices();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    IconButton(
                      onPressed: _toggleVoiceSearch,
                      icon: CustomIconWidget(
                        iconName: _isVoiceSearchActive ? 'mic' : 'mic_none',
                        color: _isVoiceSearchActive
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                  ],
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
          ),

          // Filter Chips
          FilterChipsWidget(
            selectedFilters: _selectedFilters,
            onFilterToggle: _onFilterToggle,
          ),

          SizedBox(height: 1.h),

          // Price List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPrices,
              color: AppTheme.lightTheme.primaryColor,
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Updating prices...',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _filteredPrices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No crops found',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredPrices.length,
                          itemBuilder: (context, index) {
                            final priceData = _filteredPrices[index];
                            return PriceCardWidget(
                              priceData: priceData,
                              onTap: () => _onPriceCardTap(priceData),
                              onSetAlert: () => _onSetAlert(priceData),
                              onAddToWatchlist: () =>
                                  _onAddToWatchlist(priceData),
                              onShare: () => _onSharePrice(priceData),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCustomCropModal,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        elevation: AppTheme.lightTheme.floatingActionButtonTheme.elevation,
        shape: AppTheme.lightTheme.floatingActionButtonTheme.shape,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: AppTheme.lightTheme.bottomNavigationBarTheme.type!,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
        elevation: AppTheme.lightTheme.bottomNavigationBarTheme.elevation!,
        currentIndex: 3, // Market tab is active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard-screen');
              break;
            case 1:
              Navigator.pushReplacementNamed(
                  context, '/crop-recommendation-screen');
              break;
            case 2:
              Navigator.pushReplacementNamed(
                  context, '/disease-detection-screen');
              break;
            case 3:
              // Current screen - Market Prices
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile-screen');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'agriculture',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'agriculture',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Detect',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
