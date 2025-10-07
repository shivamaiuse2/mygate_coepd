import 'package:flutter/material.dart';
import 'package:mygate_coepd/screens/auth/enter_email_mobile_screen.dart';
import 'package:mygate_coepd/screens/auth/otp_screen.dart';

class NameEmailScreen extends StatefulWidget {
  final ContactType contactType;
  final String contactValue;

  const NameEmailScreen({
    super.key,
    required this.contactType,
    required this.contactValue,
  });

  @override
  State<NameEmailScreen> createState() => _NameEmailScreenState();
}

class _NameEmailScreenState extends State<NameEmailScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _otherContactController;
  late final ContactType _otherType;
  bool _agreeToTerms = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _otherType = widget.contactType == phoneType ? emailType : phoneType;
    _otherContactController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _otherContactController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getContactPrefix() {
    return widget.contactType == phoneType ? '+91 ' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Contact display (read-only)
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.contactType.icon,
                          color: _getToggleColor(widget.contactType),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${widget.contactType.label}: ${_getContactPrefix()}${widget.contactValue}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Enter your details',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'We\'ll use this to create your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Name field
              _buildLabeledField(
                label: 'Full Name',
                controller: _nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 24),

              // Other contact field (the unfilled one)
              _buildLabeledField(
                label: _otherType.label,
                controller: _otherContactController,
                hint: _otherType.hint,
                icon: _otherType.icon,
                keyboardType: _otherType.keyboardType,
              ),
              const SizedBox(height: 32),

              // Terms checkbox
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) => setState(() => _agreeToTerms = value!),
                        activeColor: const Color(0xFF1E88E5),
                        checkColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms & Conditions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_nameController.text.isEmpty ||
                              _otherContactController.text.isEmpty ||
                              !_agreeToTerms)
                          ? null
                          : () {
                              // Navigate to OTP with all data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OTPScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(icon, color: Colors.grey[500]),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Color _getToggleColor(ContactType type) {
    return type == phoneType ? Colors.green : const Color(0xFF1E88E5);
  }
}



// import 'package:flutter/material.dart';
// import 'package:mygate_coepd/screens/auth/otp_screen.dart';

// class NameEmailScreen extends StatefulWidget {
//   const NameEmailScreen({super.key});

//   @override
//   State<NameEmailScreen> createState() => _NameEmailScreenState();
// }

// class _NameEmailScreenState extends State<NameEmailScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   bool _agreeToTerms = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back button
//               IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back_ios, size: 20),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//               const SizedBox(height: 40),
              
//               // Phone number display
//               Center(
//                 child: Text(
//                   '+91-8010155144',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
              
//               // Title
//               const Text(
//                 'Please enter your name and email to proceed further',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 40),
              
//               // Name field
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Name',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       hintText: 'Enter your name',
//                     ),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
              
//               // Email field
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Email',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       hintText: 'Enter your email',
//                     ),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
              
//               // Terms and conditions checkbox
//               Row(
//                 children: [
//                   Checkbox(
//                     value: _agreeToTerms,
//                     onChanged: (value) {
//                       setState(() {
//                         _agreeToTerms = value!;
//                       });
//                     },
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const Expanded(
//                     child: Text(
//                       'I agree to the Terms & Conditions',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
              
//               // Submit button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _agreeToTerms ? () {
//                     // Navigate to OTP screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const OTPScreen(),
//                       ),
//                     );
//                   } : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1E88E5),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Submit',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }