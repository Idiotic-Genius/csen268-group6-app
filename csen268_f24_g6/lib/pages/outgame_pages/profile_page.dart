import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/authservice.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/background_image.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/bottom_menu.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/profile_stats.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/title_image.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String playerName = '';
  String email = '';
  Map<String, dynamic>? stats;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile data, check if stats exist, and initialize if missing
  Future<void> _loadUserProfile() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          playerName = userDoc['playerName'];
          email = userDoc['email'];
          stats = userDoc['stats'];
        });

        // If stats are missing or not initialized, set them to default values
        if (stats == null ||
            stats!['gamesWon'] == null ||
            stats!['gamesLost'] == null) {
          // Initialize stats
          Map<String, dynamic> defaultStats = {
            'gamesWon': 0,
            'gamesLost': 0,
          };
          await _authService.updateUserStats(widget.userId, defaultStats);
          setState(() {
            stats = defaultStats;
          });
        }
      }
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  // Display stats update (Games Won or Lost)
  Future<void> _updateStats(String statType) async {
    Map<String, dynamic> updatedStats = Map.from(stats!);

    if (statType == 'gamesWon') {
      updatedStats['gamesWon'] += 1;
    } else if (statType == 'gamesLost') {
      updatedStats['gamesLost'] += 1;
    }

    await _authService.updateUserStats(widget.userId, updatedStats);
    setState(() {
      stats = updatedStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundImage(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const TitleImages(
                    imagePaths: [
                      'assets/images/player_text.png',
                      'assets/images/profile_text.png'
                    ],
                    columnHeight: 100,
                  ),
                  const Spacer(),
                  PlayerStatsTextBox(
                   playerName: playerName,  // Use the fetched playerName here
                    gamesWon: stats?['gamesWon'] ?? 0,  // Get the actual value of gamesWon
                    gamesLost: stats?['gamesLost'] ?? 0
                  ),
                  const Spacer()
                ],
              ),
            ),
          ),

          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                print("logout tap executed");
                _showLogoutConfirmationDialog(context, _authService);
              },
              child: Image.asset(
                'assets/images/logout_icon.png', // Path to your logout image
                width: 40, // Adjust width as needed
                height: 40, // Adjust height as needed
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomMenuButtons(
                  gameSettingsMode: false,
                  enablePlaySettingButtons: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context, AuthService authService) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          // "No" Button: Closes the dialog
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("No"),
          ),
          // "Yes" Button: Logs out the user
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              authService.logout(); // Call the logout function
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
              ); // Navigate to login
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
