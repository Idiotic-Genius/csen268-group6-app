import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added import
import '../game_state.dart';

class WinLoseScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ? 'assets/images/daytime_background.gif'
                    : 'assets/images/nighttime_background_1.jpeg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
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
                Text(
                  "The killer was ${_getKillerName()}",
                  style: customTextStyle(24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Reset the game state before going home
                    ref.read(gameStateProvider.notifier).reset();

                    // Navigate back to the Home Page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Exit to Home",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
