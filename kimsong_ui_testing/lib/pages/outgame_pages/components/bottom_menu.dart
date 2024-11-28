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
                onTap: () => {
                  print("Pressed Play Button")
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
                onTap: () => {
                  print("Pressed Game Settings Button")
                },
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
              }
            },
          ),
        ),
      ],
    );
  }
}