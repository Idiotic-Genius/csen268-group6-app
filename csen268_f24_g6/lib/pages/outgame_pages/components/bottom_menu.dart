import 'package:csen268.f24.g6/pages/ingame_pages/daytime_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/game_settings_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomMenuButtons extends StatelessWidget {
  final bool gameSettingsMode;
  final bool enablePlaySettingButtons;

  const BottomMenuButtons({
    super.key,
    required this.gameSettingsMode,
    required this.enablePlaySettingButtons,
  });

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? ''; // Safely get user ID

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Home or Yes Button
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: InkWell(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                gameSettingsMode
                    ? 'assets/images/yes_button.png'
                    : 'assets/images/home_button.png',
              ),
            ),
            onTap: () {
              if (gameSettingsMode) {
                print("Yes button pressed");
              } else {
                print("Home button pressed");
              }
            },
          ),
        ),
        const Spacer(),
        // Play/Settings Buttons (disable if in game settings page)
        if (enablePlaySettingButtons)
          Column(
            children: [
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Image.asset(
                      'assets/images/play_button.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaytimePage(numPlayers: 5, numKillers: 1) // Navigate to ProfilePage
                  ),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Image.asset(
                      'assets/images/game_settings_button.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameSettingsPage(), // Navigate to ProfilePage
                  ),
                ),
              ),
            ],
          ),
        const Spacer(),
        // Profile Button
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: InkWell(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                gameSettingsMode
                    ? 'assets/images/no_button.png'
                    : 'assets/images/profile_button.png',
              ),
            ),
            onTap: () {
              if (gameSettingsMode) {
                print("No button pressed");
              } else {
                print("Profile button pressed");
                 print("User ID in BottomMenuButtons: $userId");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userId: userId,
                    ), // Navigate to ProfilePage
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
