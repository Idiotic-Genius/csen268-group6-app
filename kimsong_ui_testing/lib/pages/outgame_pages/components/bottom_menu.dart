import 'package:flutter/material.dart';

class BottomMenuButtons extends StatelessWidget {
  const BottomMenuButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Home Button
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: InkWell(
            child: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/home_button.png'),
            ),
            onTap: () => {
              // Do Something
            },
          ),
        ),
        const Spacer(),
        // Play/Settings Buttons
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
                // Do Something
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
                // Do Something
              },
            ),
          ],
        ),
        const Spacer(),
        // Profile Button
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: InkWell(
            child: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile_button.png'),
            ),
            onTap: () => {
              // Do something
            },
          ),
        ),
      ],
    );
  }
}
