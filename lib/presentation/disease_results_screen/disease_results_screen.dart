import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/analyzed_image_widget.dart';
import './widgets/disease_analysis_card.dart';
import './widgets/related_diseases_widget.dart';
import './widgets/treatment_recommendations_widget.dart';

class DiseaseResultsScreen extends StatefulWidget {
  const DiseaseResultsScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseResultsScreen> createState() => _DiseaseResultsScreenState();
}

class _DiseaseResultsScreenState extends State<DiseaseResultsScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isPlaying = false;
  bool _isLoading = false;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Mock data for disease analysis results
  final Map<String, dynamic> _analysisData = {
    'diseaseName': 'Tomato Late Blight',
    'confidence': 87.5,
    'severity': 'Moderate',
    'description':
        'Late blight is a destructive disease that affects tomato plants, causing dark lesions on leaves, stems, and fruits. It spreads rapidly in cool, humid conditions and can destroy entire crops if left untreated.',
  };

  final String _analyzedImageUrl =
      'https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  final List<Map<String, dynamic>> _detectedAreas = [
    {
      'x': 50.0,
      'y': 80.0,
      'width': 120.0,
      'height': 80.0,
      'label': 'Infected Area 1',
    },
    {
      'x': 200.0,
      'y': 150.0,
      'width': 100.0,
      'height': 70.0,
      'label': 'Infected Area 2',
    },
  ];

  final List<Map<String, dynamic>> _treatmentOptions = [
    {
      'type': 'Immediate',
      'title': 'Emergency Treatment',
      'description':
          'Quick action steps to prevent further spread of the disease and minimize crop damage.',
      'cost': '\$25-35',
      'effectiveness': 85.0,
      'duration': '1-2 days',
      'steps': [
        'Remove all infected plant parts immediately',
        'Apply copper-based fungicide spray',
        'Improve air circulation around plants',
        'Reduce watering frequency',
      ],
    },
    {
      'type': 'Organic',
      'title': 'Organic Solution',
      'description':
          'Environmentally friendly treatment using natural ingredients and biological controls.',
      'cost': '\$15-25',
      'effectiveness': 72.0,
      'duration': '3-5 days',
      'steps': [
        'Prepare baking soda solution (1 tsp per quart water)',
        'Add a few drops of liquid soap',
        'Spray on affected areas in early morning',
        'Apply neem oil as preventive measure',
        'Introduce beneficial microorganisms',
      ],
    },
    {
      'type': 'Chemical',
      'title': 'Chemical Treatment',
      'description':
          'Fast-acting chemical fungicides for severe infections requiring immediate intervention.',
      'cost': '\$40-60',
      'effectiveness': 92.0,
      'duration': '2-3 days',
      'steps': [
        'Use systemic fungicide containing metalaxyl',
        'Apply during cool, dry conditions',
        'Ensure complete coverage of plant surfaces',
        'Repeat application after 7-10 days',
        'Monitor for resistance development',
      ],
    },
    {
      'type': 'Prevention',
      'title': 'Prevention Measures',
      'description':
          'Long-term strategies to prevent future occurrences and maintain plant health.',
      'cost': '\$10-20',
      'effectiveness': 78.0,
      'duration': 'Ongoing',
      'steps': [
        'Plant resistant varieties when available',
        'Maintain proper plant spacing',
        'Use drip irrigation instead of overhead watering',
        'Apply mulch to reduce soil splash',
        'Rotate crops annually',
      ],
    },
  ];

  final List<Map<String, dynamic>> _relatedDiseases = [
    {
      'name': 'Tomato Early Blight',
      'imageUrl':
          'https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=800',
      'similarity': 78.5,
      'description':
          'Early blight causes brown spots with concentric rings on older leaves, eventually leading to defoliation.',
      'symptoms': ['Brown spots', 'Concentric rings', 'Leaf yellowing'],
    },
    {
      'name': 'Tomato Septoria Leaf Spot',
      'imageUrl':
          'https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=800',
      'similarity': 65.2,
      'description':
          'Small, circular spots with dark borders and light centers appear on lower leaves first.',
      'symptoms': ['Small spots', 'Dark borders', 'Light centers'],
    },
    {
      'name': 'Tomato Bacterial Speck',
      'imageUrl':
          'https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=800',
      'similarity': 58.7,
      'description':
          'Small, dark brown to black specks appear on leaves, stems, and fruits.',
      'symptoms': ['Dark specks', 'Fruit spots', 'Stem lesions'],
    },
  ];

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Analyzed image with detection overlay
                  AnalyzedImageWidget(
                    imageUrl: _analyzedImageUrl,
                    detectedAreas: _detectedAreas,
                  ),

                  // Disease analysis results
                  DiseaseAnalysisCard(
                    analysisData: _analysisData,
                  ),

                  // Treatment recommendations
                  TreatmentRecommendationsWidget(
                    treatments: _treatmentOptions,
                  ),

                  // Action buttons
                  ActionButtonsWidget(
                    onSaveToHistory: _saveToHistory,
                    onShareResults: _shareResults,
                    onVoicePlayback: _playVoiceInstructions,
                    onRetakePhoto: _retakePhoto,
                    onExpertConsultation: _getExpertConsultation,
                    onFindTreatments: _findTreatmentsNearby,
                  ),

                  // Related diseases
                  RelatedDiseasesWidget(
                    relatedDiseases: _relatedDiseases,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
          size: 6.w,
        ),
      ),
      title: Text(
        'Disease Analysis Results',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      centerTitle: AppTheme.lightTheme.appBarTheme.centerTitle,
      actions: [
        IconButton(
          onPressed: _exportResults,
          icon: CustomIconWidget(
            iconName: 'download',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/dashboard-screen'),
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 3.h),
          Text(
            'Processing analysis results...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _saveToHistory() {
    setState(() {
      _isLoading = true;
    });

    // Simulate saving to history
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showToast('Analysis saved to history successfully');
      }
    });
  }

  void _shareResults() {
    _showToast('Preparing results for sharing...');
    // In a real app, this would use platform-specific sharing
    Future.delayed(Duration(seconds: 1), () {
      _showToast('Results shared successfully');
    });
  }

  Future<void> _playVoiceInstructions() async {
    if (!_isMobile) {
      _showToast('Voice playback unavailable on this platform');
      return;
    }
    if (_isPlaying) {
      await _audioRecorder.stop();
      setState(() {
        _isPlaying = false;
      });
      _showToast('Voice playback stopped');
      return;
    }

    // Request microphone permission for voice synthesis
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) {
      _showToast('Microphone permission required for voice playback');
      return;
    }

    setState(() {
      _isPlaying = true;
    });

    _showToast('Playing treatment instructions...');

    // Simulate voice playback duration
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
        _showToast('Voice playback completed');
      }
    });
  }

  void _retakePhoto() {
    Navigator.pushReplacementNamed(context, '/disease-detection-screen');
  }

  void _getExpertConsultation() {
    _showToast('Connecting to agricultural expert...');
    // In a real app, this would open a consultation interface
  }

  void _findTreatmentsNearby() {
    _showToast('Finding nearby treatment options...');
    // In a real app, this would use location services
  }

  void _exportResults() {
    _showToast('Exporting results...');
    // In a real app, export to PDF or shareable format
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      textColor: Colors.white,
    );
  }
}
