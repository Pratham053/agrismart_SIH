import 'package:flutter/material.dart';
import '../presentation/disease_results_screen/disease_results_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/crop_recommendation_screen/crop_recommendation_screen.dart';
import '../presentation/disease_detection_screen/disease_detection_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/market_prices_screen/market_prices_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/register_screen/register_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/login';
  static const String login = '/login';
  static const String register = '/register';
  static const String diseaseResults = '/disease-results-screen';
  static const String dashboard = '/dashboard-screen';
  static const String cropRecommendation = '/crop-recommendation-screen';
  static const String diseaseDetection = '/disease-detection-screen';
  static const String profile = '/profile-screen';
  static const String marketPrices = '/market-prices-screen';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    diseaseResults: (context) => const DiseaseResultsScreen(),
    dashboard: (context) => const DashboardScreen(),
    cropRecommendation: (context) => const CropRecommendationScreen(),
    diseaseDetection: (context) => const DiseaseDetectionScreen(),
    profile: (context) => const ProfileScreen(),
    marketPrices: (context) => const MarketPricesScreen(),
    // TODO: Add your other routes here
  };
}
