import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in
          return HomePage();
        } else {
          // User is not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
