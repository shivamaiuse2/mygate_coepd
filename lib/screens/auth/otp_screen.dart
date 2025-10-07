import 'dart:async';

import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _setupOtpFocusListeners();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _setupOtpFocusListeners() {
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (!_otpFocusNodes[i].hasFocus && _otpControllers[i].text.isEmpty && i > 0) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i - 1]);
        }
      });
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpControllers.length - 1) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    }
  }

  void _resendOTP() {
    setState(() {
      _resendTimer = 30;
    });
    _startResendTimer();
    // Implement OTP resend logic here
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Signup',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'OTP has been sent to you on your mobile phone\nand email ID',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // Contact info
              Center(
                child: Column(
                  children: [
                    Text(
                      '+91-8010155144',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'shivamkhule27@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              
              // Resend OTP
              Center(
                child: _resendTimer > 0
                    ? Text(
                        'Resend OTP after $_resendTimer sec',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    : TextButton(
                        onPressed: _resendOTP,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              
              // Info text
              const Center(
                child: Text(
                  'Users with Non Indian Mobile Numbers will receive\nthe OTP on the registered Email Address.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),
              const Spacer(),
              
              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement OTP verification logic
                    String otp = _otpControllers.map((controller) => controller.text).join();
                    if (otp.length == 6) {
                      // Verify OTP
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}