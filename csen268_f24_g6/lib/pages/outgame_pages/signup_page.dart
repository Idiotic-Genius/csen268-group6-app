import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/login_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/authservice.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupPage({super.key});

  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  // Show error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Validate user input
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
        // Navigate to the home screen on successful signup
        print('User signed up successfully');
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundimage.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 400,
            height: 470,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Signup',
                  style: GoogleFonts.irishGrover(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Player's Name Field
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Player Name',
                ),
                const SizedBox(height: 10),
                // Email Field
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 15),
                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleSignup(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Signup',
                    style: GoogleFonts.irishGrover(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('Already have an account?');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Already have an account? ',
                          style: GoogleFonts.irishGrover(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Login',
                          style: GoogleFonts.irishGrover(
                            fontSize: 14,
                            color: const Color(0xFF0000EE),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      width: 282,
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.irishGrover(
            fontSize: 40,
            color: Colors.grey,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
