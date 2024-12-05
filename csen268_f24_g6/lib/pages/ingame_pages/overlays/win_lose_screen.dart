import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../game_state.dart';

class WinLoseScreen extends StatelessWidget {
  final bool didWin;
  final String statType;
  final List<Character> characters;

  const WinLoseScreen({
    Key? key,
    required this.didWin,
    required this.statType,
    required this.characters,
  }) : super(key: key);

  String _getKillerName() {
    try {
      final killer = characters.firstWhere(
        (char) => char.role == "killer",
        orElse: () => Character(
          id: "unknown",
          name: "Unknown",
          role: "unknown",
          isAlive: false,
          spritePath: "",
        ),
      );
      return killer.name;
    } catch (e) {
      print("Error getting killer name: $e");
      return "Unknown";
    }
  }

  Future<void> _updateStats() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot userDoc = await userRef.get();
        if (userDoc.exists) {
          Map<String, dynamic> stats =
              (userDoc.data() as Map<String, dynamic>)['stats'] ?? 
              {'gamesWon': 0, 'gamesLost': 0};

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
                didWin
                  ? '/images/daytime_background.gif'
                  : '/images/nighttime_background.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // "You Win" or "You Lose" text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  didWin
                      ? 'assets/images/you_win_text.png'
                      : 'assets/images/you_lose_text.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(height: 20),
                Text(
                  "The killer was ${_getKillerName()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ],
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
