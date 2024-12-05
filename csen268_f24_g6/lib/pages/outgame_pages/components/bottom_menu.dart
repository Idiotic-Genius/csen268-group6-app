import 'package:csen268.f24.g6/pages/ingame_pages/daytime_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/game_settings_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'animated_inkwell_button.dart';
// import 'overlays/narrator_screen.dart';
import 'package:csen268.f24.g6/pages/ingame_pages/overlays/narrator_screen.dart';

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
    final String userId = currentUser?.uid ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Home or Yes Button
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: AnimatedButton(
            imageAsset: gameSettingsMode
                ? 'assets/images/yes_button.png'
                : 'assets/images/home_button.png',
            onTap: () {
              if (context.mounted) {
                if (gameSettingsMode) {
                  print("Yes button pressed");
                  // TODO: Save setting changes if any are made
                  if (ModalRoute.of(context)?.settings.name != '/home') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/home'),
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                } else {
                  print("Home button pressed");
                  if (ModalRoute.of(context)?.settings.name != '/home') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/home'),
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                }
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
                onTap: () {
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NarratorScreen(
                          onComplete: () {
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaytimePage(
                                    numPlayers: 5,
                                    numKillers: 1,
                                  ),
                                ),
                                (route) => false,  // This will clear the navigation stack
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
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
        // Profile or No Button
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: AnimatedButton(
            imageAsset: gameSettingsMode
                ? 'assets/images/no_button.png'
                : 'assets/images/profile_button.png',
            onTap: () {
              if (context.mounted) {
                if (gameSettingsMode) {
                  print("No button pressed");
                  if (ModalRoute.of(context)?.settings.name != '/home') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/home'),
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                } else {
                  print("Profile button pressed");
                  if (ModalRoute.of(context)?.settings.name != '/profile') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/profile'),
                        builder: (context) => ProfilePage(userId: userId),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
