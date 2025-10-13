import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_event.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/config/app_config.dart';
import 'package:mygate_coepd/screens/resident/resident_main_screen.dart';
import 'package:mygate_coepd/screens/guard/guard_main_screen.dart';
import 'package:mygate_coepd/screens/admin/admin_main_screen.dart';
import 'package:mygate_coepd/screens/approval_pending_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _otpSent = false;
  String _otp = '';
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _societyIdController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    // Pre-fill phone if remember device is enabled
    if (AppConfig.rememberDevice && AppConfig.selectedRole != null) {
      _phoneController.text = AppConfig.selectedRole ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _societyIdController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        if (!_otpSent) {
          setState(() {
            _otpSent = true;
          });
        } else {
          // Login with OTP
          context.read<AuthBloc>().add(
            LoginRequested(phone: _phoneController.text, otp: _otp),
          );
        }
      } else {
        if (!_otpSent) {
          setState(() {
            _otpSent = true;
          });
        } else {
          // Register
          context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text,
              phone: _phoneController.text,
              societyId: _societyIdController.text,
              unit: _unitController.text,
              role: AppConfig.selectedRole ?? 'resident',
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = AppConfig.selectedRole ?? 'resident';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFf8f9fa);
    final surfaceColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.grey;
    final iconColor = const Color(0xFF006D77);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: Column(
          children: [
            // Header with role info
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
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -25,
                    left: 30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                selectedRole == 'guard'
                                    ? Icons.shield_outlined
                                    : selectedRole == 'admin'
                                    ? Icons.admin_panel_settings_outlined
                                    : Icons.home_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Logging in as',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  selectedRole == 'guard'
                                      ? 'Security Guard'
                                      : selectedRole == 'admin'
                                      ? 'Administrator'
                                      : 'Resident',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _isLogin ? 'Welcome Back' : 'Join Your Community',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _isLogin
                              ? 'Sign in to access your community'
                              : 'Create an account to get started',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Form content
            Expanded(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is AuthLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing...'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  } else if (state is Authenticated) {
                    // Navigate based on the selected role from AppConfig, not the user's role from database
                    // This ensures navigation follows the role selected in role selection screen
                    final selectedRole = AppConfig.selectedRole ?? 'resident';
                    if (selectedRole == 'guard') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const GuardMainScreen(),
                        ),
                      );
                    } else if (selectedRole == 'admin') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AdminMainScreen(),
                        ),
                      );
                    } else {
                      // Check if user is approved
                      if (state.user.isApproved == false) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                const ApprovalPendingScreen(),
                          ),
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ResidentMainScreen(),
                          ),
                        );
                      }
                    }
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isLogin) ...[
                          // Society ID for registration
                          Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isDarkMode
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                            ),
                            child: TextFormField(
                              controller: _societyIdController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Society ID',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.apartment_outlined,
                                  color: iconColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (!_isLogin &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter society ID';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Name for registration
                          Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isDarkMode
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: iconColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (!_isLogin &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Unit for resident registration
                          if (selectedRole == 'resident')
                            Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isDarkMode
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                              ),
                              child: TextFormField(
                                controller: _unitController,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  labelText: 'Unit/Apartment Number',
                                  labelStyle: TextStyle(color: secondaryTextColor),
                                  prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    color: iconColor,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (!_isLogin &&
                                      selectedRole == 'resident' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your unit number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                        // Phone number
                        Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isDarkMode
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: secondaryTextColor),
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: iconColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only digits
                              LengthLimitingTextInputFormatter(
                                10,
                              ), // Limit to 10 digits (invisible)
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              // Simple phone validation
                              if (!RegExp(
                                r'^[0-9]{10,15}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email address
                        Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isDarkMode
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: secondaryTextColor),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: iconColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              // Simple phone validation
                              if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_otpSent) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Enter OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isDarkMode
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: TextFormField(
                                    controller: _otpControllers[index],
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(15),
                                      alignLabelWithHint: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (_otpSent &&
                                          (value == null || value.isEmpty)) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      // Move to next field
                                      if (value.isNotEmpty && index < 5) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                      // Update OTP string
                                      _otp = _otpControllers
                                          .map(
                                            (controller) => controller.text,
                                          )
                                          .join();
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          if (_isLogin)
                            Row(
                              children: [
                                Checkbox(
                                  value: AppConfig.rememberDevice,
                                  onChanged: (value) {
                                    setState(() {
                                      AppConfig.setRememberDevice(
                                        value ?? false,
                                      );
                                    });
                                  },
                                  activeColor: iconColor,
                                ),
                                Text(
                                  'Remember this device',
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                        ],
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        _submitForm();
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: iconColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: isDarkMode ? 2 : 5,
                                ),
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      )
                                    : Text(
                                        _otpSent
                                            ? (_isLogin
                                                  ? 'Sign In'
                                                  : 'Create Account')
                                            : (_isLogin
                                                  ? 'Send OTP'
                                                  : 'Send OTP'),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _otpSent = false;
                                _otp = '';
                                // Clear OTP fields
                                for (var controller in _otpControllers) {
                                  controller.clear();
                                }
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? "Don't have an account? Sign up"
                                  : 'Already have an account? Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Navigate to role selection screen
                              Navigator.of(
                                context,
                              ).pushNamed('/role-selection');
                            },
                            child: Text(
                              'Change Role',
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}