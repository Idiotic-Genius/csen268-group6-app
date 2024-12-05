import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WinLoseScreen extends StatelessWidget {
  final bool didWin;
   final String statType;  // true for win, false for lose

  const WinLoseScreen({
    Key? key,
    required this.didWin,
    required this.statType,
  }) : super(key: key);
   // Update stats when the game ends
  Future<void> _updateStats() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot userDoc = await userRef.get();
        if (userDoc.exists) {
          Map<String, dynamic> stats =
              userDoc['stats'] ?? {'gamesWon': 0, 'gamesLost': 0};

          // Increment the relevant stat
          stats[statType] = (stats[statType] ?? 0) + 1;

          // Update the stats in Firestore
          await userRef.update({'stats': stats});
        }
      } catch (e) {
        print("Error updating stats: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
      _updateStats();
    return Scaffold(
      body: Stack(
        children: [
          // Blurred Background
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), // Overlay dark color
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/daytime_background_1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // "You Win" or "You Lose" text
          Center(
            child: Image.asset(
              didWin
                  ? 'assets/images/you_win_text.png' // Win Asset
                  : 'assets/images/you_lose_text.png', // Lose Asset
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8, // 
            ),
          ),
          // Exit Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the Home Page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(), 
                    ),
                    (route) => false, 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Exit to Home",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
