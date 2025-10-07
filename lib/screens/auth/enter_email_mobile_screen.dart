import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mygate_coepd/screens/auth/otp_screen.dart';

class ContactType {
  final String value;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String hint;

  const ContactType({
    required this.value,
    required this.label,
    required this.icon,
    required this.keyboardType,
    required this.hint,
  });
}

const phoneType = ContactType(
  value: 'phone',
  label: 'Mobile Number',
  icon: Icons.phone,
  keyboardType: TextInputType.phone,
  hint: 'Enter your mobile number',
);

const emailType = ContactType(
  value: 'email',
  label: 'Email Address',
  icon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  hint: 'Enter your email address',
);

class EnterEmailMobileScreen extends StatefulWidget {
  const EnterEmailMobileScreen({super.key});

  @override
  State<EnterEmailMobileScreen> createState() => _EnterEmailMobileScreenState();
}

class _EnterEmailMobileScreenState extends State<EnterEmailMobileScreen>
    with TickerProviderStateMixin {
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _contactFocusNode = FocusNode();
  ContactType _selectedType = phoneType;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();

    // Add listener to trigger rebuild on text changes
    _contactController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _contactController.dispose();
    _contactFocusNode.dispose();
    super.dispose();
  }

  void _switchContactType(ContactType newType) {
    setState(() {
      _selectedType = newType;
    });
    _animationController.reset();
    _animationController.forward();
    _contactController.clear();
    _contactFocusNode.requestFocus();
  }

  List<TextInputFormatter>? _getInputFormatters(ContactType type) {
    if (type == phoneType) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    return null;
  }

  bool _isContactValid() {
    final text = _contactController.text.trim();
    if (text.isEmpty) return false;

    if (_selectedType == phoneType) {
      return text.length == 10 && int.tryParse(text) != null;
    } else {
      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isContactValid();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with animation
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

              // Title with animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle with animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Please enter your ${_selectedType.label.toLowerCase()} to proceed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Toggle buttons for switch
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Row(
                  key: ValueKey(_selectedType.value),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildToggleButton(phoneType, Colors.green),
                    _buildToggleButton(emailType, const Color(0xFF1E88E5)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contact input field with animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      key: ValueKey(_selectedType.value),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _contactController,
                        focusNode: _contactFocusNode,
                        keyboardType: _selectedType.keyboardType,
                        inputFormatters: _getInputFormatters(_selectedType),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(_selectedType.icon, color: _getToggleColor(_selectedType)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          hintText: _selectedType.hint,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: _selectedType == phoneType && _contactController.text.length != 10
                              ? 'Please enter a valid 10-digit mobile number'
                              : (_selectedType == emailType && _contactController.text.isNotEmpty && !_isContactValid())
                                  ? 'Please enter a valid email address'
                                  : null,
                          errorStyle: TextStyle(color: Colors.red[400], fontSize: 12),
                        ),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit button with animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isValid
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NameEmailScreen(
                                    contactType: _selectedType,
                                    contactValue: _selectedType.value == 'phone'
                                        ? '+91 ${_contactController.text}'
                                        : _contactController.text.trim(),
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid ? const Color(0xFF1E88E5) : Colors.grey[300],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isValid ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Footer section with subtle animation
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
                  ),
                  child: _buildFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(ContactType type, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => _switchContactType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, size: 18, color: isSelected ? color : Colors.grey[500]),
            const SizedBox(width: 8),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getToggleColor(ContactType type) {
    return type == phoneType ? Colors.green : const Color(0xFF1E88E5);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'mygate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 32),
        ...[
          'Does not sell or trade your data',
          'Is ISO 27001 certified for information security',
          'Encrypts and secures your data',
          'Is certified GDPR ready, the gold standard in data privacy',
        ].map((text) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PrivacyPoint(text: text),
        )),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {}, // Handle navigation
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF1E88E5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {}, // Handle navigation
              child: const Text(
                'Terms & Conditions',
                style: TextStyle(
                  color: Color(0xFF1E88E5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  final String text;

  const _PrivacyPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF1E88E5),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

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

    // Add listeners to trigger rebuild on text changes
    _nameController.addListener(() {
      setState(() {});
    });
    _otherContactController.addListener(() {
      setState(() {});
    });
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

  List<TextInputFormatter>? _getInputFormatters(ContactType type) {
    if (type == phoneType) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    return null;
  }

  bool _isOtherContactValid() {
    final text = _otherContactController.text.trim();
    if (text.isEmpty) return false;

    if (_otherType == phoneType) {
      return text.length == 10 && int.tryParse(text) != null;
    } else {
      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(text);
    }
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _isOtherContactValid() &&
        _agreeToTerms;
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _isFormValid();

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
                errorText: _nameController.text.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),

              // Other contact field (the unfilled one)
              _buildLabeledField(
                label: _otherType.label,
                controller: _otherContactController,
                hint: _otherType.hint,
                icon: _otherType.icon,
                keyboardType: _otherType.keyboardType,
                inputFormatters: _getInputFormatters(_otherType),
                errorText: !_isOtherContactValid() && _otherContactController.text.isNotEmpty
                    ? (_otherType == phoneType ? 'Please enter a valid 10-digit mobile number' : 'Please enter a valid email address')
                    : (_otherContactController.text.isEmpty ? 'This field is required' : null),
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
              const SizedBox(height: 8),
              if (!isFormValid && _nameController.text.isNotEmpty && _otherContactController.text.isNotEmpty && !_agreeToTerms)
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Please agree to the Terms & Conditions',
                    style: TextStyle(color: Colors.red[400], fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // Submit button
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isFormValid
                          ? () {
                              // Navigate to OTP with all data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OTPScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid ? const Color(0xFF1E88E5) : Colors.grey[300],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isFormValid ? Colors.white : Colors.grey[600],
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
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
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
              inputFormatters: inputFormatters,
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
                errorText: errorText,
                errorStyle: TextStyle(color: Colors.red[400], fontSize: 12),
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
// import 'package:mygate_coepd/screens/auth/name_email_screen.dart';

// class ContactType {
//   final String value;
//   final String label;
//   final IconData icon;
//   final TextInputType keyboardType;
//   final String hint;

//   const ContactType({
//     required this.value,
//     required this.label,
//     required this.icon,
//     required this.keyboardType,
//     required this.hint,
//   });
// }

// const phoneType = ContactType(
//   value: 'phone',
//   label: 'Mobile Number',
//   icon: Icons.phone,
//   keyboardType: TextInputType.phone,
//   hint: 'Enter your mobile number',
// );

// const emailType = ContactType(
//   value: 'email',
//   label: 'Email Address',
//   icon: Icons.email,
//   keyboardType: TextInputType.emailAddress,
//   hint: 'Enter your email address',
// );

// class EnterEmailMobileScreen extends StatefulWidget {
//   const EnterEmailMobileScreen({super.key});

//   @override
//   State<EnterEmailMobileScreen> createState() => _EnterEmailMobileScreenState();
// }

// class _EnterEmailMobileScreenState extends State<EnterEmailMobileScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController _contactController = TextEditingController();
//   final FocusNode _contactFocusNode = FocusNode();
//   ContactType _selectedType = phoneType;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _contactController.dispose();
//     _contactFocusNode.dispose();
//     super.dispose();
//   }

//   void _switchContactType(ContactType newType) {
//     setState(() {
//       _selectedType = newType;
//     });
//     _animationController.reset();
//     _animationController.forward();
//     _contactController.clear();
//     _contactFocusNode.requestFocus();
//   }

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
//               // Back button with animation
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black87),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Title with animation
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: const Text(
//                     'Get Started',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                       height: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Subtitle with animation
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Text(
//                     'Please enter your ${_selectedType.label.toLowerCase()} to proceed',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Toggle buttons for switch
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 250),
//                 child: Row(
//                   key: ValueKey(_selectedType.value),
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildToggleButton(phoneType, Colors.green),
//                     _buildToggleButton(emailType, const Color(0xFF1E88E5)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Contact input field with animation
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Container(
//                       key: ValueKey(_selectedType.value),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: _contactController,
//                         focusNode: _contactFocusNode,
//                         keyboardType: _selectedType.keyboardType,
//                         decoration: InputDecoration(
//                           prefixIcon: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Icon(_selectedType.icon, color: _getToggleColor(_selectedType)),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                           hintText: _selectedType.hint,
//                           hintStyle: TextStyle(color: Colors.grey[400]),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Submit button with animation
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _contactController.text.isEmpty
//                           ? null
//                           : () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => NameEmailScreen(
//                                     contactType: _selectedType,
//                                     contactValue: _selectedType.value == 'phone'
//                                         ? '+91 ${_contactController.text}'
//                                         : _contactController.text,
//                                   ),
//                                 ),
//                               );
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1E88E5),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         padding: EdgeInsets.zero,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: const Text(
//                         'Continue',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const Spacer(),

//               // Footer section with subtle animation
//               SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0, 0.5),
//                   end: Offset.zero,
//                 ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
//                 child: FadeTransition(
//                   opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                     CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//                   ),
//                   child: _buildFooter(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleButton(ContactType type, Color color) {
//     final isSelected = _selectedType == type;
//     return GestureDetector(
//       onTap: () => _switchContactType(type),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(
//             color: isSelected ? color : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(type.icon, size: 18, color: isSelected ? color : Colors.grey[500]),
//             const SizedBox(width: 8),
//             Text(
//               type.label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                 color: isSelected ? color : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getToggleColor(ContactType type) {
//     return type == phoneType ? Colors.green : const Color(0xFF1E88E5);
//   }

//   Widget _buildFooter() {
//     return Column(
//       children: [
//         const Text(
//           'mygate',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w800,
//             color: Colors.black87,
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 32),
//         ...[
//           'Does not sell or trade your data',
//           'Is ISO 27001 certified for information security',
//           'Encrypts and secures your data',
//           'Is certified GDPR ready, the gold standard in data privacy',
//         ].map((text) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _PrivacyPoint(text: text),
//         )),
//         const SizedBox(height: 24),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () {}, // Handle navigation
//               child: const Text(
//                 'Privacy Policy',
//                 style: TextStyle(
//                   color: Color(0xFF1E88E5),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {}, // Handle navigation
//               child: const Text(
//                 'Terms & Conditions',
//                 style: TextStyle(
//                   color: Color(0xFF1E88E5),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _PrivacyPoint extends StatelessWidget {
//   final String text;

//   const _PrivacyPoint({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 6, right: 12),
//           width: 6,
//           height: 6,
//           decoration: const BoxDecoration(
//             color: Color(0xFF1E88E5),
//             shape: BoxShape.circle,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }





// // import 'package:flutter/material.dart';
// // import 'package:mygate_coepd/screens/auth/name_email_screen.dart';

// // class EnterEmailMobileScreen extends StatefulWidget {
// //   const EnterEmailMobileScreen({super.key});

// //   @override
// //   State<EnterEmailMobileScreen> createState() => _EnterEmailMobileScreenState();
// // }

// // class _EnterEmailMobileScreenState extends State<EnterEmailMobileScreen> {
// //   final TextEditingController _phoneController = TextEditingController();
// //   final FocusNode _phoneFocusNode = FocusNode();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(24.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Back button
// //               IconButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 icon: const Icon(Icons.arrow_back_ios, size: 20),
// //                 padding: EdgeInsets.zero,
// //                 constraints: const BoxConstraints(),
// //               ),
// //               const SizedBox(height: 40),
              
// //               // Title
// //               const Text(
// //                 'Get Started',
// //                 style: TextStyle(
// //                   fontSize: 28,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
              
// //               // Subtitle
// //               const Text(
// //                 'Please enter your mobile number to proceed further',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   color: Colors.grey,
// //                 ),
// //               ),
// //               const SizedBox(height: 40),
              
// //               // Phone number field
// //               Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey.shade300),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     // Country code
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
// //                       decoration: BoxDecoration(
// //                         border: Border(
// //                           right: BorderSide(color: Colors.grey.shade300),
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         '+91',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: TextField(
// //                         controller: _phoneController,
// //                         focusNode: _phoneFocusNode,
// //                         keyboardType: TextInputType.phone,
// //                         decoration: const InputDecoration(
// //                           border: InputBorder.none,
// //                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
// //                           hintText: 'Enter your mobile number',
// //                         ),
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 24),
              
// //               // Submit button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // Navigate to name and email screen
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => const NameEmailScreen(),
// //                       ),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF1E88E5),
// //                     foregroundColor: Colors.white,
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                   child: const Text(
// //                     'Submit',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
              
// //               // Use Email option
// //               Center(
// //                 child: TextButton(
// //                   onPressed: () {
// //                     // Handle email login
// //                   },
// //                   child: const Text(
// //                     'Use Email',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       color: Color(0xFF1E88E5),
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const Spacer(),
              
// //               // Footer section
// //               const Column(
// //                 children: [
// //                   Text(
// //                     'mygate',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   SizedBox(height: 24),
// //                   _PrivacyPoint(text: 'Does not sell or trade your data'),
// //                   SizedBox(height: 12),
// //                   _PrivacyPoint(text: 'Is ISO 27001 certified for information security'),
// //                   SizedBox(height: 12),
// //                   _PrivacyPoint(text: 'Encrypts and secures your data'),
// //                   SizedBox(height: 12),
// //                   _PrivacyPoint(text: 'Is certified GDPR ready, the gold standard in data privacy'),
// //                   SizedBox(height: 24),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       Text(
// //                         'Privacy Policy',
// //                         style: TextStyle(
// //                           color: Color(0xFF1E88E5),
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                       Text(
// //                         'Terms & Conditions',
// //                         style: TextStyle(
// //                           color: Color(0xFF1E88E5),
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _PrivacyPoint extends StatelessWidget {
// //   final String text;

// //   const _PrivacyPoint({required this.text});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           margin: const EdgeInsets.only(top: 4, right: 12),
// //           width: 8,
// //           height: 8,
// //           decoration: const BoxDecoration(
// //             color: Color(0xFF1E88E5),
// //             shape: BoxShape.circle,
// //           ),
// //         ),
// //         Expanded(
// //           child: Text(
// //             text,
// //             style: const TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }