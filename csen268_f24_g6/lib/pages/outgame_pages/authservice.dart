import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user (Sign Up) with additional data
  Future<User?> signUp(String email, String password, String playerName) async {
    print( email);

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After user is created, save additional data (player name) in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'playerName': playerName,
          'uid': user.uid,
          'stats': {
            'gamesWon': 0,
            'gamesLost': 0,
          }
        });
      }

      return user;
    } catch (e) {
      print("SignUp Error: $e");
      return null;
    }
  }

  // Login user
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

   // Update the user's stats (gamesWon or gamesLost)
  Future<void> updateUserStats(String userId, Map<String, dynamic> updatedStats) async {
    await _firestore.collection('users').doc(userId).update({
      'stats': updatedStats,
    });
  }
}

