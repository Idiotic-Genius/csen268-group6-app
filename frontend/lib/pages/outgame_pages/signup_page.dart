import 'package:csen268.f24.g6/pages/outgame_pages/components/animated_elevated_button.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/background_image.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/login_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/authservice.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupPage({super.key});

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateInput(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showError(context, 'Player Name is required');
      return false;
    }

    if (email.isEmpty || !_isValidEmail(email)) {
      _showError(context, 'Invalid Email Address');
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      _showError(context, 'Password must be at least 6 characters long');
      return false;
    }

    return true;
  }

  // Handle signup logic
  Future<void> _handleSignup(BuildContext context) async {
    if (!_validateInput(context)) return;

    final authService = AuthService();
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    try {
      final user = await authService.signUp(email, password, name);
      if (user != null) {
        print('User signed up successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showError(context, 'Signup failed. Please try again.');
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Center(
            child: Container(
              padding: const EdgeInsets.all(0),
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Signup',
                    style: customTextStyle(48),
                  ),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'PlayerName',
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  AnimatedElevatedButton(
                    onPressed: () => _handleSignup(context),
                    isLoading: false,
                    buttonText: 'Signup',
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Already have an account?');
                        },
                        child: Text(
                          'Already have an account? ',
                          style: customTextStyle(14),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.irishGrover(
                            fontSize: 14,
                            color: const Color(0xFF0000EE),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: 300,
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.irishGrover(fontSize: 25, color: Colors.black.withOpacity(1.0)),
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: GoogleFonts.irishGrover(fontSize: 35, color: Colors.black.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
