import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' show Platform;

import '../../core/app_export.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/processing_animation_widget.dart';
import './widgets/voice_guidance_widget.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  XFile? _capturedImage;

  // Processing states
  bool _isProcessing = false;
  bool _isPlantDetected = false;
  double _confidenceLevel = 0.0;

  // Voice guidance
  bool _isVoiceEnabled = true;
  bool _isListening = false;
  String _currentInstruction = '';
  final AudioRecorder _audioRecorder = AudioRecorder();

  // UI states
  String _guidanceText = 'Position leaf within the frame';
  final ImagePicker _imagePicker = ImagePicker();

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Mock detection data for realistic simulation
  final List<Map<String, dynamic>> _mockDetectionResults = [
    {
      "disease": "Leaf Blight",
      "confidence": 0.89,
      "severity": "Moderate",
      "treatment": "Apply copper-based fungicide spray every 7-10 days",
      "description": "Brown spots with yellow halos on leaf surface",
    },
    {
      "disease": "Powdery Mildew",
      "confidence": 0.92,
      "severity": "Mild",
      "treatment": "Increase air circulation and apply sulfur-based treatment",
      "description": "White powdery coating on leaf surface",
    },
    {
      "disease": "Bacterial Spot",
      "confidence": 0.85,
      "severity": "Severe",
      "treatment": "Remove affected leaves and apply bactericide",
      "description": "Dark spots with water-soaked margins",
    },
    {
      "disease": "Healthy Plant",
      "confidence": 0.95,
      "severity": "None",
      "treatment": "Continue regular care and monitoring",
      "description": "No disease symptoms detected",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_isMobile) {
    _initializeCamera();
    _startVoiceGuidance();
    } else {
      _isVoiceEnabled = false;
      _guidanceText = 'Use gallery to upload an image for analysis';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed && _isMobile) {
      _initializeCamera();
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb || !_isMobile) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb || !_isMobile) return true;
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    if (!_isMobile) return;
    try {
      if (!await _requestCameraPermission()) {
        _showPermissionDialog(
            'Camera access is required for disease detection');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _startPlantDetection();
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showErrorDialog('Failed to initialize camera. Please try again.');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      debugPrint('Settings error: $e');
    }
  }

  void _startPlantDetection() {
    // Simulate real-time plant detection
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isPlantDetected = true;
          _confidenceLevel = 0.75 + (DateTime.now().millisecond % 25) / 100;
          _guidanceText = 'Plant detected! Hold steady for best results';
        });
        _updateVoiceInstruction('Plant detected. Hold steady for analysis.');
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      // Haptic feedback
      HapticFeedback.mediumImpact();

      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });

      // Simulate AI processing time
      await Future.delayed(Duration(seconds: 3));

      // Navigate to results with mock data
      final mockResult = _mockDetectionResults[
          DateTime.now().millisecond % _mockDetectionResults.length];

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/disease-results-screen',
          arguments: {
            'imagePath': photo.path,
            'detectionResult': mockResult,
            'analysisDate': DateTime.now(),
          },
        );
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      _showErrorDialog('Failed to capture photo. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _isProcessing = true;
        });

        // Simulate processing
        await Future.delayed(Duration(seconds: 2));

        final mockResult = _mockDetectionResults[
            DateTime.now().millisecond % _mockDetectionResults.length];

        if (mounted) {
          Navigator.pushNamed(
            context,
            '/disease-results-screen',
            arguments: {
              'imagePath': image.path,
              'detectionResult': mockResult,
              'analysisDate': DateTime.now(),
            },
          );
        }
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      _showErrorDialog('Failed to select image from gallery.');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      await _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;

    try {
      setState(() {
        _isCameraInitialized = false;
        _isFrontCamera = !_isFrontCamera;
      });

      await _cameraController?.dispose();

      final camera = _isFrontCamera
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera flip error: $e');
      _showErrorDialog('Failed to switch camera.');
    }
  }

  Future<void> _startVoiceGuidance() async {
    if (!_isVoiceEnabled || !_isMobile) return;

    if (!await _requestMicrophonePermission()) {
      setState(() {
        _isVoiceEnabled = false;
      });
      return;
    }

    _updateVoiceInstruction('Position the leaf within the camera frame');
  }

  void _updateVoiceInstruction(String instruction) {
    if (!_isVoiceEnabled) return;

    setState(() {
      _currentInstruction = instruction;
      _isListening = true;
    });

    // Simulate voice instruction duration
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
  }

  void _toggleVoiceGuidance() {
    setState(() {
      _isVoiceEnabled = !_isVoiceEnabled;
      if (!_isVoiceEnabled) {
        _currentInstruction = '';
        _isListening = false;
      } else {
        _startVoiceGuidance();
      }
    });
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Permission Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        title: Text(
          'Disease Detection',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-screen'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          if (_isMobile && _isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isMobile)
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        )
                      else
                        Icon(Icons.image, color: Colors.white70, size: 48),
                      SizedBox(height: 2.h),
                      Text(
                        _isMobile
                            ? 'Initializing camera...'
                            : 'Camera not available on desktop. Use gallery to upload.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Camera overlay with guides
          if (_isMobile && _isCameraInitialized)
            CameraOverlayWidget(
              isPlantDetected: _isPlantDetected,
              guidanceText: _guidanceText,
              confidenceLevel: _confidenceLevel,
            ),

          // Voice guidance controls
          if (_isMobile)
          VoiceGuidanceWidget(
            isListening: _isListening,
            isVoiceEnabled: _isVoiceEnabled,
            onToggleVoice: _toggleVoiceGuidance,
            currentInstruction: _currentInstruction,
          ),

          // Camera controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CameraControlsWidget(
              isFlashOn: _isFlashOn,
              isFrontCamera: _isFrontCamera,
              onFlashToggle: _isMobile ? () { _toggleFlash(); } : () {},
              onCameraFlip: _isMobile ? () { _flipCamera(); } : () {},
              onGalleryTap: () { _selectFromGallery(); },
              onCapture: _isMobile ? () { _capturePhoto(); } : () {},
              isProcessing: _isProcessing,
            ),
          ),

          // Processing animation overlay
          ProcessingAnimationWidget(
            isVisible: _isProcessing,
            processingText: 'Analyzing Plant Health',
          ),
        ],
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
        currentIndex: 2, // Scan tab is active
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
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'agriculture',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    print('Bottom nav tapped: $index'); // Debug print
    switch (index) {
      case 0:
        print('Navigating to dashboard');
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
        break;
      case 1:
        print('Navigating to crop recommendation');
        Navigator.pushReplacementNamed(context, '/crop-recommendation-screen');
        break;
      case 2:
        print('Already on scan screen');
        // Already on scan screen
        break;
      case 3:
        print('Navigating to market prices');
        Navigator.pushReplacementNamed(context, '/market-prices-screen');
        break;
      case 4:
        print('Navigating to profile');
        Navigator.pushReplacementNamed(context, '/profile-screen');
        break;
    }
  }
}
