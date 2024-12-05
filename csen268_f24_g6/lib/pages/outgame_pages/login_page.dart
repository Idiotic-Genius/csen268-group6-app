import 'package:csen268.f24.g6/pages/outgame_pages/authservice.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> handleLogin(BuildContext context) async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and Password cannot be empty'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        print("User logged in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(), // Replace with your home page widget
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the device is in landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Set the width and height based on landscape or portrait mode
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Set a smaller container size for landscape mode (customize the size as per your need)
    final containerWidth = isLandscape ? (screenWidth * 0.5).toDouble() : 400.0;
    final containerHeight = isLandscape ? (screenHeight * 0.8).toDouble() : 410.0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundimage.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                // padding: const EdgeInsets.all(10),
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text(
                      'Login',
                      style: GoogleFonts.irishGrover(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 0),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        controller: _usernameController,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.irishGrover(fontSize: 25, color: Colors.black.withOpacity(1.0)),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.irishGrover(
                            fontSize: 35,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.irishGrover(fontSize: 25, color: Colors.black.withOpacity(1.0)),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          hintStyle: GoogleFonts.irishGrover(
                            fontSize: 35,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => handleLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Login',
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
                            print('First Time');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'First Time? ',
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
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Signup',
                              style: GoogleFonts.irishGrover(
                                fontSize: 14,
                                color: Color(0xFF0000EE),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}