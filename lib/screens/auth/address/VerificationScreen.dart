import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mygate_coepd/config/app_config.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        
        // Simulate upload process
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to next screen or show success message
          // For now, we'll just show a success dialog
          _showSuccessDialog();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No image selected'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text('Verification Submitted'),
          content: const Text(
            'Your document has been submitted for verification. You will be notified once it is approved.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to main app or auth screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    
    final selectedRole = AppConfig.selectedRole ?? 'resident';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFf8f9fa);
    final surfaceColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.grey;
    final iconColor = const Color(0xFF006D77);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            // Header with role info - Matching AuthScreen design
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF006D77), Color(0xFF005A63)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Decorative background elements
                  Positioned(
                    top: -30.h,
                    right: -30.w,
                    child: Container(
                      width: 120.r,
                      height: 120.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -25.h,
                    left: 30.w,
                    child: Container(
                      width: 80.r,
                      height: 80.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                      top: 50.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                selectedRole == 'guard'
                                    ? Icons.shield_outlined
                                    : selectedRole == 'admin'
                                    ? Icons.admin_panel_settings_outlined
                                    : Icons.home_outlined,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Registering as',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  selectedRole == 'guard'
                                      ? 'Security Guard'
                                      : selectedRole == 'admin'
                                      ? 'Administrator'
                                      : 'Resident',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Verify Your Identity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Upload a document for verification',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Text(
                      'Place document inside the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Scanner Frame or Preview
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: iconColor, width: 4.w),
                          borderRadius: BorderRadius.circular(24.r),
                          color: _image == null
                              ? Colors.black.withValues(alpha: 0.3)
                              : null,
                        ),
                        child: _image == null
                            ? Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.document_scanner,
                                          size: 80.sp,
                                          color: iconColor,
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          'Place document here',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Corners
                                  ...[
                                    Alignment.topLeft,
                                    Alignment.topRight,
                                    Alignment.bottomLeft,
                                    Alignment.bottomRight
                                  ].map(
                                    (a) => Align(
                                      alignment: a,
                                      child: Container(
                                        margin: EdgeInsets.all(20.w),
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: iconColor,
                                            width: 6.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () {
                                _pickImage(ImageSource.camera);
                              },
                        icon: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          _isLoading ? 'Uploading...' : 'Take Photo',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: isDarkMode ? 2 : 5,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _pickImage(ImageSource.gallery);
                            },
                      child: Text(
                        'Choose from Gallery',
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    if (_image != null) ...[
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: iconColor, width: 2.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Retake Photo',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                    
                    SizedBox(height: 100.h), // extra space so button never gets hidden
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}